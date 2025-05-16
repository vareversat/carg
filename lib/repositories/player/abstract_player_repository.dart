import 'package:carg/models/player.dart';
import 'package:carg/repositories/base_repository.dart';

abstract class AbstractPlayerRepository extends BaseRepository<Player> {
  AbstractPlayerRepository({
    required super.database,
    required super.environment,
    required super.provider,
    super.lastFetchGameDocument,
  });

  /// Get the player of a particular user via hist/her/them [userId]
  /// Return the player or null if not found
  Future<Player?> getPlayerOfUser(String userId);
}
