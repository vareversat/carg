import 'package:carg/models/game/setting/tarot_game_setting.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/round/abstract_round_service.dart';
import 'package:carg/services/score/abstract_tarot_score_service.dart';

abstract class AbstractTarotRoundService
    extends AbstractRoundService<TarotRound, TarotScore, TarotGameSetting> {
  final AbstractTarotScoreService tarotScoreService;

  AbstractTarotRoundService({required this.tarotScoreService})
    : super(abstractScoreService: tarotScoreService);
}
