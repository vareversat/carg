import 'package:carg/styles/properties.dart';
import 'package:flutter/material.dart';
import 'package:carg/l10n/app_localizations.dart';

class PlayScreenButtonBlock extends StatelessWidget {
  final Function endGame;
  final Function addNewRound;
  final Function addNotes;
  final Function? addNewSpecialRound;
  final bool lastRoundLayout;

  const PlayScreenButtonBlock({
    super.key,
    required this.endGame,
    required this.addNewRound,
    required this.addNotes,
    required this.addNewSpecialRound,
    required this.lastRoundLayout,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      alignment: WrapAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async => {addNotes()},
          style: ButtonStyle(
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
              ),
            ),
          ),
          child: const Icon(Icons.notes, size: 22),
        ),
        AnimatedSize(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 500),
          child: !lastRoundLayout
              ? ElevatedButton(
                  onPressed: () async => {endGame()},
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          CustomProperties.borderRadius,
                        ),
                      ),
                    ),
                  ),
                  child: const Icon(Icons.stop, size: 22),
                )
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 500),
                child: !lastRoundLayout
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (addNewSpecialRound != null)
                            IconButton(
                              onPressed: () => {addNewSpecialRound!()},
                              icon: Icon(
                                Icons.add_circle_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              ),
                            ),
                          ElevatedButton(
                            key: const ValueKey("addRoundButton"),
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).primaryColor,
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).cardColor,
                              ),
                              shape: WidgetStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () => {addNewRound()},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.newRound,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton.icon(
                        key: const ValueKey("endGameButton"),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.error,
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).cardColor,
                          ),
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                CustomProperties.borderRadius,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () => {endGame()},
                        icon: const Icon(Icons.stop, size: 30),
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.stop,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
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
