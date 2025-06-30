import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrickPointsTarotWidget extends StatelessWidget {
  final TarotRound tarotRound;

  const TrickPointsTarotWidget({super.key, required this.tarotRound});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: tarotRound,
      child: Consumer<TarotRound>(
        builder: (context, roundData, _) => Column(
          children: [
            SectionTitleWidget(
              title: AppLocalizations.of(context)!.trickPoints,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      roundData.attackTrickPoints--;
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.chevron_left_outlined),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Slider(
                    value: roundData.attackTrickPoints,
                    min: 0,
                    max: TarotRound.maxTrickPoints,
                    divisions: TarotRound.maxTrickPoints.toInt(),
                    onChanged: (double value) {
                      roundData.attackTrickPoints = value.roundToDouble();
                    },
                  ),
                ),
                Flexible(
                  child: MaterialButton(
                    onPressed: () {
                      roundData.attackTrickPoints++;
                    },
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.chevron_right_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${AppLocalizations.of(context)!.attack} : ${roundData.attackTrickPoints.round().toString()} '
              '| ${AppLocalizations.of(context)!.defense} : ${roundData.defenseTrickPoints.round().toString()}',
            ),
          ],
        ),
      ),
    );
  }
}
