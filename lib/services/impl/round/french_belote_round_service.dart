import 'package:carg/models/game/setting/french_belote_game_setting.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/services/impl/score/french_belote_score_service.dart';
import 'package:carg/services/round/abstract_french_belote_round_service.dart';
import 'package:carg/services/score/abstract_french_belote_score_service.dart';

class FrenchBeloteRoundService extends AbstractFrenchBeloteRoundService {
  FrenchBeloteRoundService(
      {AbstractFrenchBeloteScoreService? frenchBeloteScoreService})
      : super(
            scoreService:
                frenchBeloteScoreService ?? FrenchBeloteScoreService());

  @override
  FrenchBeloteRound getNewRound(FrenchBeloteGameSetting settings) {
    return FrenchBeloteRound(settings: settings);
  }
}
