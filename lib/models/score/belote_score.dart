import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/score/team_game_score.dart';

class BeloteScore extends TeamGameScore<BeloteRound> {
  BeloteScore({id, rounds, usTotalPoints, themTotalPoints, game})
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

  factory BeloteScore.fromJSON(Map<String, dynamic> json, String id) {
    if (json == null) {
      return null;
    }
    return BeloteScore(
        id: id,
        rounds: BeloteRound.fromJSONList(json['rounds']),
        usTotalPoints: json['us_total_points'],
        themTotalPoints: json['them_total_points'],
        game: json['game']);
  }

  @override
  String toString() {
    return 'BeloteScore{rounds: $rounds, usTotalPoints: $usTotalPoints, themTotalPoints: $themTotalPoints}';
  }
}
