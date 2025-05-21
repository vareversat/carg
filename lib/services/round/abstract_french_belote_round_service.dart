import 'package:carg/models/game/setting/french_belote_game_setting.dart';
import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/services/round/abstract_belote_round_service.dart';
import 'package:carg/services/score/abstract_french_belote_score_service.dart';

abstract class AbstractFrenchBeloteRoundService
    extends
        AbstractBeloteRoundService<
          FrenchBeloteRound,
          FrenchBeloteScore,
          FrenchBeloteGameSetting
        > {
  AbstractFrenchBeloteRoundService({
    required AbstractFrenchBeloteScoreService scoreService,
  }) : super(scoreService: scoreService);
}
