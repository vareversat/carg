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
    switch (game.runtimeType) {
      case FrenchBelote:
        return FrenchBeloteGameService();
      case CoincheBelote:
        return CoincheBeloteGameService();
      case ContreeBelote:
        return ContreeBeloteGameService();
      case Tarot:
        return TarotGameService();
      default:
        throw Exception(
            '${game.runtimeType.toString()} does not have any registered game service');
    }
  }

  static ofRoundService(Game game) {
    switch (game.runtimeType) {
      case FrenchBelote:
        return FrenchBeloteRoundService();
      case CoincheBelote:
        return CoincheBeloteRoundService();
      case ContreeBelote:
        return ContreeBeloteRoundService();
      case Tarot:
        return TarotRoundService();
      default:
        throw Exception(
            '${game.runtimeType.toString()} does not have any registered round service');
    }
  }

  static ofScoreService(Game game) {
    switch (game.runtimeType) {
      case FrenchBelote:
        return FrenchBeloteScoreService();
      case CoincheBelote:
        return CoincheBeloteScoreService();
      case ContreeBelote:
        return ContreeBeloteScoreService();
      case Tarot:
        return TarotScoreService();
      default:
        throw Exception(
            '${game.runtimeType.toString()} does not have any registered score service');
    }
  }

  static ofSpecialRound(
      Game game, BeloteSpecialRound beloteSpecialRound, String playerID) {
    switch (game.runtimeType) {
      case FrenchBelote:
        return FrenchBeloteRound.specialRound(beloteSpecialRound, playerID);
      case CoincheBelote:
        return CoincheBeloteRound.specialRound(beloteSpecialRound, playerID);
      case ContreeBelote:
        return ContreeBeloteRound.specialRound(beloteSpecialRound, playerID);
      default:
        throw Exception(
            '${game.runtimeType.toString()} does not have any registered special round');
    }
  }
}
