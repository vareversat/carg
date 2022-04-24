import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/repositories/game/abstract_french_belote_game_repository.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/services/game/abstract_belote_game_service.dart';
import 'package:carg/services/score/abstract_french_belote_score_service.dart';

abstract class AbstractFrenchBeloteGameService
    extends AbstractBeloteGameService<FrenchBelote, FrenchBeloteScore> {
  final AbstractFrenchBeloteGameRepository frenchBeloteGameRepository;
  final AbstractFrenchBeloteScoreService frenchBeloteScoreService;

  AbstractFrenchBeloteGameService(
      {required this.frenchBeloteScoreService,
      required this.frenchBeloteGameRepository,
      required AbstractPlayerService playerService,
      required AbstractTeamService teamService})
      : super(
            beloteGameRepository: frenchBeloteGameRepository,
            beloteScoreService: frenchBeloteScoreService,
            playerService: playerService,
            teamService: teamService);
}
