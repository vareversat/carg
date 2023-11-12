import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/players/tarot_players.dart';
import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/repositories/game/abstract_tarot_game_repository.dart';
import 'package:carg/repositories/impl/game/tarot_game_repository.dart';
import 'package:carg/services/game/abstract_tarot_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/score/tarot_score_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/score/abstract_tarot_score_service.dart';

class TarotGameService extends AbstractTarotGameService {
  TarotGameService({
    AbstractTarotScoreService? tarotScoreService,
    AbstractTarotGameRepository? tarotGameRepository,
    AbstractPlayerService? playerService,
  }) : super(
          tarotScoreService: tarotScoreService ?? TarotScoreService(),
          tarotGameRepository: tarotGameRepository ?? TarotGameRepository(),
          playerService: playerService ?? PlayerService(),
        );

  @override
  Future<void> endAGame(Tarot? game, DateTime? endingDate) async {
    if (game == null) {
      throw ServiceException('Please use a non null team id and game object');
    }
    try {
      TarotPlayerScore? winner;
      for (var player in game.players!.playerList!) {
        {
          await playerService.incrementPlayedGamesByOne(player!, game);
        }
      }
      var score = await tarotScoreService.getScoreByGame(game.id);
      if (score != null) {
        var totalPoints = score.totalPoints;
        if (totalPoints.isNotEmpty) {
          totalPoints.sort((a, b) => a.score.compareTo(b.score));
          winner = totalPoints.last;
          await playerService.incrementWonGamesByOne(winner.player!, game);
        }
        if (winner != null) {
          final updatePart = {
            'is_ended': true,
            'ending_date': (endingDate ?? DateTime.now()).toString(),
            'winners': winner.player,
          };
          await tarotGameRepository.partialUpdate(game, updatePart);
        } else {
          throw ServiceException(
            'Error while ending the Game ${game.id} : no winners found',
          );
        }
      } else {
        throw ServiceException(
          'Error while ending the Game ${game.id} : no score found',
        );
      }
    } on Exception catch (e) {
      throw ServiceException('Error during the game ending : ${e.toString()}');
    }
  }

  @override
  Future<Tarot> createGameWithPlayerList(
    List<String?> playerListForOrder,
    List<String?> playerListForTeam,
    DateTime? startingDate,
  ) async {
    try {
      var tarotGame = Tarot(
        isEnded: false,
        startingDate: startingDate ?? DateTime.now(),
        players: TarotPlayers(
          playerList: playerListForTeam,
        ),
      );
      tarotGame.id = await tarotGameRepository.create(tarotGame);
      var tarotScore = TarotScore(
        game: tarotGame.id,
        rounds: <TarotRound>[],
        players: playerListForTeam,
      );
      await tarotScoreService.create(tarotScore);

      return tarotGame;
    } on Exception catch (e) {
      throw ServiceException(
        'Error during the game creation : ${e.toString()}',
      );
    }
  }
}
