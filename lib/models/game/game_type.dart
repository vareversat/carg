

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

  String get rulesFile {
    switch (this) {
      case GameType.COINCHE:
        return 'coinche_belote_rules.md';
      case GameType.BELOTE:
        return 'french_belote_rules.md';
      case GameType.TAROT:
        return 'french_belote_rules.md';
      case GameType.UNDEFINE:
        throw Exception('Rules not defined for game type ' + GameType.UNDEFINE.name);
      case null:
        throw Exception('Rules not defined for null');
    }
  }
}
