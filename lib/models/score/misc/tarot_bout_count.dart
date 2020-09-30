enum TarotBoutCount { ZERO, ONE, TWO, THREE }

extension TarotBoutExtension on TarotBoutCount {
  int get pointToDo {
    switch (this) {
      case TarotBoutCount.ZERO:
        return 56;
      case TarotBoutCount.ONE:
        return 51;
      case TarotBoutCount.TWO:
        return 41;
      case TarotBoutCount.THREE:
        return 36;
      default:
        return null;
    }
  }

  String get string {
    switch (this) {
      case TarotBoutCount.ZERO:
        return 0.toString();
      case TarotBoutCount.ONE:
        return 1.toString();
      case TarotBoutCount.TWO:
        return 2.toString();
      case TarotBoutCount.THREE:
        return 3.toString();
      default:
        return null;
    }
  }
}
