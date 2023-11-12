// ignore_for_file: constant_identifier_names
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TarotBonus { SMALL_TO_THE_END, HANDFUL, CHELEM }

extension TarotBonusExtension on TarotBonus {
  String name(BuildContext context) {
    switch (this) {
      case TarotBonus.SMALL_TO_THE_END:
        return AppLocalizations.of(context)!.tarotSmallToTheEnd;
      case TarotBonus.HANDFUL:
        return AppLocalizations.of(context)!.tarotPoignee;
      case TarotBonus.CHELEM:
        return AppLocalizations.of(context)!.tarotChelem;
      default:
        return '';
    }
  }
}
