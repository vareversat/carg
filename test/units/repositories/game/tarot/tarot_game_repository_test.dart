import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/players/tarot_players.dart';
import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/repositories/impl/game/tarot_game_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tarot_game_repository_test.mocks.dart';

const uid = '123';
const userId = '123_user';
const playerId = '123_player';
const pageSize = 10;
const jsonTarot = {
  'starting_date': '2022-04-10 00:00:00.000',
  'players': {
    "player_list": ['p1', 'p2']
  }
};

Map<String, dynamic> dataFunction() => {};

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QuerySnapshot,
  Query
], customMocks: [
  MockSpec<QueryDocumentSnapshot>(
      unsupportedMembers: {#data}, fallbackGenerators: {#data: dataFunction})
])
void main() {
  final instance = MockFirebaseFirestore();
  final mockQuery = MockQuery<Map<String, dynamic>>();
  final mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
  final mockQueryDocumentSnapshot =
      MockQueryDocumentSnapshot<Map<String, dynamic>>();
  final mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
  final mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
  final mockCollectionReference =
      MockCollectionReference<Map<String, dynamic>>();

  final game = Tarot(
      id: uid,
      startingDate: DateTime.parse('2022-04-10 00:00:00.000'),
      players: TarotPlayers(playerList: ['p1', 'p2']));

  setUp(() {
    reset(instance);
    reset(mockQuery);
    reset(mockQuerySnapshot);
    reset(mockQueryDocumentSnapshot);
    reset(mockDocumentReference);
    reset(mockDocumentSnapshot);
    reset(mockCollectionReference);
  });

  group('TarotGameRepository', () {
    group('Get Tarot Game', () {
      test('DEV', () async {
        const collection = 'tarot-game-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonTarot);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final tarotRepository = TarotGameRepository(provider: instance);
        final tarot = await tarotRepository.get(uid);
        expect(tarot, game);
      });
      test('PROD', () async {
        const collection = 'tarot-game-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonTarot);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final tarotRepository =
            TarotGameRepository(provider: instance, environment: 'prod');
        final tarot = await tarotRepository.get(uid);
        expect(tarot, game);
      });

      test('Throw exception', () async {
        const collection = 'tarot-game-prod';
        when(instance.collection(collection))
            .thenThrow(FirebaseException(plugin: 'test', message: 'test'));
        final tarotRepository =
            TarotGameRepository(provider: instance, environment: 'prod');
        expect(tarotRepository.get(uid), throwsA(isA<RepositoryException>()));
      });
    });

    group('End a game', () {
      test('DEV', () async {
        final winners = TarotPlayerScore(score: 10, player: 'player_id');
        const collection = 'tarot-game-dev';
        final now = DateTime.now();
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        final tarotRepository = TarotGameRepository(provider: instance);
        await tarotRepository.endAGame(game, winners, now);
        verify(mockDocumentReference.update({
          'is_ended': true,
          'ending_date': now.toString(),
          'winners': winners.player
        })).called(1);
      });
      test('PRD', () async {
        final winners = TarotPlayerScore(score: 10, player: 'player_id');
        const collection = 'tarot-game-prod';
        final now = DateTime.now();
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        final tarotRepository =
            TarotGameRepository(provider: instance, environment: 'prod');
        await tarotRepository.endAGame(game, winners, now);
        verify(mockDocumentReference.update({
          'is_ended': true,
          'ending_date': now.toString(),
          'winners': winners.player
        })).called(1);
      });
      test('Throw exception', () async {
        final winners = TarotPlayerScore(score: 10, player: 'player_id');
        const collection = 'tarot-game-prod';
        final now = DateTime.now();
        when(instance.collection(collection))
            .thenThrow(FirebaseException(plugin: 'test', message: 'test'));
        final tarotRepository =
            TarotGameRepository(provider: instance, environment: 'prod');
        expect(tarotRepository.endAGame(game, winners, now),
            throwsA(isA<RepositoryException>()));
      });
    });

    group('Get all game of user', () {
      test('DEV', () async {
        const collection = 'tarot-game-dev';
        final mockQueryFromOrderBy = MockQuery<Map<String, dynamic>>();
        final mockQueryFromStartAfterDocument =
            MockQuery<Map<String, dynamic>>();
        final mockQueryFromLimit = MockQuery<Map<String, dynamic>>();
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('players.player_list',
                arrayContains: playerId))
            .thenReturn(mockQuery);
        when(mockQuery.orderBy('starting_date', descending: true))
            .thenReturn(mockQueryFromOrderBy);
        when(mockQueryFromOrderBy.startAfterDocument(mockDocumentSnapshot))
            .thenReturn(mockQueryFromStartAfterDocument);
        when(mockQueryFromStartAfterDocument.limit(pageSize))
            .thenReturn(mockQueryFromLimit);
        when(mockQueryFromLimit.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);
        final tarotRepository = TarotGameRepository(
            provider: instance, lastFetchGameDocument: mockDocumentSnapshot);
        expect(await tarotRepository.getAllGamesOfPlayer(playerId, pageSize),
            <Tarot>[]);
      });
      test('PRD', () async {
        const collection = 'tarot-game-prod';
        final mockQueryFromOrderBy = MockQuery<Map<String, dynamic>>();
        final mockQueryFromStartAfterDocument =
            MockQuery<Map<String, dynamic>>();
        final mockQueryFromLimit = MockQuery<Map<String, dynamic>>();
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('players.player_list',
                arrayContains: playerId))
            .thenReturn(mockQuery);
        when(mockQuery.orderBy('starting_date', descending: true))
            .thenReturn(mockQueryFromOrderBy);
        when(mockQueryFromOrderBy.startAfterDocument(mockDocumentSnapshot))
            .thenReturn(mockQueryFromStartAfterDocument);
        when(mockQueryFromStartAfterDocument.limit(pageSize))
            .thenReturn(mockQueryFromLimit);
        when(mockQueryFromLimit.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);
        final tarotRepository = TarotGameRepository(
            provider: instance,
            lastFetchGameDocument: mockDocumentSnapshot,
            environment: 'prod');
        expect(await tarotRepository.getAllGamesOfPlayer(playerId, pageSize),
            <Tarot>[]);
      });

      test('Last fetched document not null', () async {
        const collection = 'tarot-game-prod';
        final mockQueryFromOrderBy = MockQuery<Map<String, dynamic>>();
        final mockQueryFromLimit = MockQuery<Map<String, dynamic>>();
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('players.player_list',
                arrayContains: playerId))
            .thenReturn(mockQuery);
        when(mockQuery.orderBy('starting_date', descending: true))
            .thenReturn(mockQueryFromOrderBy);
        when(mockQueryFromOrderBy.limit(pageSize))
            .thenReturn(mockQueryFromLimit);
        when(mockQueryFromLimit.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);
        final tarotRepository =
            TarotGameRepository(provider: instance, environment: 'prod');
        expect(await tarotRepository.getAllGamesOfPlayer(playerId, pageSize),
            <Tarot>[]);
      });

      test('Last fetched document not null and return data', () async {
        const collection = 'tarot-game-prod';
        final mockQueryFromOrderBy = MockQuery<Map<String, dynamic>>();
        final mockQueryFromLimit = MockQuery<Map<String, dynamic>>();
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('players.player_list',
                arrayContains: playerId))
            .thenReturn(mockQuery);
        when(mockQuery.orderBy('starting_date', descending: true))
            .thenReturn(mockQueryFromOrderBy);
        when(mockQueryFromOrderBy.limit(pageSize))
            .thenReturn(mockQueryFromLimit);
        when(mockQueryFromLimit.get())
            .thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(jsonTarot);
        when(mockQueryDocumentSnapshot.id).thenReturn(uid);
        final tarotRepository =
            TarotGameRepository(provider: instance, environment: 'prod');
        expect(await tarotRepository.getAllGamesOfPlayer(playerId, pageSize),
            <Tarot>[game]);
      });
    });
  });
}
