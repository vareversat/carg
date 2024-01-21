import 'package:flutter/material.dart';

enum BeloteSpecialRound { misere, fausseDonne, foulPlay }

extension BeloteSpecialRoundExtension on BeloteSpecialRound {
  String name() {
    switch (this) {
      case BeloteSpecialRound.misere:
        return "Misère";
      case BeloteSpecialRound.fausseDonne:
        return "Fausse donne";
      case BeloteSpecialRound.foulPlay:
        return "Faute de jeu";
      default:
        return '';
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case BeloteSpecialRound.misere:
        return Theme.of(context).primaryColor;
      case BeloteSpecialRound.fausseDonne:
        return Theme.of(context).primaryColor;
      case BeloteSpecialRound.foulPlay:
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}
