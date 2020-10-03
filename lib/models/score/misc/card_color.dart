enum CardColor { COEUR, CARREAU, TREFLE, PIC, TOUT_ATOUT, SANS_ATOUT }

extension CardColorExtension on CardColor {
  String get name {
    switch (this) {
      case CardColor.COEUR:
        return 'Coeur';
      case CardColor.CARREAU:
        return 'Carreau';
      case CardColor.TREFLE:
        return 'Trèfle';
      case CardColor.PIC:
        return 'Pic';
      case CardColor.TOUT_ATOUT:
        return 'Tout atout';
      case CardColor.SANS_ATOUT:
        return 'Sans atout';
      default:
        return '';
    }
  }

  String get symbol {
    switch (this) {
      case CardColor.COEUR:
        return '❤';
      case CardColor.CARREAU:
        return '♦';
      case CardColor.TREFLE:
        return '♣';
      case CardColor.PIC:
        return '♠';
      case CardColor.TOUT_ATOUT:
        return '🃋';
      case CardColor.SANS_ATOUT:
        return '🃁';
      default:
        return '';
    }
  }
}
