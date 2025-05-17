// ignore_for_file: constant_identifier_names
import 'package:flutter/widgets.dart';
import 'package:carg/l10n/app_localizations.dart';

enum TarotHandful { SIMPLE, DOUBLE, TRIPLE }

extension TarotHandfulExtension on TarotHandful? {
  int get perkCount {
    switch (this) {
      case TarotHandful.SIMPLE:
        return 10;
      case TarotHandful.DOUBLE:
        return 13;
      case TarotHandful.TRIPLE:
        return 15;
      default:
        return 0;
    }
  }

  int? get bonus {
    switch (this) {
      case TarotHandful.SIMPLE:
        return 20;
      case TarotHandful.DOUBLE:
        return 30;
      case TarotHandful.TRIPLE:
        return 40;
      default:
        return null;
    }
  }

  String? name(BuildContext context) {
    switch (this) {
      case TarotHandful.SIMPLE:
        return AppLocalizations.of(context)!.tarotPoigneeSimple;
      case TarotHandful.DOUBLE:
        return AppLocalizations.of(context)!.tarotPoigneeDouble;
      case TarotHandful.TRIPLE:
        return AppLocalizations.of(context)!.tarotPoigneeTriple;
      default:
        return null;
    }
  }
}
