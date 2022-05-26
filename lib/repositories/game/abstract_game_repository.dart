import 'package:carg/models/game/game.dart';
import 'package:carg/repositories/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractGameRepository<T extends Game>
    extends BaseRepository<T> {

  AbstractGameRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider,
      DocumentSnapshot? lastFetchGameDocument})
      : super(database: database, environment: environment, provider: provider);

  /// Get all the games [T] from the index
  /// Return a list [T] of game
  Future<List<T>> getAllGamesOfPlayer(String playerId, int pageSize);
}
