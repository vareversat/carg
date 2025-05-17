import 'package:carg/models/game/game.dart';
import 'package:carg/repositories/base_repository.dart';

abstract class AbstractGameRepository<T extends Game>
    extends BaseRepository<T> {
  AbstractGameRepository({
    required super.database,
    required super.environment,
    required super.provider,
    super.lastFetchGameDocument,
  });

  /// Get all the games [T] from the index
  /// Return a list [T] of game
  Future<List<T>> getAllGamesOfPlayer(String playerId, int pageSize);
}
