import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/round/round.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:enum_to_string/enum_to_string.dart';

abstract class BeloteRound extends Round {
  static const int beloteRebeloteBonus = 20;
  static const int dixDeDerBonus = 10;
  static const int totalScore = 160;

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

  BeloteRound(
      {index,
      cardColor,
      contractFulfilled,
      dixDeDer,
      beloteRebelote,
      taker,
      takerScore,
      defenderScore,
      usTrickScore,
      themTrickScore,
      defender})
      : super(index: index) {
    _taker = taker ?? BeloteTeamEnum.US;
    _defender = defender ?? BeloteTeamEnum.THEM;
    _cardColor = cardColor ?? CardColor.HEART;
    _dixDeDer = dixDeDer ?? BeloteTeamEnum.US;
    _beloteRebelote = beloteRebelote;
    _usTrickScore = usTrickScore ?? 0;
    _themTrickScore = themTrickScore ?? 0;
    _takerScore = takerScore ?? 0;
    _defenderScore = defenderScore ?? 0;
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
    if (_beloteRebelote != value) {
      _beloteRebelote = value;
    } else {
      _beloteRebelote = null;
    }
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

  int getPointsOfTeam(BeloteTeamEnum team);

  int getBeloteRebeloteOfTeam(BeloteTeamEnum? team) {
    return team == _beloteRebelote ? beloteRebeloteBonus : 0;
  }

  int getDixDeDerOfTeam(BeloteTeamEnum? team) {
    return team == _dixDeDer ? dixDeDerBonus : 0;
  }

  @override
  String realTimeDisplay() {
    return '${taker.name} : ${takerScore.toString()} | ${defender.name} : ${defenderScore.toString()}';
  }

  Map<String, dynamic> toJSON() {
    return {
      'index': index,
      'card_color': EnumToString.convertToString(cardColor),
      'dix_de_der': EnumToString.convertToString(dixDeDer),
      'belote_rebelote': EnumToString.convertToString(beloteRebelote),
      'contract_fulfilled': contractFulfilled,
      'taker': EnumToString.convertToString(taker),
      'defender': EnumToString.convertToString(defender),
      'taker_score': takerScore,
      'defender_score': defenderScore,
      'us_trick_score': usTrickScore,
      'them_trick_score': themTrickScore,
    };
  }
}
