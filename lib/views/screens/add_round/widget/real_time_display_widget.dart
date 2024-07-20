import 'package:carg/models/score/round/round.dart';
import 'package:carg/views/dialogs/score_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RealTimeDisplayWidget extends StatelessWidget {
  final Round round;

  const RealTimeDisplayWidget({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: round,
      child: Consumer<Round>(
        builder: (context, roundData, child) => Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                roundData.realTimeDisplay(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 23,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.info,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () async => await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      ScoreInfoDialog(round: round),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
