import 'package:carg/models/player.dart';
import 'package:carg/repositories/base_abstract_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractPlayerRepository
    extends BaseAbstractRepository<Player> {
  AbstractPlayerRepository()
      : super(database: 'player', environment: const String.fromEnvironment('FLAVOR', defaultValue: 'dev'), provider: FirebaseFirestore.instance);

  /// Get the player of a particular user via hist/her/them [userId]
  /// Return the player or null if not found
  Future<Player?> getPlayerOfUser(String userId);
}
