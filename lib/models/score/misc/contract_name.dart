enum ContractName { NORMAL, COINCHE, SURCOINCHE, CAPOT, GENERALE }

extension ContractNameExtension on ContractName {
  String get name {
    switch (this) {
      case ContractName.NORMAL:
        return 'Normal';
      case ContractName.CAPOT:
        return 'Capot';
      case ContractName.COINCHE:
        return 'Coinche';
      case ContractName.SURCOINCHE:
        return 'Surcoinche';
      case ContractName.GENERALE:
        return 'Générale';
      default:
        return '';
    }
  }

  int bonus(int currentScore, int contract) {
    switch (this) {
      case ContractName.NORMAL:
        return currentScore;
      case ContractName.COINCHE:
        return currentScore * 2;
      case ContractName.SURCOINCHE:
        return currentScore * 4;
      case ContractName.CAPOT:
        return 250 + contract;
      case ContractName.GENERALE:
        return 500 + contract;
      default:
        return currentScore;
    }
  }
}
