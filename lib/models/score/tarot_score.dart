import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/score.dart';

class TarotScore extends Score<TarotRound> {
  String? game;
  late List<TarotRound> rounds;
  late List<TarotPlayerScore> totalPoints;

  TarotScore(
      {super.id,
      this.game,
      List<TarotRound>? rounds,
      List<TarotPlayerScore>? totalPoints,
      List<String?>? players}) {
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
      'player_total_points': totalPoints.map((e) => e.toJSON()).toList()
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
            : <TarotPlayerScore>[]);
  }

  @override
  String toString() {
    return 'TarotScore{game: $game, rounds: $rounds, scores: $totalPoints}';
  }

  @override
  TarotRound getLastRound() {
    return rounds.last;
  }

  void removeRound(TarotRound round) {
    var playerScores = round.playerPoints!;
    for (var playerScore in playerScores) {
      totalPoints
          .firstWhere((element) => element.player == playerScore.player)
          .score -= playerScore.score;
    }
    rounds.removeLast();
    notifyListeners();
  }

  void addRound(TarotRound round) {
    round.computePlayerPoints(this);
    var playerScores = round.playerPoints!;
    for (var playerScore in playerScores) {
      totalPoints
          .firstWhere((element) => element.player == playerScore.player)
          .score += playerScore.score;
    }
    rounds.add(round);
    notifyListeners();
  }

  @override
  TarotScore deleteLastRound() {
    removeRound(getLastRound());
    notifyListeners();
    return this;
  }

  @override
  TarotScore replaceLastRound(TarotRound round) {
    removeRound(getLastRound());
    addRound(round);
    notifyListeners();
    notifyListeners();
    return this;
  }
}
