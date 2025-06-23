import 'package:carg/helpers/correct_instance.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/score/misc/belote_special_round.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/services/round/abstract_round_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:flutter/material.dart';

class SpecialRoundDialog extends StatelessWidget {
  final Belote? beloteGame;
  final BeloteRound? beloteRound;
  final AbstractRoundService roundService;

  const SpecialRoundDialog({
    super.key,
    this.beloteGame,
    this.beloteRound,
    required this.roundService,
  });

  void createRound(BeloteSpecialRound beloteSpecialRound) async {
    var specialRound = CorrectInstance.ofSpecialRound(
      beloteGame!,
      beloteSpecialRound,
      "playerID",
    );
    await roundService.addRoundToGame(beloteGame!.id, specialRound);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              foregroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    CustomProperties.borderRadius,
                  ),
                ),
              ),
            ),
            onPressed: () => {
              createRound(BeloteSpecialRound.misere),
              Navigator.pop(context),
            },
            child: const Text("Misère"),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              foregroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    CustomProperties.borderRadius,
                  ),
                ),
              ),
            ),
            onPressed: () => {
              createRound(BeloteSpecialRound.fausseDonne),
              Navigator.pop(context),
            },
            child: const Text("Fausse donne"),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.error,
              ),
              foregroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.onError,
              ),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    CustomProperties.borderRadius,
                  ),
                ),
              ),
            ),
            onPressed: () => {
              createRound(BeloteSpecialRound.foulPlay),
              Navigator.pop(context),
            },
            child: const Text("Faute de jeu"),
          ),
        ],
      ),
    );
  }
}
