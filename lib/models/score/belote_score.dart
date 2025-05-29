import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/score/score.dart';

abstract class BeloteScore<T extends BeloteRound> extends Score<T> {
  late List<T> rounds;
  int usTotalPoints;
  int themTotalPoints;
  String? game;

  BeloteScore({
    super.id,
    rounds,
    required this.usTotalPoints,
    required this.themTotalPoints,
    this.game,
  }) {
    this.rounds = rounds ?? <T>[];
  }

  @override
  BeloteScore updateRound(T round, int index) {
    rounds[index] = round;
    refreshScore();
    notifyListeners();
    return this;
  }

  @override
  BeloteScore deleteRound(int index) {
    rounds.removeAt(index);
    refreshScore();
    notifyListeners();
    return this;
  }

  @override
  void refreshScore() {
    usTotalPoints = 0;
    themTotalPoints = 0;
    for (T round in rounds) {
      usTotalPoints += getPointsOfRound(BeloteTeamEnum.US, round);
      themTotalPoints += getPointsOfRound(BeloteTeamEnum.THEM, round);
    }
  }

  int getPointsOfRound(BeloteTeamEnum teamGameEnum, T teamGameRound) {
    if (teamGameEnum == teamGameRound.taker) {
      return teamGameRound.takerScore;
    } else {
      return teamGameRound.defenderScore;
    }
  }

  void addRound(T round) async {
    usTotalPoints += getPointsOfRound(BeloteTeamEnum.US, round);
    themTotalPoints += getPointsOfRound(BeloteTeamEnum.THEM, round);
    round.index = rounds.length;
    rounds.add(round);
    notifyListeners();
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'rounds': rounds.map((round) => round.toJSON()).toList(),
      'us_total_points': usTotalPoints,
      'them_total_points': themTotalPoints,
      'game': game,
    };
  }
}
