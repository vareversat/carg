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
        throw Exception('ContreeBeloteContractName missing');
    }
  }

  int get multiplier {
    switch (this) {
      case ContreeBeloteContractName.NORMAL:
        return 1;
      case ContreeBeloteContractName.CONTRE:
        return 2;
      case ContreeBeloteContractName.SURCONTRE:
        return 4;
      default:
        throw Exception('ContreeBeloteContractName missing');
    }
  }
}
