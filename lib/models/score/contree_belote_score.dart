import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';

class ContreeBeloteScore extends BeloteScore<ContreeBeloteRound> {
  ContreeBeloteScore({
    super.id,
    List<ContreeBeloteRound>? super.rounds,
    int? usTotalPoints,
    int? themTotalPoints,
    super.game,
  }) : super(
          usTotalPoints: usTotalPoints ?? 0,
          themTotalPoints: themTotalPoints ?? 0,
        );

  factory ContreeBeloteScore.fromJSON(Map<String, dynamic>? json, String id) {
    return ContreeBeloteScore(
      id: id,
      rounds: json?['rounds'] != null
          ? ContreeBeloteRound.fromJSONList(json?['rounds'])
          : [],
      usTotalPoints: json?['us_total_points'],
      themTotalPoints: json?['them_total_points'],
      game: json?['game'],
    );
  }

  @override
  String toString() {
    return 'CoincheScore{rounds: $rounds, usTotalPoints: $usTotalPoints, themTotalPoints: $themTotalPoints}';
  }
}
