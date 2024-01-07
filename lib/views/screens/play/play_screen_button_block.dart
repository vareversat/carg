import 'package:carg/styles/properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayScreenButtonBlock extends StatelessWidget {
  final Function deleteLastRound;
  final Function editLastRound;
  final Function endGame;
  final Function addNewRound;
  final Function addNotes;
  final bool lastRoundLayout;

  const PlayScreenButtonBlock({
    super.key,
    required this.deleteLastRound,
    required this.editLastRound,
    required this.endGame,
    required this.addNewRound,
    required this.addNotes,
    required this.lastRoundLayout,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      alignment: WrapAlignment.center,
      children: <Widget>[
        RawMaterialButton(
          onPressed: () async => {deleteLastRound()},
          elevation: 2.0,
          fillColor: Theme.of(context).colorScheme.error,
          textStyle: TextStyle(color: Theme.of(context).cardColor),
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.delete_rounded,
            size: 22,
          ),
        ),
        RawMaterialButton(
          onPressed: () async => {editLastRound()},
          elevation: 2.0,
          fillColor: Colors.black,
          textStyle: TextStyle(color: Theme.of(context).cardColor),
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.edit,
            size: 22,
          ),
        ),
        RawMaterialButton(
          onPressed: () async => {addNotes()},
          elevation: 2.0,
          fillColor: Theme.of(context).colorScheme.secondary,
          textStyle: TextStyle(color: Theme.of(context).cardColor),
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.notes,
            size: 22,
          ),
        ),
        AnimatedSize(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 500),
          child: !lastRoundLayout
              ? RawMaterialButton(
                  onPressed: () async => {endGame()},
                  elevation: 2.0,
                  fillColor: Theme.of(context).colorScheme.error,
                  textStyle: TextStyle(color: Theme.of(context).cardColor),
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.stop,
                    size: 22,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 500),
                child: !lastRoundLayout
                    ? ElevatedButton.icon(
                        key: const ValueKey("addRoundButton"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).cardColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  CustomProperties.borderRadius),
                            ),
                          ),
                        ),
                        onPressed: () => {addNewRound()},
                        icon: const Icon(Icons.plus_one, size: 30),
                        label: Text(
                          AppLocalizations.of(context)!.newRound,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                      )
                    : ElevatedButton.icon(
                        key: const ValueKey("endGameButton"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.error),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).cardColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  CustomProperties.borderRadius),
                            ),
                          ),
                        ),
                        onPressed: () => {endGame()},
                        icon: const Icon(Icons.stop, size: 30),
                        label: Text(
                          AppLocalizations.of(context)!.stop,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                      ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
