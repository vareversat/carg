import 'package:carg/const.dart';
import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/iap/product/product_type_enum.dart';
import 'package:carg/models/iap/purchase/non_subscription_purchase.dart';
import 'package:carg/models/iap/purchase/purchase.dart';
import 'package:carg/models/iap/purchase/subscription_purchase.dart';
import 'package:carg/repositories/abstract_iap_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

class IAPRepository extends AbstractIAPRepository {
  IAPRepository({
    String? database,
    String? environment,
    FirebaseFirestore? provider,
  }) : super(
         database: database ?? Const.purchaseDB,
         environment:
             environment ??
             const String.fromEnvironment(
               Const.dartVarEnv,
               defaultValue: Const.defaultEnv,
             ),
         provider: provider ?? FirebaseFirestore.instance,
       );

  Purchase? _buildWithCorrectInstance(
    ProductTypeEnum? type,
    Map<String, dynamic>? data,
    String id,
  ) {
    switch (type) {
      case ProductTypeEnum.nonSubscription:
        return NonSubscriptionPurchase.fromJSON(data, id);
      case ProductTypeEnum.subscription:
        return SubscriptionPurchase.fromJSON(data, id);
      default:
        return null;
    }
  }

  @override
  Future<Purchase?> get(String id) async {
    try {
      var querySnapshot =
          await provider.collection(connectionString).doc(id).get();
      if (querySnapshot.data() != null) {
        var type = EnumToString.fromString(
          ProductTypeEnum.values,
          querySnapshot.data()!['type'],
        );
        return _buildWithCorrectInstance(
          type,
          querySnapshot.data(),
          querySnapshot.id,
        );
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  @override
  Future<Purchase?> getByUserId(String userId) async {
    try {
      var querySnapshot =
          await provider
              .collection(connectionString)
              .where('user_id', isEqualTo: userId)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        var type = EnumToString.fromString(
          ProductTypeEnum.values,
          querySnapshot.docs.first.data()['type'],
        );
        return _buildWithCorrectInstance(
          type,
          querySnapshot.docs.first.data(),
          querySnapshot.docs.first.id,
        );
      }
      return null;
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  @override
  Future<String> createOrUpdate(Purchase p) async {
    try {
      Purchase? doc = await getByUserId(p.userId!);
      if (doc == null) {
        /// If no doc exists, create a new one
        return await create(p);
      } else {
        /// If doc exists, update it
        p.id = doc.id;
        await update(p);
        return p.id!;
      }
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }
}
