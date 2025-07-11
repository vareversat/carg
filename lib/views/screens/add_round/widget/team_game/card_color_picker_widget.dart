import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:flutter/material.dart';

class CardColorPickerWidget extends StatelessWidget {
  final BeloteRound? beloteRound;

  const CardColorPickerWidget({super.key, required this.beloteRound});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('cardColorPickerWidget'),
      children: [
        Text(
          '${AppLocalizations.of(context)!.color} (${beloteRound?.cardColor.name(context)})',
          key: const ValueKey('cardColorPickerTitle'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                children: CardColor.values
                    .map(
                      (cardColor) => InputChip(
                        key: ValueKey(
                          'cardColorInputChip-${cardColor.name(context)}',
                        ),
                        selected: beloteRound?.cardColor == cardColor,
                        onPressed: () => {beloteRound?.cardColor = cardColor},
                        label: Text(cardColor.symbol),
                      ),
                    )
                    .toList()
                    .cast<Widget>(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
