import 'package:carg/models/game/setting/coinche_belote_game_setting.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/services/impl/score/coinche_belote_score_service.dart';
import 'package:carg/services/round/abstract_coinche_belote_round_service.dart';
import 'package:carg/services/score/abstract_coinche_belote_score_service.dart';

class CoincheBeloteRoundService extends AbstractCoincheBeloteRoundService {
  CoincheBeloteRoundService({
    AbstractCoincheBeloteScoreService? coincheBeloteScoreService,
  }) : super(
         coincheBeloteScoreService:
             coincheBeloteScoreService ?? CoincheBeloteScoreService(),
       );

  @override
  CoincheBeloteRound getNewRound(CoincheBeloteGameSetting settings) {
    return CoincheBeloteRound(settings: settings);
  }
}
