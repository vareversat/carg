import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/setting/coinche_belote_game_setting.dart';
import 'package:carg/models/score/coinche_belote_score.dart';
import 'package:carg/repositories/game/abstract_coinche_belote_game_repository.dart';
import 'package:carg/services/game/abstract_belote_game_service.dart';
import 'package:carg/services/score/abstract_coinche_belote_score_service.dart';

abstract class AbstractCoincheBeloteGameService
    extends
        AbstractBeloteGameService<
          CoincheBelote,
          CoincheBeloteScore,
          CoincheBeloteGameSetting
        > {
  AbstractCoincheBeloteGameService({
    required AbstractCoincheBeloteGameRepository coincheBeloteGameRepository,
    required AbstractCoincheBeloteScoreService coincheBeloteScoreService,
    required super.teamService,
  }) : super(
         beloteGameRepository: coincheBeloteGameRepository,
         beloteScoreService: coincheBeloteScoreService,
       );
}
