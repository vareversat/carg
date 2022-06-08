import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/round/french_belote_round.dart';

class FrenchBeloteScore extends BeloteScore<FrenchBeloteRound> {
  FrenchBeloteScore(
      {String? id,
      List<FrenchBeloteRound>? rounds,
      int? usTotalPoints,
      int? themTotalPoints,
      String? game})
      : super(
            id: id,
            rounds: rounds,
            usTotalPoints: usTotalPoints ?? 0,
            themTotalPoints: themTotalPoints ?? 0,
            game: game);

  @override
  Map<String, dynamic> toJSON() {
    return super.toJSON();
  }

  factory FrenchBeloteScore.fromJSON(Map<String, dynamic>? json, String id) {
    return FrenchBeloteScore(
        id: id,
        rounds: json?['rounds'] != null
            ? FrenchBeloteRound.fromJSONList(json?['rounds'])
            : [],
        usTotalPoints: json?['us_total_points'],
        themTotalPoints: json?['them_total_points'],
        game: json?['game']);
  }

  @override
  String toString() {
    return 'BeloteScore{rounds: $rounds, usTotalPoints: $usTotalPoints, themTotalPoints: $themTotalPoints}';
  }
}
