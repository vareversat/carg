import 'package:carg/models/iap/iap_source_enum.dart';
import 'package:carg/models/iap/product/product_type_enum.dart';
import 'package:carg/models/iap/purchase/non_subscription_purchase.dart';
import 'package:carg/models/iap/purchase/non_subscription_status_enum.dart';
import 'package:carg/repositories/impl/iap_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'iap_repository_test.mocks.dart';

const id = '123';
const userId = 'FQcEdrEwghWU1p2AKO8MVfh8pe72';

const jsonIAP = {
  'iap_source': "google_play",
  'order_id': 'GPA.3309-0924-5376-12025',
  'product_id': 'carg.free.ads',
  'purchase_date': '2022-09-23T00:00:00.000Z',
  'status': 'purchased',
  'type': 'nonSubscription',
  'user_id': 'FQcEdrEwghWU1p2AKO8MVfh8pe72'
};
final expectedIAP = NonSubscriptionPurchase(
    id: '123',
    iapSource: IAPSourceEnum.google_play,
    orderId: 'GPA.3309-0924-5376-12025',
    productId: 'carg.free.ads',
    userId: 'FQcEdrEwghWU1p2AKO8MVfh8pe72',
    purchaseDate: DateTime.parse('2022-09-23T00:00:00.000Z'),
    type: ProductTypeEnum.nonSubscription,
    status: NonSubscriptionStatusEnum.purchased);

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

  group('IAPRepository - ', () {
    group('Get IAP', () {
      test('DEV', () async {
        var collection = 'iap-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(id)).thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonIAP);
        when(mockDocumentSnapshot.id).thenReturn(id);
        final iapRepository = IAPRepository(provider: instance);
        final iap = await iapRepository.get(id);
        expect(iap, expectedIAP);
      });
      test('PRD', () async {
        var collection = 'iap-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.doc(id)).thenReturn(mockDocumentReference);
        when(mockDocumentReference.get())
            .thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.data()).thenReturn(jsonIAP);
        when(mockDocumentSnapshot.id).thenReturn(id);
        final iapRepository =
            IAPRepository(provider: instance, environment: 'prod');
        final iap = await iapRepository.get(id);
        expect(iap, expectedIAP);
      });
    });

    group('Get by userId', () {
      test('DEV', () async {
        var collection = 'iap-dev';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('user_id', isEqualTo: userId))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(jsonIAP);
        when(mockQueryDocumentSnapshot.id).thenReturn(id);
        final iapRepository = IAPRepository(provider: instance);
        final iap = await iapRepository.getByUserId(userId);
        expect(iap, expectedIAP);
      });
      test('PROD', () async {
        var collection = 'iap-prod';
        when(instance.collection(collection))
            .thenReturn(mockCollectionReference);
        when(mockCollectionReference.where('user_id', isEqualTo: userId))
            .thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(jsonIAP);
        when(mockQueryDocumentSnapshot.id).thenReturn(id);
        final iapRepository =
            IAPRepository(provider: instance, environment: 'prod');
        final iap = await iapRepository.getByUserId(userId);
        expect(iap, expectedIAP);
      });
    });

    group('Create OR Update', () {
      group('Update', () {
        test('DEV', () async {
          var collection = 'iap-dev';
          when(instance.collection(collection))
              .thenReturn(mockCollectionReference);
          when(mockCollectionReference.doc(id))
              .thenReturn(mockDocumentReference);
          when(mockDocumentReference.update(jsonIAP))
              .thenAnswer((_) async => {});
          when(mockCollectionReference.where('user_id', isEqualTo: userId))
              .thenReturn(mockQuery);
          when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
          when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
          when(mockQueryDocumentSnapshot.data()).thenReturn(jsonIAP);
          when(mockQueryDocumentSnapshot.id).thenReturn(id);
          final iapRepository = IAPRepository(provider: instance);
          final iapId = await iapRepository.createOrUpdate(expectedIAP);
          expect(iapId, id);
        });
        test('PROD', () async {
          var collection = 'iap-prod';
          when(instance.collection(collection))
              .thenReturn(mockCollectionReference);
          when(mockCollectionReference.doc(id))
              .thenReturn(mockDocumentReference);
          when(mockDocumentReference.update(jsonIAP))
              .thenAnswer((_) async => {});
          when(mockCollectionReference.where('user_id', isEqualTo: userId))
              .thenReturn(mockQuery);
          when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
          when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
          when(mockQueryDocumentSnapshot.data()).thenReturn(jsonIAP);
          when(mockQueryDocumentSnapshot.id).thenReturn(id);
          final iapRepository =
              IAPRepository(provider: instance, environment: 'prod');
          final iapId = await iapRepository.createOrUpdate(expectedIAP);
          expect(iapId, id);
        });
      });
      group('Create', () {
        test('DEV', () async {
          var collection = 'iap-dev';
          when(instance.collection(collection))
              .thenReturn(mockCollectionReference);
          when(mockCollectionReference.add(jsonIAP))
              .thenAnswer((_) async => mockDocumentReference);
          when(mockDocumentReference.id).thenReturn(id);
          when(mockCollectionReference.where('user_id', isEqualTo: userId))
              .thenReturn(mockQuery);
          when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
          when(mockQuerySnapshot.docs).thenReturn([]);
          final iapRepository = IAPRepository(provider: instance);
          final iapId = await iapRepository.createOrUpdate(expectedIAP);
          expect(iapId, id);
        });
        test('PROD', () async {
          var collection = 'iap-prod';
          when(instance.collection(collection))
              .thenReturn(mockCollectionReference);
          when(mockCollectionReference.add(jsonIAP))
              .thenAnswer((_) async => mockDocumentReference);
          when(mockDocumentReference.id).thenReturn(id);
          when(mockCollectionReference.where('user_id', isEqualTo: userId))
              .thenReturn(mockQuery);
          when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
          when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
          when(mockQuerySnapshot.docs).thenReturn([]);
          final iapRepository =
              IAPRepository(provider: instance, environment: 'prod');
          final iapId = await iapRepository.createOrUpdate(expectedIAP);
          expect(iapId, id);
        });
      });
    });
  });
}
