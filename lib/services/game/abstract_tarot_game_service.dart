import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/repositories/game/abstract_tarot_game_repository.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/services/score/abstract_tarot_score_service.dart';

abstract class AbstractTarotGameService
    extends AbstractGameService<Tarot, TarotScore> {
  final AbstractTarotScoreService tarotScoreService;
  final AbstractTarotGameRepository tarotGameRepository;

  AbstractTarotGameService(
      {required this.tarotScoreService,
      required this.tarotGameRepository,
      required AbstractPlayerService playerService,
      required AbstractTeamService teamService})
      : super(
            gameRepository: tarotGameRepository,
            scoreService: tarotScoreService,
            playerService: playerService,
            teamService: teamService);
}
