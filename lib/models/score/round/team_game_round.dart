import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:enum_to_string/enum_to_string.dart';

abstract class TeamGameRound extends Round {
  static const int beloteRebeloteBonus = 20;
  static const int dixDeDerBonus = 10;
  static const int totalScore = 160;

  CardColor _cardColor;
  bool contractFulfilled;
  TeamGameEnum _dixDeDer;
  TeamGameEnum _beloteRebelote;
  TeamGameEnum _taker;
  TeamGameEnum _defender;
  int _takerScore;
  int _defenderScore;
  int _usTrickScore;
  int _themTrickScore;

  TeamGameRound(
      {index,
      cardColor,
      this.contractFulfilled,
      dixDeDer,
      beloteRebelote,
      taker,
      takerScore,
      defenderScore,
      usTrickScore,
      themTrickScore,
      defender})
      : super(index: index) {
    _taker = taker ?? TeamGameEnum.US;
    _defender = defender ?? TeamGameEnum.THEM;
    _cardColor = cardColor ?? CardColor.COEUR;
    _dixDeDer = dixDeDer ?? TeamGameEnum.US;
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

  TeamGameEnum get defender => _defender;

  set defender(TeamGameEnum value) {
    _defender = value;
    computeRound();
  }

  TeamGameEnum get taker => _taker;

  set taker(TeamGameEnum value) {
    _taker = value;
    computeRound();
  }

  TeamGameEnum get beloteRebelote => _beloteRebelote;

  set beloteRebelote(TeamGameEnum value) {
    if (_beloteRebelote != value) {
      _beloteRebelote = value;
    } else {
      _beloteRebelote = null;
    }
    computeRound();
  }

  TeamGameEnum get dixDeDer => _dixDeDer;

  set dixDeDer(TeamGameEnum value) {
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

  bool isContractFulfilled();

  int getBeloteRebeloteOfTeam(TeamGameEnum team) {
    return team == _beloteRebelote ? beloteRebeloteBonus : 0;
  }

  int getDixDeDerOfTeam(TeamGameEnum team) {
    return team == _dixDeDer ? dixDeDerBonus : 0;
  }

  int getPointsOfTeam(TeamGameEnum team) {
    switch (team) {
      case TeamGameEnum.US:
        return _usTrickScore + getDixDeDerOfTeam(TeamGameEnum.US);
      case TeamGameEnum.THEM:
        return _themTrickScore + getDixDeDerOfTeam(TeamGameEnum.THEM);
    }
    return 0;
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
      'taker_score': takerScore,
      'defender_score': defenderScore,
      'us_trick_score': usTrickScore,
      'them_trick_score': themTrickScore,
    };
  }
}
