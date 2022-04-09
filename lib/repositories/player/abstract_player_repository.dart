import 'package:carg/models/player.dart';
import 'package:carg/repositories/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractPlayerRepository extends BaseRepository<Player> {
  AbstractPlayerRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider})
      : super(database: database, environment: environment, provider: provider);

  /// Get the player of a particular user via hist/her/them [userId]
  /// Return the player or null if not found
  Future<Player?> getPlayerOfUser(String userId);
}
