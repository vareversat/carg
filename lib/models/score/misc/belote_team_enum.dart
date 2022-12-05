// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum BeloteTeamEnum { US, THEM }

extension BeloteTeamEnumExtension on BeloteTeamEnum? {
  String name(BuildContext context) {
    switch (this) {
      case BeloteTeamEnum.US:
        return AppLocalizations.of(context)!.us;
      case BeloteTeamEnum.THEM:
        return AppLocalizations.of(context)!.them;
      default:
        return '';
    }
  }
}
