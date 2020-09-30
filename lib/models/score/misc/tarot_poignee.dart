enum TarotPoignee { SIMPLE, DOUBLE, TRIPLE }

extension TarotPoigneeExtension on TarotPoignee {
  String perkCount(var playerCount) {
    switch (this) {
      case TarotPoignee.SIMPLE:
        var rules = [
          {'playerCount': 3, 'perkCount': 13},
          {'playerCount': 4, 'perkCount': 10},
          {'playerCount': 5, 'perkCount': 8}
        ];
        return rules
            .firstWhere(
                (element) => element['playerCount'] == playerCount)['perkCount']
            .toString();
      case TarotPoignee.DOUBLE:
        var rules = [
          {'playerCount': 3, 'perkCount': 15},
          {'playerCount': 4, 'perkCount': 13},
          {'playerCount': 5, 'perkCount': 10}
        ];
        return rules
            .firstWhere(
                (element) => element['playerCount'] == playerCount)['perkCount']
            .toString();
      case TarotPoignee.TRIPLE:
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
      case TarotPoignee.SIMPLE:
        return 20;
      case TarotPoignee.DOUBLE:
        return 30;
      case TarotPoignee.TRIPLE:
        return 40;
      default:
        return null;
    }
  }

  String get name {
    switch (this) {
      case TarotPoignee.SIMPLE:
        return 'Simple';
      case TarotPoignee.DOUBLE:
        return 'Double';
      case TarotPoignee.TRIPLE:
        return 'Triple';
      default:
        return null;
    }
  }
}
