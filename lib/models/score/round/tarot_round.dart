import 'package:carg/models/player/tarot_game_players_round.dart';
import 'package:carg/models/score/misc/player_score.dart';
import 'package:carg/models/score/misc/tarot_chelem.dart';
import 'package:carg/models/score/misc/tarot_contract.dart';
import 'package:carg/models/score/misc/tarot_handful.dart';
import 'package:carg/models/score/misc/tarot_oudler.dart';
import 'package:carg/models/score/misc/tarot_perk.dart';
import 'package:carg/models/score/misc/tarot_team.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:enum_to_string/enum_to_string.dart';

class TarotRound extends Round {
  static const double maxTrickPoints = 91;
  static const double victoryBonus = 25;
  static const double smallToTheEndBonus = 10;

  double _attackScore;
  double _defenseScore;
  double _attackTrickPoints;
  double _defenseTrickPoints;
  TarotGamePlayersRound players;
  TarotOudler _oudler;
  TarotContract _contract;
  TarotBonus _bonus;
  TarotHandful _handful;
  TarotTeam _smallAtTheEndTeam;
  TarotChelem _chelem;
  List<PlayerScore> playerPoints;

  TarotRound({
    index,
    attackScore,
    defenseScore,
    attackTrickPoints,
    defenseTrickPoints,
    oudler,
    contract,
    bonus,
    handful,
    chelem,
    smallToTheEnd,
    this.playerPoints,
    this.players,
  }) : super(index: index) {
    _oudler = oudler;
    _attackScore = attackScore ?? 0;
    _defenseScore = defenseScore ?? 0;
    _contract = contract ?? TarotContract.PETITE;
    _bonus = bonus;
    _oudler = oudler ?? TarotOudler.ONE;
    _attackTrickPoints = attackTrickPoints ?? TarotOudler.ONE.pointToDo;
    _defenseTrickPoints =
        defenseTrickPoints ?? (maxTrickPoints - _attackTrickPoints);
    _smallAtTheEndTeam = smallToTheEnd;
    _chelem = chelem;
    _handful = handful;
  }

  TarotChelem get chelem => _chelem;

  set chelem(TarotChelem value) {
    _chelem = value;
    computeRound();
  }

  double get attackScore => _attackScore;

  set attackScore(double value) {
    _attackScore = value;
  }

  double get defenseScore => _defenseScore;

  set defenseScore(double value) {
    _defenseScore = value;
  }

  TarotOudler get oudler => _oudler;

  set oudler(TarotOudler value) {
    _oudler = value;
    computeRound();
  }

  TarotContract get contract => _contract;

  set contract(TarotContract value) {
    _contract = value;
    computeRound();
  }

  TarotBonus get bonus => _bonus;

  set bonus(TarotBonus value) {
    _bonus = value;
    computeRound();
  }

  TarotHandful get handful => _handful;

  set handful(TarotHandful value) {
    _handful = value;
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

  TarotTeam get smallToTheEndTeam => _smallAtTheEndTeam;

  set smallToTheEndTeam(TarotTeam value) {
    _smallAtTheEndTeam = value;
    computeRound();
  }

  @override
  void computeRound() {
    var gain = (attackTrickPoints - oudler.pointToDo);
    var score = 0.0;
    var winCoefficient = 1;
    var smallToTheEndBonus = 0.0;
    score = (victoryBonus + gain.abs()) * contract.multiplayer;
    score += (handful?.bonus ?? 0) + (chelem?.bonus ?? 0);
    if (gain >= 0) {
      if (smallToTheEndTeam != null) {
        switch (smallToTheEndTeam) {
          case TarotTeam.ATTACK:
            smallToTheEndBonus =
                TarotRound.smallToTheEndBonus * contract.multiplayer;
            break;
          case TarotTeam.DEFENSE:
            smallToTheEndBonus =
                -TarotRound.smallToTheEndBonus * contract.multiplayer;
            break;
        }
      }
    } else {
      if (smallToTheEndTeam != null) {
        switch (smallToTheEndTeam) {
          case TarotTeam.ATTACK:
            smallToTheEndBonus =
                -TarotRound.smallToTheEndBonus * contract.multiplayer;
            break;
          case TarotTeam.DEFENSE:
            smallToTheEndBonus =
                TarotRound.smallToTheEndBonus * contract.multiplayer;
            break;
        }
      }
      winCoefficient = -1;
    }
    score += smallToTheEndBonus;
    attackScore = winCoefficient * score * (players.playerList.length - 1);
    defenseScore = -winCoefficient * score;
    notifyListeners();
  }

  PlayerScore getScoreOf(String player) {
    return playerPoints.firstWhere((element) => element.player == player);
  }

  @override
  String realTimeDisplay() {
    if (players.playerList.length <= 4) {
      return 'Attaquant : ${attackScore.round().toString()} '
          '| Défenseurs : ${defenseScore.round().toString()}';
    } else {
      return 'Attaquant : ${(attackScore.round() * (2 / 3)).toString()} '
          '| Appelé ${(attackScore.round() * (1 / 3)).toString()} '
          '| Défenseurs : ${defenseScore.round().toString()}';
    }
  }

  Map<String, dynamic> toJSON() {
    return {
      'index': index,
      'attack_score': attackScore,
      'defense_score': defenseScore,
      'attack_trick_points': attackTrickPoints,
      'defense_trick_points': defenseTrickPoints,
      'players': players.toJSON(),
      'oudler': EnumToString.convertToString(oudler),
      'contract': EnumToString.convertToString(contract),
      'bonus': EnumToString.convertToString(bonus),
      'handful': EnumToString.convertToString(handful),
      'small_to_the_end': EnumToString.convertToString(smallToTheEndTeam),
      'chelem': EnumToString.convertToString(chelem),
      'player_points': playerPoints.map((e) => e.toJSON()).toList()
    };
  }

  factory TarotRound.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return TarotRound(
      index: json['index'],
      attackScore: json['attack_score'],
      defenseScore: json['defense_score'],
      attackTrickPoints: json['attack_trick_points'],
      defenseTrickPoints: json['defense_trick_points'],
      playerPoints: PlayerScore.fromJSONList(json['player_points']),
      players: TarotGamePlayersRound.fromJSON(json['players']),
      oudler: EnumToString.fromString(TarotOudler.values, json['oudler']),
      contract: EnumToString.fromString(TarotContract.values, json['contract']),
      bonus: EnumToString.fromString(TarotBonus.values, json['bonus']),
      handful: EnumToString.fromString(TarotHandful.values, json['handful']),
      smallToTheEnd:
          EnumToString.fromString(TarotTeam.values, json['small_to_the_end']),
      chelem: EnumToString.fromString(TarotChelem.values, json['chelem']),
    );
  }

  static List<TarotRound> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => TarotRound.fromJSON(json)).toList();
  }

  @override
  String toString() {
    return 'TarotRound{_attackScore: $_attackScore, '
        '_defenseScore: $_defenseScore, '
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
