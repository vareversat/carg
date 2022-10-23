import 'package:carg/models/iap/purchase/purchase.dart';
import 'package:carg/repositories/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractIAPRepository extends BaseRepository<Purchase> {
  AbstractIAPRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider})
      : super(database: database, environment: environment, provider: provider);


  /// Get a purchase by user ID
  /// If no team exists, return null
  Future<Purchase?> getByUserId(String userId);

  /// Create a [Purchase] object in the database in it does not exist
  /// Return the associated ID
  Future<String> createOrUpdate(Purchase p);
}
