import 'package:carg/models/iap/purchase/purchase.dart';
import 'package:carg/repositories/base_repository.dart';

abstract class AbstractIAPRepository extends BaseRepository<Purchase> {
  AbstractIAPRepository({
    required super.database,
    required super.environment,
    required super.provider,
  });

  /// Get a purchase by user ID
  /// If no team exists, return null
  Future<Purchase?> getByUserId(String userId);

  /// Create a [Purchase] object in the database in it does not exist
  /// Return the associated ID
  Future<String> createOrUpdate(Purchase p);
}
