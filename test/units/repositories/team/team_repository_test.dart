import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/impl/team_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'team_repository_test.mocks.dart';

const uid = '123';
var playerIds = ['p1', 'p2'];
const jsonTeam = {
  'won_games': 0,
  'played_games': 1,
  'players': ['p1', 'p2']
};
final expectedTeam =
    Team(id: uid, wonGames: 0, playedGames: 1, players: ['p1', 'p2']);

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

  group('TeamRepository - ', () {
    group('Get Team', () {
      test('DEV', () async {
        var collection = 'team-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonTeam);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final teamRepository = TeamRepository(provider: instance);
        final team = await teamRepository.get(uid);
        expect(team, expectedTeam);
      });
      test('PROD', () async {
        var collection = 'team-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(uid))
            .thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonTeam);
        when(mockDocumentSnapshot.id).thenReturn(uid);
        final teamRepository =
            TeamRepository(provider: instance, environment: 'prod');
        final team = await teamRepository.get(uid);
        expect(team, expectedTeam);
      });
    });

    group('Get by players', () {
      test('DEV', () async {
        var collection = 'team-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('players', isEqualTo: playerIds))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(jsonTeam);
        when(mockQueryDocumentSnapshot.id).thenReturn(uid);
        final teamRepository = TeamRepository(provider: instance);
        final team = await teamRepository.getTeamByPlayers(['p2', 'p1']);
        expect(team, expectedTeam);
      });
      test('PROD', () async {
        var collection = 'team-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('players', isEqualTo: playerIds))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(jsonTeam);
        when(mockQueryDocumentSnapshot.id).thenReturn(uid);
        final teamRepository =
            TeamRepository(provider: instance, environment: 'prod');
        final team = await teamRepository.getTeamByPlayers(['p2', 'p1']);
        expect(team, expectedTeam);
      });
    });

    group('Create with players', () {
      test('Team exists', () async {
        var collection = 'team-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('players', isEqualTo: playerIds))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(jsonTeam);
        when(mockQueryDocumentSnapshot.id).thenReturn(uid);
        final teamRepository = TeamRepository(provider: instance);
        expect(teamRepository.createTeamWithPlayers(['p2', 'p1']),
            throwsA(isA<RepositoryException>()));
      });
      test('Team does not exist', () async {
        var collection = 'team-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('players', isEqualTo: playerIds))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);
        when(mockCollectionReference.add({
          'name': null,
          'games': null,
          'won_games': 0,
          'played_games': 1,
          'players': ['p1', 'p2']
        })).thenAnswer((_) async => mockDocumentReference);
        when(mockDocumentReference.id).thenReturn(uid);

        final teamRepository =
            TeamRepository(provider: instance, environment: 'prod');
        final team = await teamRepository.createTeamWithPlayers(['p2', 'p1']);
        expect(team, expectedTeam);
      });
    });
  });
}
