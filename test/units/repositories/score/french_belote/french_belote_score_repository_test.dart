import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/repositories/impl/score/french_belote_score_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'french_belote_score_repository_test.mocks.dart';

const uid = '123';
const userId = '123_user';
const gameId = '123_game';
const frenchBeloteScoreJson = {
  'id': uid,
  'game': gameId,
};
final expectedScore = FrenchBeloteScore(id: uid, game: gameId);

Map<String, dynamic> dataFunction() => {};

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QuerySnapshot,
  Query,
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

  setUp(() {
    reset(instance);
    reset(mockQuery);
    reset(mockQuerySnapshot);
    reset(mockQueryDocumentSnapshot);
    reset(mockDocumentReference);
    reset(mockDocumentSnapshot);
    reset(mockCollectionReference);
  });

  group('FrenchBeloteScoreRepository', () {
    group('Get Player', () {
      test('DEV', () async {
        var collection = 'belote-score-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(frenchBeloteScoreJson);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final frenchBeloteScoreRepository =
            FrenchBeloteScoreRepository(provider: instance);
        final frenchBeloteScore = await frenchBeloteScoreRepository.get(uid);
        expect(frenchBeloteScore, expectedScore);
      });
      test('PROD', () async {
        var collection = 'belote-score-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(frenchBeloteScoreJson);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final frenchBeloteScoreRepository = FrenchBeloteScoreRepository(
            provider: instance, environment: 'prod');
        final frenchBeloteScore = await frenchBeloteScoreRepository.get(uid);
        expect(frenchBeloteScore, expectedScore);
      });
    });

    group('Get Score by game', () {
      test('DEV', () async {
        var collection = 'belote-score-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('game', isEqualTo: gameId))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data())
            .thenReturn(frenchBeloteScoreJson);
        when(mockQueryDocumentSnapshot.id).thenReturn(uid);
        final frenchBeloteScoreRepository =
            FrenchBeloteScoreRepository(provider: instance);
        final frenchBeloteScore =
            await frenchBeloteScoreRepository.getScoreByGame(gameId);
        expect(frenchBeloteScore, expectedScore);
      });
      test('PROD', () async {
        var collection = 'belote-score-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('game', isEqualTo: gameId))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data())
            .thenReturn(frenchBeloteScoreJson);
        when(mockQueryDocumentSnapshot.id).thenReturn(uid);
        final frenchBeloteScoreRepository = FrenchBeloteScoreRepository(
            provider: instance, environment: 'prod');
        final frenchBeloteScore =
            await frenchBeloteScoreRepository.getScoreByGame(gameId);
        expect(frenchBeloteScore, expectedScore);
      });
    });
  });
}
