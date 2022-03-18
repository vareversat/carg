import 'package:carg/models/game/game.dart';
import 'package:carg/models/player.dart';
import 'package:carg/repositories/firebase_abstract_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractPlayerRepository
    extends FirebaseAbstractRepository<Player> {
  AbstractPlayerRepository()
      : super(
            database: 'player',
            environment:
                const String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
            provider: FirebaseFirestore.instance);

  /// Create new player in database with an non empty username
  /// Return the id of the newly created document
  Future<String> createPlayer(Player player);

  /// Get the player of a particular user via hist/her/them [userId]
  /// Return the player or null if not found
  Future<Player?> getPlayerOfUser(String userId);

  Future<void> incrementPlayedGamesByOne(String? id, Game game);

  Future<void> incrementWonGamesByOne(String? id, Game game);
}
