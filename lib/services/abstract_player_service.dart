import 'package:carg/models/game/game.dart';
import 'package:carg/models/player.dart';
import 'package:carg/repositories/abstract_player_repository.dart';
import 'package:carg/services/base_abstract_service.dart';

abstract class AbstractPlayerService extends BaseAbstractService<Player> {
  final AbstractPlayerRepository playerRepository;

  AbstractPlayerService({required this.playerRepository}): super(repository: playerRepository);

  /// Create new player in database with an non empty username
  /// Return the id of the newly created document
  Future<String> createPlayer(Player player);

  /// Increment the number of played games by 1
  /// Take the [playerId] and the [game]
  Future<void> incrementPlayedGamesByOne(String playerId, Game game);

  /// Increment the number of won games by 1
  /// Take the [playerId] and the [game]
  Future<void> incrementWonGamesByOne(String playerId, Game game);

  /// Get the player of a particular user via his/her/them [userId]
  /// Return the player or null if not found
  Future<Player?> getPlayerOfUser(String? userId);

  /// Search players into the index
  /// Return the player or null if not found
  Future<List<Player>> searchPlayers(
      {String query = '', Player? currentPlayer});
}
