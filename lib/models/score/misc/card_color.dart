enum CardColor { HEART, DIAMOND, CLUB, SPADE, ALL_TRUMP, NO_TRUMP }

extension CardColorExtension on CardColor {
  String get name {
    switch (this) {
      case CardColor.HEART:
        return 'Coeur';
      case CardColor.DIAMOND:
        return 'Carreau';
      case CardColor.CLUB:
        return 'Trèfle';
      case CardColor.SPADE:
        return 'Pic';
      case CardColor.ALL_TRUMP:
        return 'Tout atout';
      case CardColor.NO_TRUMP:
        return 'Sans atout';
      default:
        return '';
    }
  }

  String get symbol {
    switch (this) {
      case CardColor.HEART:
        return '❤';
      case CardColor.DIAMOND:
        return '♦';
      case CardColor.CLUB:
        return '♣';
      case CardColor.SPADE:
        return '♠';
      case CardColor.ALL_TRUMP:
        return '🃋';
      case CardColor.NO_TRUMP:
        return '🃁';
      default:
        return '';
    }
  }
}
