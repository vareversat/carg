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
        return 'Undefine';
      case null:
        return 'null';
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
        return 'sens UNDEFINE';
      case null:
        return 'null';
    }
  }
}
