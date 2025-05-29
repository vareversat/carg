import 'package:carg/models/game/setting/game_setting.dart';
import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/score.dart';

class TarotScore extends Score<TarotRound> {
  String? game;
  late List<TarotRound> rounds;
  late List<TarotPlayerScore> totalPoints;

  TarotScore({
    super.id,
    this.game,
    List<TarotRound>? rounds,
    List<TarotPlayerScore>? totalPoints,
    List<String?>? players,
  }) {
    this.totalPoints = totalPoints ?? <TarotPlayerScore>[];
    this.rounds = rounds ?? <TarotRound>[];
    for (var player in players ?? []) {
      this.totalPoints.add(TarotPlayerScore(player: player, score: 0));
    }
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'game': game,
      'rounds': rounds.map((e) => e.toJSON()).toList(),
      'player_total_points': totalPoints.map((e) => e.toJSON()).toList(),
    };
  }

  TarotPlayerScore getScoreOf(String? player) {
    return totalPoints.firstWhere((element) => element.player == player);
  }

  factory TarotScore.fromJSON(Map<String, dynamic>? json, String id) {
    return TarotScore(
      id: id,
      game: json?['game'],
      rounds: json?['rounds'] != null
          ? TarotRound.fromJSONList(json?['rounds'])
          : <TarotRound>[],
      totalPoints: json?['player_total_points'] != null
          ? TarotPlayerScore.fromJSONList(json?['player_total_points'])
          : <TarotPlayerScore>[],
    );
  }

  @override
  String toString() {
    return 'TarotScore{game: $game, rounds: $rounds, scores: $totalPoints}';
  }

  void addRound(TarotRound round) {
    round.computePlayerPoints(this);
    rounds.add(round);
    refreshScore();
    notifyListeners();
  }

  @override
  TarotScore deleteRound(int index) {
    rounds.removeAt(index);
    refreshScore();
    notifyListeners();
    return this;
  }

  @override
  Score<Round<GameSetting>> updateRound(TarotRound round, int index) {
    round.computePlayerPoints(this);
    rounds[index] = round;
    refreshScore();
    notifyListeners();
    return this;
  }

  @override
  void refreshScore() {
    // Reset every value to 0
    for (var tP in totalPoints) {
      tP.score = 0;
    }
    for (var round in rounds) {
      // For every round, add the score to the total score of each players
      for (var playerPoint in round.playerPoints!) {
        totalPoints
                .firstWhere((element) => element.player == playerPoint.player)
                .score +=
            playerPoint.score;
      }
    }
  }
}
