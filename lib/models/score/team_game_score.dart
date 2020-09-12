import 'package:carg/models/score/round/team_game_round.dart';
import 'package:carg/models/score/score.dart';

abstract class TeamGameScore<T extends TeamGameRound> extends Score {
  List<T> rounds;
  int usTotalPoints;
  int themTotalPoints;
  String game;

  TeamGameScore(
      {id, this.rounds, this.usTotalPoints, this.themTotalPoints, this.game})
      : super(id: id);

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({
      'rounds': rounds.map((round) => round.toJSON()).toList(),
      'us_total_points': usTotalPoints,
      'them_total_points': themTotalPoints,
      'game': game
    });
    return tmpJSON;
  }
}
