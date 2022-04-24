import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/game/abstract_belote_game_repository.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/score/abstract_belote_score_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';

abstract class AbstractBeloteGameService<T extends Belote,
    P extends BeloteScore> extends AbstractGameService<T, P> {
  final AbstractBeloteGameRepository<T> beloteGameRepository;
  final AbstractBeloteScoreService<P> beloteScoreService;

  AbstractBeloteGameService(
      {required this.beloteScoreService,
      required this.beloteGameRepository,
      required AbstractPlayerService playerService,
      required AbstractTeamService teamService})
      : super(
            gameRepository: beloteGameRepository,
            scoreService: beloteScoreService,
            playerService: playerService,
            teamService: teamService);

  @override
  Future<void> endAGame(T? game, DateTime? endingDate) async {
    if (game == null) {
      throw ServiceException('Please use a non null game object');
    }
    try {
      Team? winners;
      var score = await beloteScoreService.getScoreByGame(game.id);
      if (score != null) {
        if (score.themTotalPoints == score.usTotalPoints) {
          throw ServiceException('TIE. Please play another round');
        } else if (score.themTotalPoints > score.usTotalPoints) {
          winners = await teamService.incrementWonGamesByOne(
              game.players!.them, game);
        } else if (score.themTotalPoints < score.usTotalPoints) {
          winners =
              await teamService.incrementWonGamesByOne(game.players!.us, game);
        }
        await teamService.incrementPlayedGamesByOne(game.players!.them, game);
        await teamService.incrementPlayedGamesByOne(game.players!.us, game);
        for (var player in game.players!.playerList!) {
          {
            await playerService.incrementPlayedGamesByOne(player!, game);
          }
        }
        if (winners != null) {
          final updatePart = {
            'is_ended': true,
            'ending_date': (endingDate ?? DateTime.now()).toString(),
            'winners': winners.id
          };
          await beloteGameRepository.partialUpdate(game, updatePart);
        } else {
          throw ServiceException(
              'Error while ending the Game ${game.id} : no winners found');
        }
      } else {
        throw ServiceException(
            'Error while ending the Game ${game.id} : no score linked to this game');
      }
    } on Exception catch (e) {
      throw ServiceException(
          'Error while ending the Game ${game.id} : ${e.toString()}');
    }
  }

  @override
  Future<T> createGameWithPlayerList(List<String?> playerListForOrder,
      List<String?> playerListForTeam, DateTime? startingDate) async {
    try {
      var usTeam = await teamService.getTeamByPlayers(
          playerListForTeam.sublist(0, 2).map((e) => e).toList());
      var themTeam = await teamService.getTeamByPlayers(
          playerListForTeam.sublist(2, 4).map((e) => e).toList());
      var game = await generateNewGame(
          usTeam, themTeam, playerListForOrder, startingDate);
      if (game.id != null) {
        await beloteScoreService.generateNewScore(game.id!);
        return game;
      } else {
        throw ServiceException('Game ID is null');
      }
    } on ServiceException {
      rethrow;
    }
  }

  /// Create a new Belote object with the correct type
  Future<T> generateNewGame(Team us, Team them,
      List<String?>? playerListForOrder, DateTime? startingDate);
}
