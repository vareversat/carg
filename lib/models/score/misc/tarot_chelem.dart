// ignore_for_file: constant_identifier_names

enum TarotChelem { PASSED, ANNOUNCED_AND_PASSED, FAILED }

extension TarotChelemExtension on TarotChelem? {
  String get name {
    switch (this) {
      case TarotChelem.PASSED:
        return 'Remporté';
      case TarotChelem.ANNOUNCED_AND_PASSED:
        return 'Annoncé et remporté';
      case TarotChelem.FAILED:
        return 'Échoué';
      default:
        return '';
    }
  }

  int get bonus {
    switch (this) {
      case TarotChelem.PASSED:
        return 200;
      case TarotChelem.ANNOUNCED_AND_PASSED:
        return 400;
      case TarotChelem.FAILED:
        return -200;
      default:
        return 0;
    }
  }
}
