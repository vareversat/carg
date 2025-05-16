import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';

class CoincheBeloteScore extends BeloteScore<CoincheBeloteRound> {
  CoincheBeloteScore({
    super.id,
    List<CoincheBeloteRound>? super.rounds,
    int? usTotalPoints,
    int? themTotalPoints,
    super.game,
  }) : super(
         usTotalPoints: usTotalPoints ?? 0,
         themTotalPoints: themTotalPoints ?? 0,
       );

  factory CoincheBeloteScore.fromJSON(Map<String, dynamic>? json, String id) {
    return CoincheBeloteScore(
      id: id,
      rounds:
          json?['rounds'] != null
              ? CoincheBeloteRound.fromJSONList(json?['rounds'])
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
