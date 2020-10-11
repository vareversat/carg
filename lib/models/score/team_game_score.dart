import 'package:carg/models/score/round/team_game_round.dart';
import 'package:carg/models/score/score.dart';

import 'misc/team_game_enum.dart';

abstract class TeamGameScore<T extends TeamGameRound> extends Score {
  List<T> rounds;
  int usTotalPoints;
  int themTotalPoints;
  String game;

  TeamGameScore(
      {id, this.rounds, this.usTotalPoints, this.themTotalPoints, this.game})
      : super(id: id);

  TeamGameScore replaceLastRound(T round) {
    usTotalPoints -= getPointsOfRound(TeamGameEnum.US, getLastRound());
    themTotalPoints -= getPointsOfRound(TeamGameEnum.THEM, getLastRound());
    _setLastRound(round);
    return this;
  }

  TeamGameScore deleteLastRound() {
    usTotalPoints -= getPointsOfRound(TeamGameEnum.US, getLastRound());
    themTotalPoints -= getPointsOfRound(TeamGameEnum.THEM, getLastRound());
    rounds.removeLast();
    return this;
  }

  T getLastRound() {
    return rounds.last;
  }

  int getPointsOfRound(TeamGameEnum teamGameEnum, T teamGameRound) {
    if (teamGameEnum == teamGameRound.taker) {
      return teamGameRound.takerScore;
    } else {
      return teamGameRound.defenderScore;
    }
  }

  void _setLastRound(T round) {
    usTotalPoints += getPointsOfRound(TeamGameEnum.US, round);
    themTotalPoints += getPointsOfRound(TeamGameEnum.THEM, round);
    rounds?.last = round;
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'rounds': rounds.map((round) => round.toJSON()).toList(),
      'us_total_points': usTotalPoints,
      'them_total_points': themTotalPoints,
      'game': game
    };
  }
}
