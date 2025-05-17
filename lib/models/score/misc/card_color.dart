// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:carg/l10n/app_localizations.dart';

enum CardColor { HEART, DIAMOND, CLUB, SPADE, ALL_TRUMP, NO_TRUMP }

extension CardColorExtension on CardColor? {
  String name(BuildContext context) {
    switch (this) {
      case CardColor.HEART:
        return AppLocalizations.of(context)!.cardColorHeart;
      case CardColor.DIAMOND:
        return AppLocalizations.of(context)!.cardColorDiamond;
      case CardColor.CLUB:
        return AppLocalizations.of(context)!.cardColorClub;
      case CardColor.SPADE:
        return AppLocalizations.of(context)!.cardColorSpade;
      case CardColor.ALL_TRUMP:
        return AppLocalizations.of(context)!.cardColorAllTrump;
      case CardColor.NO_TRUMP:
        return AppLocalizations.of(context)!.cardColorNoTrump;
      default:
        return '';
    }
  }

  String get symbol {
    switch (this) {
      case CardColor.HEART:
        return '❤';
      case CardColor.DIAMOND:
        return '♦';
      case CardColor.CLUB:
        return '♣';
      case CardColor.SPADE:
        return '♠';
      case CardColor.ALL_TRUMP:
        return '🃏';
      case CardColor.NO_TRUMP:
        return '🚫';
      default:
        return '';
    }
  }
}
