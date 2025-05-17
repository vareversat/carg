import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/setting/french_belote_game_setting.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/game/abstract_french_belote_game_repository.dart';
import 'package:carg/repositories/impl/game/french_belote_game_repository.dart';
import 'package:carg/services/game/abstract_french_belote_game_service.dart';
import 'package:carg/services/impl/score/french_belote_score_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:carg/services/score/abstract_french_belote_score_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';

class FrenchBeloteGameService extends AbstractFrenchBeloteGameService {
  FrenchBeloteGameService({
    AbstractFrenchBeloteScoreService? frenchBeloteScoreService,
    AbstractFrenchBeloteGameRepository? frenchBeloteGameRepository,
    AbstractTeamService? teamService,
  }) : super(
         frenchBeloteScoreService:
             frenchBeloteScoreService ?? FrenchBeloteScoreService(),
         frenchBeloteGameRepository:
             frenchBeloteGameRepository ?? FrenchBeloteGameRepository(),
         teamService: teamService ?? TeamService(),
       );

  @override
  Future<FrenchBelote> generateNewGame(
    Team us,
    Team them,
    List<String?>? playerListForOrder,
    DateTime? startingDate,
    FrenchBeloteGameSetting settings,
  ) async {
    try {
      var frenchBelote = FrenchBelote(
        settings: settings,
        startingDate: startingDate,
        players: BelotePlayers(
          us: us.id,
          them: them.id,
          playerList: playerListForOrder,
        ),
      );
      frenchBelote.id = await beloteGameRepository.create(frenchBelote);
      return frenchBelote;
    } on Exception catch (e) {
      throw ServiceException(
        'Error while generating a new game : ${e.toString()}',
      );
    }
  }
}
