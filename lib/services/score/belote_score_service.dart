import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/services/score/score_service.dart';

abstract class BeloteScoreService<T extends BeloteScore?, P extends BeloteRound>
    implements ScoreService<T, P> {
  int getPointsOfRound(
      BeloteTeamEnum teamGameEnum, BeloteRound teamGameRound) {
    if (teamGameEnum == teamGameRound.taker) {
      return teamGameRound.takerScore;
    } else {
      return teamGameRound.defenderScore;
    }
  }
}
