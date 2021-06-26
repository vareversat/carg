import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';

class ContreeBeloteScore extends BeloteScore<ContreeBeloteRound> {
  ContreeBeloteScore({id, rounds, usTotalPoints, themTotalPoints, game})
      : super(
            id: id,
            rounds: rounds,
            usTotalPoints: usTotalPoints,
            themTotalPoints: themTotalPoints,
            game: game);

  @override
  Map<String, dynamic> toJSON() {
    return super.toJSON();
  }

  factory ContreeBeloteScore.fromJSON(Map<String, dynamic>? json, String id) {
    return ContreeBeloteScore(
        id: id,
        rounds: ContreeBeloteRound.fromJSONList(json?['rounds']),
        usTotalPoints: json?['us_total_points'],
        themTotalPoints: json?['them_total_points'],
        game: json?['game']);
  }

  @override
  String toString() {
    return 'CoincheScore{rounds: $rounds, usTotalPoints: $usTotalPoints, themTotalPoints: $themTotalPoints}';
  }
}
