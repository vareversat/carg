import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';

class FakeBeloteRound extends BeloteRound {
  @override
  void computeRound() {
  }

  @override
  int getTrickPointsOfTeam(BeloteTeamEnum team) {
    if (team == BeloteTeamEnum.THEM) {
      return 90;
    } else {
      return 20;
    }
  }

}