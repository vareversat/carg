// ignore_for_file: constant_identifier_names

enum TarotContract {
  PETITE,
  GARDE_AVEC_CHIEN,
  GARDE_SANS_CHIEN,
  GARDE_CONTRE,
}

extension TarotContractExtension on TarotContract? {
  int get multiplayer {
    switch (this) {
      case TarotContract.PETITE:
        return 1;
      case TarotContract.GARDE_AVEC_CHIEN:
        return 2;
      case TarotContract.GARDE_SANS_CHIEN:
        return 4;
      case TarotContract.GARDE_CONTRE:
        return 6;
      default:
        return 0;
    }
  }

  String get name {
    switch (this) {
      case TarotContract.PETITE:
        return 'Petite';
      case TarotContract.GARDE_AVEC_CHIEN:
        return 'Garde avec chien';
      case TarotContract.GARDE_SANS_CHIEN:
        return 'Garde sans chien';
      case TarotContract.GARDE_CONTRE:
        return 'Garde contre';
      default:
        return '';
    }
  }
}
