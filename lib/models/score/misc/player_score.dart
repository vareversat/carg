class PlayerScore {
  String player;
  double score;

  PlayerScore({this.player, this.score});

  Map<String, dynamic> toJSON() {
    return {'player': player, 'score': score};
  }

  factory PlayerScore.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return PlayerScore(player: json['player'], score: json['score']);
  }

  static List<PlayerScore> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => PlayerScore.fromJSON(json)).toList();
  }

  @override
  String toString() {
    return 'PlayerScore{player: $player, score: $score}';
  }
}
