import 'package:carg/services/game/coinche_belote_service.dart';
import 'package:carg/services/game/french_belote_service.dart';
import 'package:carg/services/game/game_service.dart';
import 'package:carg/services/game/tarot_service.dart';

enum GameType { COINCHE, BELOTE, TAROT, UNDEFINE }

extension GameTypeExtension on GameType? {
  String get name {
    switch (this) {
      case GameType.COINCHE:
        return 'Coinche';
      case GameType.BELOTE:
        return 'Belote';
      case GameType.TAROT:
        return 'Tarot';
      case GameType.UNDEFINE:
        throw Exception('Name not defined for game type' + GameType.UNDEFINE.name);
      case null:
        throw Exception('Direction not defined for null');
    }
  }

  String get direction {
    switch (this) {
      case GameType.COINCHE:
        return 'sens anti-horaire';
      case GameType.BELOTE:
        return 'sens horaire';
      case GameType.TAROT:
        return 'sens anti-horaire';
      case GameType.UNDEFINE:
        throw Exception('Direction not defined for game type ' + GameType.UNDEFINE.name);
      case null:
        throw Exception('Direction not defined for null');
    }
  }

  GameService get gameService {
    switch (this) {
      case GameType.COINCHE:
        return CoincheBeloteService();
      case GameType.BELOTE:
        return FrenchBeloteService();
      case GameType.TAROT:
        return TarotService();
      case GameType.UNDEFINE:
        throw Exception('Service not defined for ' + GameType.UNDEFINE.name);
      case null:
        throw Exception('Service not defined for null');
    }
  }
}
