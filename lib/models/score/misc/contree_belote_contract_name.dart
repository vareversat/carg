enum ContreeBeloteContractName { NORMAL, CONTRE, SURCONTRE, CAPOT, GENERALE }

extension ContreeBeloteContractNameExtension on ContreeBeloteContractName? {
  String get name {
    switch (this) {
      case ContreeBeloteContractName.NORMAL:
        return 'Normal';
      case ContreeBeloteContractName.CAPOT:
        return 'Capot';
      case ContreeBeloteContractName.CONTRE:
        return 'Contre';
      case ContreeBeloteContractName.SURCONTRE:
        return 'Surcontre';
      case ContreeBeloteContractName.GENERALE:
        return 'Générale';
      default:
        return '';
    }
  }

  int bonus(int currentScore) {
    switch (this) {
      case ContreeBeloteContractName.NORMAL:
        return currentScore;
      case ContreeBeloteContractName.CONTRE:
        return currentScore * 2;
      case ContreeBeloteContractName.SURCONTRE:
        return currentScore * 4;
      case ContreeBeloteContractName.CAPOT:
        return 500;
      case ContreeBeloteContractName.GENERALE:
        return 1000;
      default:
        return currentScore;
    }
  }
}
