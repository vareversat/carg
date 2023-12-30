import 'package:carg/models/game/setting/coinche_belote_game_setting.dart';
import 'package:carg/models/score/coinche_belote_score.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/services/round/abstract_belote_round_service.dart';
import 'package:carg/services/score/abstract_coinche_belote_score_service.dart';

abstract class AbstractCoincheBeloteRoundService
    extends AbstractBeloteRoundService<CoincheBeloteRound, CoincheBeloteScore,
        CoincheBeloteGameSetting> {
  AbstractCoincheBeloteRoundService(
      {required AbstractCoincheBeloteScoreService coincheBeloteScoreService})
      : super(scoreService: coincheBeloteScoreService);
}
