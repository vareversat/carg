import 'package:carg/models/game/setting/tarot_game_setting.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/repositories/game/abstract_tarot_game_repository.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/score/abstract_tarot_score_service.dart';

abstract class AbstractTarotGameService
    extends AbstractGameService<Tarot, TarotScore, TarotGameSetting> {
  final AbstractTarotScoreService tarotScoreService;
  final AbstractTarotGameRepository tarotGameRepository;
  final AbstractPlayerService playerService;

  AbstractTarotGameService({
    required this.tarotScoreService,
    required this.tarotGameRepository,
    required this.playerService,
  }) : super(
         gameRepository: tarotGameRepository,
         scoreService: tarotScoreService,
       );
}
