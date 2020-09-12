import 'package:carg/models/score/misc/player_score.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/score.dart';

class TarotScore extends Score {
  String game;
  List<TarotRound> rounds;
  List<PlayerScore> scores;

  TarotScore({id, this.game, this.rounds, scores, List<String> players})
      : super(id: id) {
    this.scores = scores ?? <PlayerScore>[];
    for (var playerId in players ?? []) {
      this.scores.add(PlayerScore(player: playerId, score: 0));
    }
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'game': game,
      'rounds': rounds.map((e) => e.toJSON()).toList(),
      'scores': scores.map((e) => e.toJSON()).toList()
    };
  }

  PlayerScore getScoreOf(String player) {
    return scores.firstWhere((element) => element.player == player);
  }

  factory TarotScore.fromJSON(Map<String, dynamic> json, String id) {
    if (json == null) {
      return null;
    }
    return TarotScore(
        id: id,
        game: json['game'],
        rounds: TarotRound.fromJSONList(json['rounds']),
        scores: PlayerScore.fromJSONList(json['scores']));
  }

  @override
  String toString() {
    return 'TarotScore{game: $game, rounds: $rounds, scores: $scores}';
  }
}
