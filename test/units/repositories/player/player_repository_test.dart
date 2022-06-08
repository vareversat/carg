import 'package:carg/models/player.dart';
import 'package:carg/repositories/impl/player_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'player_repository_test.mocks.dart';

const uid = '123';
const userId = '123_user';
const jsonPlayer = {
  'user_name': 'Test',
  'owned': false,
  'profile_picture':
      'https://firebasestorage.googleapis.com/v0/b/carg-d3732.appspot.com/o/carg_logo.png?alt=media&token=861511da-db26-4216-8ee6-29b20c0a6852',
  'linked_user_id': userId
};
final expectedPlayer =
    Player(id: uid, userName: 'Test', owned: false, linkedUserId: userId);

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

  setUp(() {
    reset(instance);
    reset(mockQuery);
    reset(mockQuerySnapshot);
    reset(mockQueryDocumentSnapshot);
    reset(mockDocumentReference);
    reset(mockDocumentSnapshot);
    reset(mockCollectionReference);
  });

  group('PlayerRepository', () {
    group('Get Player', () {
      test('DEV', () async {
        var collection = 'player-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonPlayer);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final playerRepository = PlayerRepository(provider: instance);
        final player = await playerRepository.get(uid);
        expect(player, expectedPlayer);
      });
      test('PROD', () async {
        var collection = 'player-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonPlayer);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final playerRepository =
            PlayerRepository(provider: instance, environment: 'prod');
        final player = await playerRepository.get(uid);
        expect(player, expectedPlayer);
      });
    });

    group('Get Player of User', () {
      test('DEV', () async {
        var collection = 'player-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('linked_user_id', isEqualTo: userId))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(jsonPlayer);
        when(mockQueryDocumentSnapshot.id).thenReturn(uid);
        final playerRepository = PlayerRepository(provider: instance);
        final player = await playerRepository.getPlayerOfUser(userId);
        expect(player, expectedPlayer);
      });
      test('PROD', () async {
        var collection = 'player-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('linked_user_id', isEqualTo: userId))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(jsonPlayer);
        when(mockQueryDocumentSnapshot.id).thenReturn(uid);
        final playerRepository =
            PlayerRepository(provider: instance, environment: 'prod');
        final player = await playerRepository.getPlayerOfUser(userId);
        expect(player, expectedPlayer);
      });
    });
  });
}
