import 'package:carg/models/game/setting/belote_game_setting.dart';
import 'package:carg/models/score/misc/belote_special_round.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/widgets.dart';

abstract class BeloteRound extends Round<BeloteGameSetting> {
  static const int beloteRebeloteBonus = 20;
  static const int dixDeDerBonus = 10;
  static const int totalTrickScore = 152;
  static const int totalScore =
      BeloteRound.totalTrickScore + BeloteRound.dixDeDerBonus;
  BeloteSpecialRound? beloteSpecialRound;
  String? beloteSpecialRoundPlayer;

  late CardColor _cardColor;
  late bool contractFulfilled;
  late BeloteTeamEnum _dixDeDer;
  BeloteTeamEnum? _beloteRebelote;
  late BeloteTeamEnum _taker;
  late BeloteTeamEnum _defender;
  late int _takerScore;
  late int _defenderScore;
  late int _usTrickScore;
  late int _themTrickScore;

  BeloteRound({
    super.index,
    super.settings,
    cardColor,
    contractFulfilled,
    dixDeDer,
    beloteRebelote,
    taker,
    takerScore,
    defenderScore,
    usTrickScore,
    themTrickScore,
    defender,
    this.beloteSpecialRound,
    this.beloteSpecialRoundPlayer,
  }) {
    _taker = taker ?? BeloteTeamEnum.US;
    _defender = defender ?? BeloteTeamEnum.THEM;
    _cardColor = cardColor ?? CardColor.HEART;
    _dixDeDer = dixDeDer ?? BeloteTeamEnum.US;
    _beloteRebelote = beloteRebelote;
    _usTrickScore = usTrickScore ?? 0;
    _themTrickScore = themTrickScore ?? totalTrickScore;
    _takerScore = takerScore ?? 0;
    _defenderScore = defenderScore ?? totalTrickScore;
  }

  int get usTrickScore => _usTrickScore;

  set usTrickScore(int value) {
    _usTrickScore = value;
    computeRound();
  }

  int get themTrickScore => _themTrickScore;

  set themTrickScore(int value) {
    _themTrickScore = value;
    computeRound();
  }

  BeloteTeamEnum get defender => _defender;

  set defender(BeloteTeamEnum value) {
    _defender = value;
    computeRound();
  }

  BeloteTeamEnum get taker => _taker;

  set taker(BeloteTeamEnum value) {
    _taker = value;
    computeRound();
  }

  BeloteTeamEnum? get beloteRebelote => _beloteRebelote;

  set beloteRebelote(BeloteTeamEnum? value) {
    _beloteRebelote = value;
    computeRound();
  }

  BeloteTeamEnum get dixDeDer => _dixDeDer;

  set dixDeDer(BeloteTeamEnum value) {
    _dixDeDer = value;
    computeRound();
  }

  CardColor get cardColor => _cardColor;

  set cardColor(CardColor value) {
    _cardColor = value;
    computeRound();
  }

  int get defenderScore => _defenderScore;

  set defenderScore(int value) {
    _defenderScore = value;
    notifyListeners();
  }

  int get takerScore => _takerScore;

  set takerScore(int value) {
    _takerScore = value;
    notifyListeners();
  }

  String specialRoundToString() {
    if (beloteSpecialRound == null) {
      return "This is not a special round";
    } else {
      return beloteSpecialRound!.name();
    }
  }

  bool isSpecialRound() {
    return beloteSpecialRound != null;
  }

  int getTrickPointsOfTeam(BeloteTeamEnum? team) {
    switch (team) {
      case BeloteTeamEnum.US:
        return usTrickScore;
      case BeloteTeamEnum.THEM:
        return themTrickScore;
      case null:
        return 0;
    }
  }

  int getBeloteRebeloteOfTeam(BeloteTeamEnum? team) {
    return team == _beloteRebelote ? beloteRebeloteBonus : 0;
  }

  int getDixDeDerOfTeam(BeloteTeamEnum? team) {
    return team == dixDeDer ? BeloteRound.dixDeDerBonus : 0;
  }

  int roundScore(int trickPoints) {
    return (trickPoints / 10).round() * 10;
  }

  @override
  String realTimeDisplay(BuildContext context) {
    return '${taker.name(context)} : ${takerScore.toString()} | ${defender.name(context)} : ${defenderScore.toString()}';
  }

  int computeDefenderRound();

  int computeTakerRound();

  String getRoundWidgetCentralElement();

  @override
  void computeRound() {
    takerScore = computeTakerRound();
    defenderScore = computeDefenderRound();
    notifyListeners();
  }

  Map<String, dynamic> toJSON() {
    return {
      'index': index,
      'card_color': EnumToString.convertToString(cardColor),
      'dix_de_der': EnumToString.convertToString(dixDeDer),
      'belote_rebelote': beloteRebelote != null
          ? EnumToString.convertToString(beloteRebelote)
          : null,
      'contract_fulfilled': contractFulfilled,
      'taker': EnumToString.convertToString(taker),
      'defender': EnumToString.convertToString(defender),
      'taker_score': takerScore,
      'defender_score': defenderScore,
      'us_trick_score': usTrickScore,
      'them_trick_score': themTrickScore,
      'belote_special_round': beloteSpecialRound != null
          ? EnumToString.convertToString(beloteSpecialRound)
          : null,
      'belote_special_round_player': beloteSpecialRoundPlayer,
    };
  }
}
