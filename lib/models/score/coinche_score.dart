import 'package:carg/models/score/round/coinche_round.dart';
import 'package:carg/models/score/team_game_score.dart';

class CoincheScore extends TeamGameScore<CoincheRound> {
  CoincheScore({id, rounds, usTotalPoints, themTotalPoints, game})
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

  factory CoincheScore.fromJSON(Map<String, dynamic> json, String id) {
    if (json == null) {
      return null;
    }
    return CoincheScore(
        id: id,
        rounds: CoincheRound.fromJSONList(json['rounds']),
        usTotalPoints: json['us_total_points'],
        themTotalPoints: json['them_total_points'],
        game: json['game']);
  }

  @override
  String toString() {
    return 'CoincheScore{rounds: $rounds, usTotalPoints: $usTotalPoints, themTotalPoints: $themTotalPoints}';
  }
}
