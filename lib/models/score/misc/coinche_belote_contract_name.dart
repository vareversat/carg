enum CoincheBeloteContractName { NORMAL, COINCHE, SURCOINCHE }

extension CoincheBeloteContractNameExtension on CoincheBeloteContractName? {
  String get name {
    switch (this) {
      case CoincheBeloteContractName.NORMAL:
        return 'Normal';
      case CoincheBeloteContractName.COINCHE:
        return 'Coinche';
      case CoincheBeloteContractName.SURCOINCHE:
        return 'Surcoinche';
      default:
        throw Exception('CoincheBeloteContractName missing');
    }
  }

  int get multiplier {
    switch (this) {
      case CoincheBeloteContractName.NORMAL:
        return 1;
      case CoincheBeloteContractName.COINCHE:
        return 2;
      case CoincheBeloteContractName.SURCOINCHE:
        return 4;
      default:
        throw Exception('CoincheBeloteContractName missing');
    }
  }
}
