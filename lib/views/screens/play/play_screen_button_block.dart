import 'package:carg/styles/custom_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayScreenButtonBlock extends StatelessWidget {
  final Function deleteLastRound;
  final Function editLastRound;
  final Function endGame;
  final Function addNewRound;
  final Function addNotes;

  const PlayScreenButtonBlock({
    super.key,
    required this.deleteLastRound,
    required this.editLastRound,
    required this.endGame,
    required this.addNewRound,
    required this.addNotes,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;

    return Wrap(
      runSpacing: 10,
      spacing: 10,
      alignment: WrapAlignment.spaceEvenly,
      children: <Widget>[
        RawMaterialButton(
          onPressed: () => deleteLastRound(),
          elevation: 2.0,
          fillColor: colorScheme.error,
          textStyle: TextStyle(color: cardColor),
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.delete_rounded,
            size: 22,
          ),
        ),
        RawMaterialButton(
          onPressed: () => editLastRound(),
          elevation: 2.0,
          fillColor: Colors.black,
          textStyle: TextStyle(color: cardColor),
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.edit,
            size: 22,
          ),
        ),
        RawMaterialButton(
          onPressed: () => addNotes(),
          elevation: 2.0,
          fillColor: colorScheme.secondary,
          textStyle: TextStyle(color: cardColor),
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.notes,
            size: 22,
          ),
        ),
        RawMaterialButton(
          onPressed: () => endGame(),
          elevation: 2.0,
          fillColor: colorScheme.error,
          textStyle: TextStyle(color: cardColor),
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.stop,
            size: 22,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    cardColor,
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(CustomProperties.borderRadius),
                    ),
                  ),
                ),
                onPressed: () => {addNewRound()},
                icon: const Icon(Icons.plus_one, size: 30),
                label: Text(
                  AppLocalizations.of(context)!.newRound,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
