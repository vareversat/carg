enum TarotOudler { ZERO, ONE, TWO, THREE }

extension TarotOudlerExtension on TarotOudler? {
  double? get pointToDo {
    switch (this) {
      case TarotOudler.ZERO:
        return 56;
      case TarotOudler.ONE:
        return 51;
      case TarotOudler.TWO:
        return 41;
      case TarotOudler.THREE:
        return 36;
      default:
        return null;
    }
  }

  String? get name {
    switch (this) {
      case TarotOudler.ZERO:
        return '0';
      case TarotOudler.ONE:
        return '1';
      case TarotOudler.TWO:
        return '2';
      case TarotOudler.THREE:
        return '3';
      default:
        return null;
    }
  }
}
