import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/repositories/impl/game/french_belote_game_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'french_belote_game_repository_test.mocks.dart';

const uid = '123';
const userId = '123_user';
const playerId = '123_player';
const pageSize = 10;
const jsonFrenchBelote = {
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

  final game = FrenchBelote(
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

  group('FrenchBeloteGameRepository', () {
    group('Get French belote Game', () {
      test('DEV', () async {
        const collection = 'belote-game-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonFrenchBelote);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final frenchBeloteGameRepository =
            FrenchBeloteGameRepository(provider: instance);
        final frenchBelote = await frenchBeloteGameRepository.get(uid);
        expect(frenchBelote, game);
      });
      test('PROD', () async {
        const collection = 'belote-game-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonFrenchBelote);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final frenchBeloteGameRepository =
            FrenchBeloteGameRepository(provider: instance, environment: 'prod');
        final frenchBelote = await frenchBeloteGameRepository.get(uid);
        expect(frenchBelote, game);
      });

      test('Throw exception', () async {
        const collection = 'belote-game-prod';
        when(instance.collection(collection))
            .thenThrow(FirebaseException(plugin: 'test', message: 'test'));
        final frenchBeloteGameRepository =
            FrenchBeloteGameRepository(provider: instance, environment: 'prod');
        expect(frenchBeloteGameRepository.get(uid),
            throwsA(isA<RepositoryException>()));
      });
    });

    group('Get all game of user', () {
      test('DEV', () async {
        const collection = 'belote-game-dev';
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
        final frenchBeloteGameRepository = FrenchBeloteGameRepository(
            provider: instance, lastFetchGameDocument: mockDocumentSnapshot);
        expect(
            await frenchBeloteGameRepository.getAllGamesOfPlayer(
                playerId, pageSize),
            <FrenchBelote>[]);
      });
      test('PRD', () async {
        const collection = 'belote-game-prod';
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
        final frenchBeloteGameRepository = FrenchBeloteGameRepository(
            provider: instance,
            lastFetchGameDocument: mockDocumentSnapshot,
            environment: 'prod');
        expect(
            await frenchBeloteGameRepository.getAllGamesOfPlayer(
                playerId, pageSize),
            <FrenchBelote>[]);
      });

      test('Last fetched document not null', () async {
        const collection = 'belote-game-prod';
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
        final frenchBeloteGameRepository =
            FrenchBeloteGameRepository(provider: instance, environment: 'prod');
        expect(
            await frenchBeloteGameRepository.getAllGamesOfPlayer(
                playerId, pageSize),
            <FrenchBelote>[]);
      });

      test('Last fetched document not null and return data', () async {
        const collection = 'belote-game-prod';
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
        when(mockQueryDocumentSnapshot.data()).thenReturn(jsonFrenchBelote);
        when(mockQueryDocumentSnapshot.id).thenReturn(uid);
        final frenchBeloteGameRepository =
            FrenchBeloteGameRepository(provider: instance, environment: 'prod');
        expect(
            await frenchBeloteGameRepository.getAllGamesOfPlayer(
                playerId, pageSize),
            <FrenchBelote>[game]);
      });
    });
  });
}
