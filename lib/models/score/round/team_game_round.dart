import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:enum_to_string/enum_to_string.dart';

abstract class TeamGameRound extends Round {
  CardColor cardColor;
  bool contractFulfilled;
  TeamGameEnum dixDeDer;
  TeamGameEnum beloteRebelote;
  TeamGameEnum taker;
  int takerScore;
  int defenderScore;
  int usTrickScore;
  int themTrickScore;

  TeamGameRound(
      {index,
      this.cardColor,
      this.contractFulfilled,
      this.dixDeDer,
      this.beloteRebelote,
      this.taker,
      this.takerScore,
      this.defenderScore,
      this.usTrickScore,
      this.themTrickScore})
      : super(index: index);

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
