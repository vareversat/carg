import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/score/score.dart';
import 'package:carg/repositories/game/abstract_game_repository.dart';
import 'package:carg/services/base_abstract_service.dart';
import 'package:carg/services/score/abstract_score_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractGameService<T extends Game, Q extends Score>
    extends BaseAbstractService<T> {
  final AbstractGameRepository<T> gameRepository;
  final AbstractScoreService<Q> scoreService;
  final AbstractTeamService teamService;

  AbstractGameService(
      {required this.scoreService,
      required this.gameRepository,
      required this.teamService})
      : super(repository: gameRepository);

  /// Get a game via the [gameId]
  /// Return the game, null if not present in present in database
  Future<T?> getGame(String? gameId) async {
    if (gameId == null) {
      throw ServiceException('Please provide a Game ID');
    }
    try {
      return gameRepository.get(gameId);
    } on FirebaseException catch (e) {
      throw ServiceException(
          'Impossible to get the Game $gameId : ${e.message}');
    }
  }

  /// Delete a game via [gameId]
  Future<void> deleteGame(String? gameId) async {
    if (gameId == null) {
      throw ServiceException('Please provide an Game ID');
    }
    try {
      await gameRepository.delete(gameId);
      await scoreService.deleteScoreByGame(gameId);
    } on Exception catch (e) {
      throw ServiceException(
          'Error while deleting the Game $gameId : ${e.toString()}');
    }
  }

  /// Get all the paginated games of a player via his/her/them [playerId]
  /// Return the list of Games
  Future<List<T>> getAllGamesOfPlayerPaginated(
      String? playerId, int? pageSize) async {
    if (playerId == null || pageSize == null) {
      throw ServiceException('Please use a non null player id and page size');
    }
    try {
      var game = await gameRepository.getAllGamesOfPlayer(playerId, pageSize);
      return game;
    } on Exception catch (e) {
      throw ServiceException(
          'Error during the game fetching : ${e.toString()}');
    }
  }

  /// Create a new game with a player list
  /// [playerListForOrder] is used to keep the play order of the players
  /// [playerListForTeam] is used to create the teams od the game
  /// Return the new game
  Future<T> createGameWithPlayerList(List<String?> playerListForOrder,
      List<String?> playerListForTeam, DateTime? startingDate);

  /// End a [game]
  Future<void> endAGame(T game, DateTime? endingDate);

  @override
  Future<String> create(T? t) {
    throw UnimplementedError('Please use createGameWithPlayerList instead');
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError('Please use deleteGame instead');
  }
}
