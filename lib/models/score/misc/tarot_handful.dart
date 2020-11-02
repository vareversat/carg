enum TarotHandful { SIMPLE, DOUBLE, TRIPLE }

extension TarotHandfulExtension on TarotHandful {
  String perkCount(var playerCount) {
    switch (this) {
      case TarotHandful.SIMPLE:
        var rules = [
          {'playerCount': 3, 'perkCount': 13},
          {'playerCount': 4, 'perkCount': 10},
          {'playerCount': 5, 'perkCount': 8}
        ];
        return rules
            .firstWhere(
                (element) => element['playerCount'] == playerCount)['perkCount']
            .toString();
      case TarotHandful.DOUBLE:
        var rules = [
          {'playerCount': 3, 'perkCount': 15},
          {'playerCount': 4, 'perkCount': 13},
          {'playerCount': 5, 'perkCount': 10}
        ];
        return rules
            .firstWhere(
                (element) => element['playerCount'] == playerCount)['perkCount']
            .toString();
      case TarotHandful.TRIPLE:
        var rules = [
          {'playerCount': 3, 'perkCount': 18},
          {'playerCount': 4, 'perkCount': 15},
          {'playerCount': 5, 'perkCount': 13}
        ];
        return rules
            .firstWhere(
                (element) => element['playerCount'] == playerCount)['perkCount']
            .toString();
      default:
        return null;
    }
  }

  int get bonus {
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

  String get name {
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
