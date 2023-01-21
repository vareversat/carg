import 'package:carg/models/game/game_type.dart';
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
  static ofGameService(GameType type) {
    switch (type) {
      case GameType.BELOTE:
        return FrenchBeloteGameService();
      case GameType.COINCHE:
        return CoincheBeloteGameService();
      case GameType.CONTREE:
        return ContreeBeloteGameService();
      case GameType.TAROT:
        return TarotGameService();
      default:
        throw Exception(
            '${type.name.toString()} does not have any registered game service');
    }
  }

  static ofRoundService(GameType type) {
    switch (type) {
      case GameType.BELOTE:
        return FrenchBeloteRoundService();
      case GameType.COINCHE:
        return CoincheBeloteRoundService();
      case GameType.CONTREE:
        return ContreeBeloteRoundService();
      case GameType.TAROT:
        return TarotRoundService();
      default:
        throw Exception(
            '${type.name.toString()} does not have any registered round service');
    }
  }

  static ofScoreService(GameType type) {
    switch (type) {
      case GameType.BELOTE:
        return FrenchBeloteScoreService();
      case GameType.COINCHE:
        return CoincheBeloteScoreService();
      case GameType.CONTREE:
        return ContreeBeloteScoreService();
      case GameType.TAROT:
        return TarotScoreService();
      default:
        throw Exception(
            '${type.name.toString()} does not have any registered score service');
    }
  }
}
