import 'package:carg/models/carg_object.dart';
import 'package:carg/repositories/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'base_repository_test.mocks.dart';

class FakeBaseRepository extends BaseRepository {
  FakeBaseRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider})
      : super(database: database, environment: environment, provider: provider);

  @override
  Future<CargObject?> get(String id) {
    throw UnimplementedError();
  }
}

class FakeCargObject extends CargObject {
  FakeCargObject({String? id}) : super(id: id);

  @override
  Map<String, dynamic> toJSON() {
    return {'id': id};
  }
}

const uid = '123';

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

  group('BaseRepository', () {
    test('Delete', () async {
      var collection = 'fake-collection-dev';
      when(instance.collection(collection)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(uid)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.delete()).thenAnswer((_) async => {});
      final fakeRepository = FakeBaseRepository(
          provider: instance, database: 'fake-collection', environment: 'dev');
      await fakeRepository.delete(uid);
    });

    test('Update on field', () async {
      var collection = 'fake-collection-dev';
      when(instance.collection(collection)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(uid)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.update({'myField': 0}))
          .thenAnswer((_) async => {});
      final fakeRepository = FakeBaseRepository(
          provider: instance, database: 'fake-collection', environment: 'dev');
      await fakeRepository.updateField(uid, 'myField', 0);
    });

    test('Update', () async {
      var collection = 'fake-collection-dev';
      var cargObject = FakeCargObject(id: 'myId');
      when(instance.collection(collection)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc('myId'))
          .thenReturn(mockDocumentReference);
      when(mockDocumentReference.update({'id': 'myId'}))
          .thenAnswer((_) async => {});
      final fakeRepository = FakeBaseRepository(
          provider: instance, database: 'fake-collection', environment: 'dev');
      await fakeRepository.update(cargObject);
    });

    test('Partial update', () async {
      var collection = 'fake-collection-dev';
      var cargObject = FakeCargObject(id: 'myId');
      when(instance.collection(collection)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc('myId'))
          .thenReturn(mockDocumentReference);
      when(mockDocumentReference.update({'myField': 'myValue', 'mySecondField': 0}))
          .thenAnswer((_) async => {});
      final fakeRepository = FakeBaseRepository(
          provider: instance, database: 'fake-collection', environment: 'dev');
      await fakeRepository.partialUpdate(cargObject, {'myField': 'myValue', 'mySecondField': 0});
    });

    test('Create', () async {
      var collection = 'fake-collection-dev';
      var cargObject = FakeCargObject(id: 'myId');
      when(instance.collection(collection)).thenReturn(mockCollectionReference);
      when(mockCollectionReference.add({'id': 'myId'}))
          .thenAnswer((_) async => mockDocumentReference);
      when(mockDocumentReference.id).thenReturn('myId');
      final fakeRepository = FakeBaseRepository(
          provider: instance, database: 'fake-collection', environment: 'dev');
      final id = await fakeRepository.create(cargObject);
      expect(id, 'myId');
    });
  });
}
