enum TarotHandful { SIMPLE, DOUBLE, TRIPLE }

extension TarotHandfulExtension on TarotHandful? {
  int get perkCount {
    switch (this) {
      case TarotHandful.SIMPLE:
        return 10;
      case TarotHandful.DOUBLE:
        return 13;
      case TarotHandful.TRIPLE:
        return 15;
      default:
        return 0;
    }
  }

  int? get bonus {
    switch (this) {
      case TarotHandful.SIMPLE:
        return 20;
      case TarotHandful.DOUBLE:
        return 30;
      case TarotHandful.TRIPLE:
        return 40;
      default:
        return null;
    }
  }

  String? get name {
    switch (this) {
      case TarotHandful.SIMPLE:
        return 'Simple';
      case TarotHandful.DOUBLE:
        return 'Double';
      case TarotHandful.TRIPLE:
        return 'Triple';
      default:
        return null;
    }
  }
}
