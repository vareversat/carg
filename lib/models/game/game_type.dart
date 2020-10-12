enum GameType { COINCHE, BELOTE, TAROT }

extension GameTypeExtension on GameType {
  String get name {
    switch (this) {
      case GameType.COINCHE:
        return 'Coinche';
      case GameType.BELOTE:
        return 'Belote';
      case GameType.TAROT:
        return 'Tarot';
      default:
        return null;
    }
  }
}
