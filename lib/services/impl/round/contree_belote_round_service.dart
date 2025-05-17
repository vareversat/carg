import 'package:carg/models/game/setting/contree_belote_game_setting.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/services/impl/score/contree_belote_score_service.dart';
import 'package:carg/services/round/abstract_contree_belote_round_service.dart';
import 'package:carg/services/score/abstract_contree_belote_score_service.dart';

class ContreeBeloteRoundService extends AbstractContreeBeloteRoundService {
  ContreeBeloteRoundService({
    AbstractContreeBeloteScoreService? contreeBeloteScoreService,
  }) : super(
         scoreService: contreeBeloteScoreService ?? ContreeBeloteScoreService(),
       );

  @override
  ContreeBeloteRound getNewRound(ContreeBeloteGameSetting settings) {
    return ContreeBeloteRound(settings: settings);
  }
}
