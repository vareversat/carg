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
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case BeloteSpecialRound.misere:
        return Theme.of(context).colorScheme.primary;
      case BeloteSpecialRound.fausseDonne:
        return Theme.of(context).colorScheme.secondary;
      case BeloteSpecialRound.foulPlay:
        return Theme.of(context).colorScheme.error;
    }
  }

  Color textColor(BuildContext context) {
    switch (this) {
      case BeloteSpecialRound.misere:
        return Theme.of(context).colorScheme.onPrimary;
      case BeloteSpecialRound.fausseDonne:
        return Theme.of(context).colorScheme.onSecondary;
      case BeloteSpecialRound.foulPlay:
        return Theme.of(context).colorScheme.onError;
    }
  }
}
