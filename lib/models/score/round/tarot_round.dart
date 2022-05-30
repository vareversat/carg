import 'package:carg/models/players/tarot_round_players.dart';
import 'package:carg/models/score/misc/tarot_chelem.dart';
import 'package:carg/models/score/misc/tarot_contract.dart';
import 'package:carg/models/score/misc/tarot_handful.dart';
import 'package:carg/models/score/misc/tarot_oudler.dart';
import 'package:carg/models/score/misc/tarot_perk.dart';
import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/models/score/misc/tarot_team.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:enum_to_string/enum_to_string.dart';

class TarotRound extends Round {
  static const double maxTrickPoints = 91;
  static const double victoryBonus = 25;
  static const double smallToTheEndBonus = 10;

  late double attackScore;
  late double defenseScore;
  late double _attackTrickPoints;
  late double _defenseTrickPoints;
  TarotOudler? _oudler;
  late TarotContract _contract;
  TarotBonus? _bonus;
  TarotHandful? _handful;
  TarotTeam? _handfulTeam;
  TarotTeam? _smallAtTheEndTeam;
  TarotChelem? _chelem;
  List<TarotPlayerScore>? playerPoints;
  TarotRoundPlayers? players;

  TarotRound({
    int? index,
    double? attackScore,
    double? defenseScore,
    double? attackTrickPoints,
    double? defenseTrickPoints,
    TarotOudler? oudler,
    TarotContract? contract,
    TarotBonus? bonus,
    TarotHandful? handful,
    TarotTeam? handfulTeam,
    TarotChelem? chelem,
    TarotTeam? smallToTheEnd,
    this.playerPoints,
    this.players,
  }) : super(index: index) {
    this.attackScore = attackScore ?? 0;
    this.defenseScore = defenseScore ?? 0;
    _contract = contract ?? TarotContract.PETITE;
    _bonus = bonus;
    _oudler = oudler ?? TarotOudler.ONE;
    _attackTrickPoints = attackTrickPoints ?? TarotOudler.ONE.pointToDo;
    _defenseTrickPoints =
        defenseTrickPoints ?? (maxTrickPoints - _attackTrickPoints);
    _smallAtTheEndTeam = smallToTheEnd;
    _chelem = chelem;
    _handful = handful;
    _handfulTeam = handfulTeam;
  }

  TarotChelem? get chelem => _chelem;

  set chelem(TarotChelem? value) {
    _chelem = value;
    computeRound();
  }

  TarotOudler? get oudler => _oudler;

  set oudler(TarotOudler? value) {
    _oudler = value;
    computeRound();
  }

  TarotContract get contract => _contract;

  set contract(TarotContract value) {
    _contract = value;
    computeRound();
  }

  TarotBonus? get bonus => _bonus;

  set bonus(TarotBonus? value) {
    _bonus = value;
    computeRound();
  }

  TarotHandful? get handful => _handful;

  set handful(TarotHandful? value) {
    _handful = value;
    computeRound();
  }

  TarotTeam? get handfulTeam => _handfulTeam;

  set handfulTeam(TarotTeam? value) {
    _handfulTeam = value;
    computeRound();
  }

  double get attackTrickPoints => _attackTrickPoints;

  set attackTrickPoints(double value) {
    _attackTrickPoints = value;
    _defenseTrickPoints = maxTrickPoints - value;
    computeRound();
  }

  double get defenseTrickPoints => _defenseTrickPoints;

  set defenseTrickPoints(double value) {
    _defenseTrickPoints = value;
    computeRound();
  }

  TarotTeam? get smallToTheEndTeam => _smallAtTheEndTeam;

  set smallToTheEndTeam(TarotTeam? value) {
    _smallAtTheEndTeam = value;
    computeRound();
  }

  @override
  void computeRound() {
    var gain = (attackTrickPoints - oudler.pointToDo);
    var score = 0.0;
    var winCoefficient = 1;
    var smallToTheEndBonus = 0.0;
    var handfulBonus = 0.0;
    score = (victoryBonus + gain.abs()) * contract.multiplayer;
    score += (chelem?.bonus ?? 0);
    if (gain >= 0) {
      switch (smallToTheEndTeam) {
        case TarotTeam.ATTACK:
          smallToTheEndBonus =
              TarotRound.smallToTheEndBonus * contract.multiplayer;
          break;
        case TarotTeam.DEFENSE:
          smallToTheEndBonus =
              -TarotRound.smallToTheEndBonus * contract.multiplayer;
          break;
        case null:
          smallToTheEndBonus = 0.0;
          break;
      }
      if (handfulTeam != null && handful != null) {
        switch (handfulTeam) {
          case TarotTeam.ATTACK:
            handfulBonus = handful.bonus!.toDouble();
            break;
          case TarotTeam.DEFENSE:
            handfulBonus = -handful.bonus!.toDouble();
            break;
          case null:
            handfulBonus = 0.0;
            break;
        }
      }
    } else {
      switch (smallToTheEndTeam) {
        case TarotTeam.ATTACK:
          smallToTheEndBonus =
              -TarotRound.smallToTheEndBonus * contract.multiplayer;
          break;
        case TarotTeam.DEFENSE:
          smallToTheEndBonus =
              TarotRound.smallToTheEndBonus * contract.multiplayer;
          break;
        case null:
          smallToTheEndBonus = 0.0;
          break;
      }
      if (handfulTeam != null && handful != null) {
        switch (handfulTeam) {
          case TarotTeam.ATTACK:
            handfulBonus = -handful.bonus!.toDouble();
            break;
          case TarotTeam.DEFENSE:
            handfulBonus = handful.bonus!.toDouble();
            break;
          case null:
            handfulBonus = 0.0;
            break;
        }
      }
      winCoefficient = -1;
    }
    score += smallToTheEndBonus;
    score += handfulBonus;
    attackScore = winCoefficient * score * (players!.playerList!.length - 1);
    defenseScore = -winCoefficient * score;
    notifyListeners();
  }

  void computePlayerPoints(TarotScore tarotScore) {
    var playerPoints = <TarotPlayerScore>[];
    var realAttackScore =
        players!.playerList!.length <= 4 ? attackScore : attackScore * (2 / 3);
    var calledPlayerScore = attackScore * (1 / 3);
    for (var player in players!.playerList!) {
      if (players!.attackPlayer == player) {
        playerPoints
            .add(TarotPlayerScore(player: player, score: realAttackScore));
      } else if (players!.calledPlayer == player) {
        playerPoints
            .add(TarotPlayerScore(player: player, score: calledPlayerScore));
      } else {
        playerPoints.add(TarotPlayerScore(player: player, score: defenseScore));
      }
    }
    playerPoints = playerPoints;
    index = tarotScore.rounds.length;
  }

  TarotPlayerScore getScoreOf(String? player) {
    return playerPoints!.firstWhere((element) => element.player == player);
  }

  @override
  String realTimeDisplay() {
    if (players!.playerList!.length <= 4) {
      return 'Attaquant : ${attackScore.toStringAsFixed(1)} '
          '| Défenseurs : ${defenseScore.toStringAsFixed(1)}';
    } else {
      return 'Attaquant : ${(attackScore.round() * (2 / 3)).toStringAsFixed(1)} '
          '| Appelé ${(attackScore * (1 / 3)).toStringAsFixed(1)} '
          '| Défenseurs : ${defenseScore.toStringAsFixed(1)}';
    }
  }

  Map<String, dynamic> toJSON() {
    return {
      'index': index,
      'attack_score': attackScore,
      'defense_score': defenseScore,
      'attack_trick_points': attackTrickPoints,
      'defense_trick_points': defenseTrickPoints,
      'players': players?.toJSON(),
      'oudler': EnumToString.convertToString(oudler),
      'contract': EnumToString.convertToString(contract),
      'bonus': bonus != null ? EnumToString.convertToString(bonus) : null,
      'handful': handful != null ? EnumToString.convertToString(handful) : null,
      'small_to_the_end': smallToTheEndTeam != null
          ? EnumToString.convertToString(smallToTheEndTeam)
          : null,
      'chelem': chelem != null ? EnumToString.convertToString(chelem) : null,
      'player_points': playerPoints!.map((e) => e.toJSON()).toList()
    };
  }

  factory TarotRound.fromJSON(Map<String, dynamic> json) {
    return TarotRound(
      index: json['index'],
      attackScore: json['attack_score'],
      defenseScore: json['defense_score'],
      attackTrickPoints: json['attack_trick_points'],
      defenseTrickPoints: json['defense_trick_points'],
      playerPoints: TarotPlayerScore.fromJSONList(json['player_points']),
      players: TarotRoundPlayers.fromJSON(json['players']),
      oudler: EnumToString.fromString(TarotOudler.values, json['oudler']),
      contract: EnumToString.fromString(TarotContract.values, json['contract']),
      bonus: EnumToString.fromString(TarotBonus.values, json['bonus'] ?? ''),
      handful:
          EnumToString.fromString(TarotHandful.values, json['handful'] ?? ''),
      smallToTheEnd: EnumToString.fromString(
          TarotTeam.values, json['small_to_the_end'] ?? ''),
      chelem: EnumToString.fromString(TarotChelem.values, json['chelem'] ?? ''),
    );
  }

  static List<TarotRound> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => TarotRound.fromJSON(json)).toList();
  }

  @override
  String toString() {
    return 'TarotRound{_attackScore: $attackScore, '
        '_defenseScore: $defenseScore, '
        '_attackTrickPoints: $_attackTrickPoints, '
        '_defenseTrickPoints: $_defenseTrickPoints, '
        'players: $players, '
        '_oudler: $_oudler, '
        '_contract: $_contract, '
        '_bonus: $_bonus, '
        '_handful: $_handful, '
        '_smallAtTheEndTeam: $_smallAtTheEndTeam, '
        '_chelem: $_chelem}, '
        'playerPoints $playerPoints';
  }
}
