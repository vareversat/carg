// ignore_for_file: constant_identifier_names
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum BeloteContractType { NORMAL, CAPOT, GENERALE, FAILED_GENERALE }

extension BeloteContractTypeExtension on BeloteContractType {
  String name(BuildContext context) {
    switch (this) {
      case BeloteContractType.NORMAL:
        return AppLocalizations.of(context)!.contractTypeNormal;
      case BeloteContractType.CAPOT:
        return AppLocalizations.of(context)!.contractTypeCapot;
      case BeloteContractType.GENERALE:
        return AppLocalizations.of(context)!.contractTypeGenerale;
      case BeloteContractType.FAILED_GENERALE:
        return AppLocalizations.of(context)!.contractTypeFailedGenerale;
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
