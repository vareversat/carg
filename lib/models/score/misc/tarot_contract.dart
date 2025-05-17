// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:carg/l10n/app_localizations.dart';

enum TarotContract { PETITE, GARDE_AVEC_CHIEN, GARDE_SANS_CHIEN, GARDE_CONTRE }

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

  String name(BuildContext context) {
    switch (this) {
      case TarotContract.PETITE:
        return AppLocalizations.of(context)!.tarotSmall;
      case TarotContract.GARDE_AVEC_CHIEN:
        return AppLocalizations.of(context)!.tarotGuardWithKitty;
      case TarotContract.GARDE_SANS_CHIEN:
        return AppLocalizations.of(context)!.tarotGuardNoKitty;
      case TarotContract.GARDE_CONTRE:
        return AppLocalizations.of(context)!.tarotGuardAgainstKitty;
      default:
        return '';
    }
  }
}
