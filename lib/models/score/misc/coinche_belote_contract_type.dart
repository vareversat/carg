enum CoincheBeloteContractType { NORMAL, CAPOT, GENERALE, FAILED_GENERALE }

extension BeloteContractTypeExtension on CoincheBeloteContractType {
  String get name {
    switch (this) {
      case CoincheBeloteContractType.NORMAL:
        return 'Normal';
      case CoincheBeloteContractType.CAPOT:
        return 'Capot';
      case CoincheBeloteContractType.GENERALE:
        return 'Générale';
      case CoincheBeloteContractType.FAILED_GENERALE:
        return 'Générale chutée';
      default:
        return '';
    }
  }

  int bonus(int score) {
    switch (this) {
      case CoincheBeloteContractType.NORMAL:
        return score;
      case CoincheBeloteContractType.CAPOT:
        return 250;
      case CoincheBeloteContractType.GENERALE:
        return 500;
      case CoincheBeloteContractType.FAILED_GENERALE:
        return 500;
      default:
        return 0;
    }
  }
}
