// ignore_for_file: constant_identifier_names
import 'package:carg/l10n/app_localizations.dart';

import 'package:flutter/material.dart';

enum GameType { COINCHE, BELOTE, TAROT, CONTREE, UNDEFINE }

extension GameTypeExtension on GameType? {
  String get ruleUrl {
    switch (this) {
      case GameType.COINCHE:
        return 'http://www.ffbelote.org/wp-content/uploads/2015/11/REGLES-DE-LA-BELOTE-COINCHEE.pdf';
      case GameType.BELOTE:
        return 'http://www.ffbelote.org/wp-content/uploads/2016/01/regles-officielles-de-la-Belote-27-01-2016.pdf';
      case GameType.TAROT:
        return 'http://www.fftarot.fr/assets/documents/R-RO201206.pdf';
      case GameType.CONTREE:
        return 'http://www.ffbelote.org/wp-content/uploads/2015/11/REGLES-DE-LA-BELOTE-CONTREE.pdf';
      case GameType.UNDEFINE:
        throw Exception('No rule URL for game type ${GameType.UNDEFINE.name}');
      case null:
        throw Exception('Rule URL not defined for null');
    }
  }

  String get name {
    switch (this) {
      case GameType.COINCHE:
        return 'Coinche';
      case GameType.BELOTE:
        return 'Belote';
      case GameType.TAROT:
        return 'Tarot';
      case GameType.CONTREE:
        return 'Contrée';
      case GameType.UNDEFINE:
        throw Exception(
          'Name not defined for game type ${GameType.UNDEFINE.name}',
        );
      case null:
        throw Exception('GameType not defined for null');
    }
  }

  String direction(BuildContext context) {
    switch (this) {
      case GameType.COINCHE:
        return AppLocalizations.of(context)!.gameAnticlockwiseDirection;
      case GameType.BELOTE:
        return AppLocalizations.of(context)!.gameClockwiseDirection;
      case GameType.TAROT:
        return AppLocalizations.of(context)!.gameAnticlockwiseDirection;
      case GameType.CONTREE:
        return AppLocalizations.of(context)!.gameAnticlockwiseDirection;
      case GameType.UNDEFINE:
        throw Exception(
          'Direction not defined for game type ${GameType.UNDEFINE.name}',
        );
      case null:
        throw Exception('Direction not defined for null');
    }
  }

  String get rulesFile {
    switch (this) {
      case GameType.COINCHE:
        return 'coinche_belote_rules.md';
      case GameType.BELOTE:
        return 'french_belote_rules.md';
      case GameType.TAROT:
        return 'tarot_rules.md';
      case GameType.CONTREE:
        return 'contree_belote_rules.md';
      case GameType.UNDEFINE:
        throw Exception(
          'Rules not defined for game type ${GameType.UNDEFINE.name}',
        );
      case null:
        throw Exception('Rules not defined for null');
    }
  }
}
