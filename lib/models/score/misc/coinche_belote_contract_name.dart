enum CoincheBeloteContractName { NORMAL, COINCHE, SURCOINCHE, CAPOT, GENERALE }

extension CoincheBeloteContractNameExtension on CoincheBeloteContractName? {
  String get name {
    switch (this) {
      case CoincheBeloteContractName.NORMAL:
        return 'Normal';
      case CoincheBeloteContractName.CAPOT:
        return 'Capot';
      case CoincheBeloteContractName.COINCHE:
        return 'Coinche';
      case CoincheBeloteContractName.SURCOINCHE:
        return 'Surcoinche';
      case CoincheBeloteContractName.GENERALE:
        return 'Générale';
      default:
        return '';
    }
  }

  int bonus(int currentScore, int? contract) {
    switch (this) {
      case CoincheBeloteContractName.NORMAL:
        return currentScore;
      case CoincheBeloteContractName.COINCHE:
        return currentScore * 2;
      case CoincheBeloteContractName.SURCOINCHE:
        return currentScore * 4;
      case CoincheBeloteContractName.CAPOT:
        return 250;
      case CoincheBeloteContractName.GENERALE:
        return 500;
      default:
        return currentScore;
    }
  }
}
