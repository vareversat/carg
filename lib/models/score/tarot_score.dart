import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/score.dart';

class TarotScore extends Score {
  String game;
  List<TarotRound> rounds;
  List<TarotPlayerScore> totalPoints;

  TarotScore({id, this.game, this.rounds, scores, List<String> players})
      : super(id: id) {
    totalPoints = scores ?? <TarotPlayerScore>[];
    for (var player in players ?? []) {
      totalPoints.add(TarotPlayerScore(player: player, score: 0));
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

  TarotPlayerScore getScoreOf(String player) {
    return totalPoints.firstWhere((element) => element.player == player);
  }

  factory TarotScore.fromJSON(Map<String, dynamic> json, String id) {
    if (json == null) {
      return null;
    }
    return TarotScore(
        id: id,
        game: json['game'],
        rounds: TarotRound.fromJSONList(json['rounds']),
        scores: TarotPlayerScore.fromJSONList(json['player_total_points']));
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
    var playerScores = round.playerPoints;
    for (var playerScore in playerScores) {
      totalPoints
          .firstWhere((element) => element.player == playerScore.player)
          .score -= playerScore.score;
    }
    rounds.removeLast();
  }

  void addRound(TarotRound round) {
    var playerScores = round.playerPoints;
    for (var playerScore in playerScores) {
      totalPoints
          .firstWhere((element) => element.player == playerScore.player)
          .score += playerScore.score;
    }
    rounds.add(round);
  }

  void replaceLastRound(TarotRound round) {
    removeRound(getLastRound());
    addRound(round);
  }
}
