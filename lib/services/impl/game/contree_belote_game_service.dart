import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/models/game/setting/contree_belote_game_setting.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/game/abstract_contree_belote_game_repository.dart';
import 'package:carg/repositories/impl/game/contree_belote_game_repository.dart';
import 'package:carg/services/game/abstract_contree_belote_game_service.dart';
import 'package:carg/services/impl/score/contree_belote_score_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:carg/services/score/abstract_contree_belote_score_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';

class ContreeBeloteGameService extends AbstractContreeBeloteGameService {
  ContreeBeloteGameService({
    AbstractContreeBeloteScoreService? contreeBeloteScoreService,
    AbstractContreeBeloteGameRepository? contreeBeloteGameRepository,
    AbstractTeamService? teamService,
  }) : super(
         contreeBeloteScoreService:
             contreeBeloteScoreService ?? ContreeBeloteScoreService(),
         contreeBeloteGameRepository:
             contreeBeloteGameRepository ?? ContreeBeloteGameRepository(),
         teamService: teamService ?? TeamService(),
       );

  @override
  Future<ContreeBelote> generateNewGame(
    Team us,
    Team them,
    List<String?>? playerListForOrder,
    DateTime? startingDate,
    ContreeBeloteGameSetting settings,
  ) async {
    try {
      var contreeBelote = ContreeBelote(
        settings: settings,
        startingDate: startingDate,
        players: BelotePlayers(
          us: us.id,
          them: them.id,
          playerList: playerListForOrder,
        ),
      );
      contreeBelote.id = await beloteGameRepository.create(contreeBelote);
      return contreeBelote;
    } on Exception catch (e) {
      throw ServiceException(
        'Error while generating a new game : ${e.toString()}',
      );
    }
  }
}
