import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/score/misc/belote_special_round.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/services/impl/game/coinche_belote_game_service.dart';
import 'package:carg/services/impl/game/contree_belote_game_service.dart';
import 'package:carg/services/impl/game/french_belote_game_service.dart';
import 'package:carg/services/impl/game/tarot_game_service.dart';
import 'package:carg/services/impl/round/coinche_belote_round_service.dart';
import 'package:carg/services/impl/round/contree_belote_round_service.dart';
import 'package:carg/services/impl/round/french_belote_round_service.dart';
import 'package:carg/services/impl/round/tarot_round_service.dart';
import 'package:carg/services/impl/score/coinche_belote_score_service.dart';
import 'package:carg/services/impl/score/contree_belote_score_service.dart';
import 'package:carg/services/impl/score/french_belote_score_service.dart';
import 'package:carg/services/impl/score/tarot_score_service.dart';

class CorrectInstance {
  static ofGameService(Game game) {
    switch (game) {
      case FrenchBelote _:
        return FrenchBeloteGameService();
      case CoincheBelote _:
        return CoincheBeloteGameService();
      case ContreeBelote _:
        return ContreeBeloteGameService();
      case Tarot _:
        return TarotGameService();
      default:
        throw Exception(
            '${game.runtimeType.toString()} does not have any registered game service');
    }
  }

  static ofRoundService(Game game) {
    switch (game) {
      case FrenchBelote _:
        return FrenchBeloteRoundService();
      case CoincheBelote _:
        return CoincheBeloteRoundService();
      case ContreeBelote _:
        return ContreeBeloteRoundService();
      case Tarot _:
        return TarotRoundService();
      default:
        throw Exception(
            '${game.runtimeType.toString()} does not have any registered round service');
    }
  }

  static ofScoreService(Game game) {
    switch (game) {
      case FrenchBelote _:
        return FrenchBeloteScoreService();
      case CoincheBelote _:
        return CoincheBeloteScoreService();
      case ContreeBelote _:
        return ContreeBeloteScoreService();
      case Tarot _:
        return TarotScoreService();
      default:
        throw Exception(
            '${game.runtimeType.toString()} does not have any registered score service');
    }
  }

  static ofSpecialRound(
      Game game, BeloteSpecialRound beloteSpecialRound, String playerID) {
    switch (game) {
      case FrenchBelote _:
        return FrenchBeloteRound.specialRound(beloteSpecialRound, playerID);
      case CoincheBelote _:
        return CoincheBeloteRound.specialRound(beloteSpecialRound, playerID);
      case ContreeBelote _:
        return ContreeBeloteRound.specialRound(beloteSpecialRound, playerID);
      default:
        throw Exception(
            '${game.runtimeType.toString()} does not have any registered special round');
    }
  }
}
