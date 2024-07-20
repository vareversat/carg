import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:carg/styles/properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ScoreInfoDialog extends StatelessWidget {
  final Round round;

  const ScoreInfoDialog({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: ChangeNotifierProvider.value(
        value: round,
        child: Consumer<Round>(
          builder: (context, roundData, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                roundData.realTimeInfoDisplay(context),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox.shrink()
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
