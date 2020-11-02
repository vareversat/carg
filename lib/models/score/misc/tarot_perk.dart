enum TarotBonus { SMALL_TO_THE_END, HANDFUL, CHELEM }

extension TarotBonusExtension on TarotBonus {
  String get name {
    switch (this) {
      case TarotBonus.SMALL_TO_THE_END:
        return 'Petit au bout';
      case TarotBonus.HANDFUL:
        return 'Poignée';
      case TarotBonus.CHELEM:
        return 'Chelem';
      default:
        return '';
    }
  }
}
