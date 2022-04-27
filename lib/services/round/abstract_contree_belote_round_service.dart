import 'package:carg/models/score/contree_belote_score.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/services/round/abstract_belote_round_service.dart';
import 'package:carg/services/score/abstract_contree_belote_score_service.dart';

abstract class AbstractContreeBeloteRoundService
    extends AbstractBeloteRoundService<ContreeBeloteRound, ContreeBeloteScore> {
  AbstractContreeBeloteRoundService(
      {required AbstractContreeBeloteScoreService scoreService})
      : super(scoreService: scoreService);
}