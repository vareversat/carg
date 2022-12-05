// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TarotChelem { PASSED, ANNOUNCED_AND_PASSED, FAILED }

extension TarotChelemExtension on TarotChelem? {
  String name(BuildContext context) {
    switch (this) {
      case TarotChelem.PASSED:
        return AppLocalizations.of(context)!.tarotChelemWon;
      case TarotChelem.ANNOUNCED_AND_PASSED:
        return AppLocalizations.of(context)!.tarotChelemAnnouncedAndWon;
      case TarotChelem.FAILED:
        return AppLocalizations.of(context)!.tarotChelemFailed;
      default:
        return '';
    }
  }

  int get bonus {
    switch (this) {
      case TarotChelem.PASSED:
        return 200;
      case TarotChelem.ANNOUNCED_AND_PASSED:
        return 400;
      case TarotChelem.FAILED:
        return -200;
      default:
        return 0;
    }
  }
}
