enum TarotPerk {
  PETIT_AU_BOUT,
  POIGNEE
}

extension TarotPrimeExtension on TarotPerk {
  String get string {
    switch (this) {
      case TarotPerk.PETIT_AU_BOUT:
        return 'Petit au bout';
      case TarotPerk.POIGNEE:
        return 'Poignée';
      default:
        return null;
    }
  }
}