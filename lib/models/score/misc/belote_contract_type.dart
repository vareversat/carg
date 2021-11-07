enum BeloteContractType { NORMAL, CAPOT, GENERALE, FAILED_GENERALE }

extension BeloteContractTypeExtension on BeloteContractType {
  String get name {
    switch (this) {
      case BeloteContractType.NORMAL:
        return 'Normal';
      case BeloteContractType.CAPOT:
        return 'Capot';
      case BeloteContractType.GENERALE:
        return 'Générale';
      case BeloteContractType.FAILED_GENERALE:
        return 'Générale chutée';
      default:
        return '';
    }
  }

  int bonus(int score) {
    switch (this) {
      case BeloteContractType.NORMAL:
        return score;
      case BeloteContractType.CAPOT:
        return 250;
      case BeloteContractType.GENERALE:
        return 500;
      case BeloteContractType.FAILED_GENERALE:
        return 500;
      default:
        return 0;
    }
  }
}
