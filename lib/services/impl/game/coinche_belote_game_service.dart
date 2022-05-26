import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/game/abstract_coinche_belote_game_repository.dart';
import 'package:carg/repositories/impl/game/coinche_belote_game_repository.dart';
import 'package:carg/services/game/abstract_coinche_belote_game_service.dart';
import 'package:carg/services/impl/score/coinche_belote_score_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:carg/services/score/abstract_coinche_belote_score_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';

class CoincheBeloteGameService extends AbstractCoincheBeloteGameService {
  CoincheBeloteGameService(
      {AbstractCoincheBeloteScoreService? coincheBeloteScoreService,
      AbstractCoincheBeloteGameRepository? coincheBeloteGameRepository,
      AbstractTeamService? teamService})
      : super(
            coincheBeloteScoreService:
                coincheBeloteScoreService ?? CoincheBeloteScoreService(),
            coincheBeloteGameRepository:
                coincheBeloteGameRepository ?? CoincheBeloteGameRepository(),
            teamService: teamService ?? TeamService());

  @override
  Future<CoincheBelote> generateNewGame(Team us, Team them,
      List<String?>? playerListForOrder, DateTime? startingDate) async {
    try {
      var coincheBelote = CoincheBelote(
          startingDate: startingDate,
          players: BelotePlayers(
              us: us.id, them: them.id, playerList: playerListForOrder));
      coincheBelote.id = await beloteGameRepository.create(coincheBelote);
      return coincheBelote;
    } on Exception catch (e) {
      throw ServiceException(
          'Error while generating a new game : ${e.toString()}');
    }
  }
}
