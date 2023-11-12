import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/repositories/impl/game/coinche_belote_game_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'coinche_belote_game_repository_test.mocks.dart';

const uid = '123';
const userId = '123_user';
const playerId = '123_player';
const pageSize = 10;
const jsonCoincheBelote = {
  'starting_date': '2022-04-10 00:00:00.000',
  'players': {
    'player_list': ['p1', 'p2'],
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
    unsupportedMembers: {#data},
    fallbackGenerators: {
      #data: dataFunction,
    },
  )
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

  final game = CoincheBelote(
      id: uid,
      startingDate: DateTime.parse('2022-04-10 00:00:00.000'),
      players: BelotePlayers(playerList: ['p1', 'p2']));

  setUp(() {
    reset(instance);
    reset(mockQuery);
    reset(mockQuerySnapshot);
    reset(mockQueryDocumentSnapshot);
    reset(mockDocumentReference);
    reset(mockDocumentSnapshot);
    reset(mockCollectionReference);
  });

  group('CoincheBeloteGameRepository', () {
    group('Get Coinche Game', () {
      test('DEV', () async {
        const collection = 'coinche-game-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonCoincheBelote);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final coincheBeloteGameRepository =
            CoincheBeloteGameRepository(provider: instance);
        final coincheBelote = await coincheBeloteGameRepository.get(uid);
        expect(coincheBelote, game);
      });
      test('PROD', () async {
        const collection = 'coinche-game-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonCoincheBelote);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final coincheBeloteGameRepository = CoincheBeloteGameRepository(
            provider: instance, environment: 'prod');
        final coincheBelote = await coincheBeloteGameRepository.get(uid);
        expect(coincheBelote, game);
      });

      test('Throw exception', () async {
        const collection = 'coinche-game-prod';
        when(instance.collection(collection))
            .thenThrow(FirebaseException(plugin: 'test', message: 'test'));
        final coincheBeloteGameRepository = CoincheBeloteGameRepository(
            provider: instance, environment: 'prod');
        expect(coincheBeloteGameRepository.get(uid),
            throwsA(isA<RepositoryException>()));
      });
    });

    group('Get all game of user', () {
      test('DEV', () async {
        const collection = 'coinche-game-dev';
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
        final coincheBeloteGameRepository = CoincheBeloteGameRepository(
            provider: instance, lastFetchGameDocument: mockDocumentSnapshot);
        expect(
            await coincheBeloteGameRepository.getAllGamesOfPlayer(
                playerId, pageSize),
            <CoincheBelote>[]);
      });
      test('PRD', () async {
        const collection = 'coinche-game-prod';
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
        final coincheBeloteGameRepository = CoincheBeloteGameRepository(
            provider: instance,
            lastFetchGameDocument: mockDocumentSnapshot,
            environment: 'prod');
        expect(
            await coincheBeloteGameRepository.getAllGamesOfPlayer(
                playerId, pageSize),
            <CoincheBelote>[]);
      });

      test('Last fetched document not null', () async {
        const collection = 'coinche-game-prod';
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
        final coincheBeloteGameRepository = CoincheBeloteGameRepository(
            provider: instance, environment: 'prod');
        expect(
            await coincheBeloteGameRepository.getAllGamesOfPlayer(
                playerId, pageSize),
            <CoincheBelote>[]);
      });

      test('Last fetched document not null and return data', () async {
        const collection = 'coinche-game-prod';
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
        when(mockQueryDocumentSnapshot.data()).thenReturn(jsonCoincheBelote);
        when(mockQueryDocumentSnapshot.id).thenReturn(uid);
        final coincheBeloteGameRepository = CoincheBeloteGameRepository(
            provider: instance, environment: 'prod');
        expect(
            await coincheBeloteGameRepository.getAllGamesOfPlayer(
                playerId, pageSize),
            <CoincheBelote>[game]);
      });
    });
  });
}
