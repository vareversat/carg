import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TakerTeamWidget extends StatelessWidget {
  final BeloteRound beloteRound;

  const TakerTeamWidget({super.key, required this.beloteRound});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: beloteRound,
      child: Consumer<BeloteRound>(
        builder: (context, roundData, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SectionTitleWidget(
              title: AppLocalizations.of(context)!.takerTitleBelote,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputChip(
                  key: const ValueKey('takerTeamWidget-usPicker'),
                  selected: beloteRound.taker == BeloteTeamEnum.US,
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () => {
                    beloteRound.taker = BeloteTeamEnum.US,
                    beloteRound.defender = BeloteTeamEnum.THEM,
                  },
                  label: Text(
                    BeloteTeamEnum.US.name(context),
                    style: const TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                InputChip(
                  key: const ValueKey('takerTeamWidget-themPicker'),
                  selected: beloteRound.taker == BeloteTeamEnum.THEM,
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () => {
                    beloteRound.taker = BeloteTeamEnum.THEM,
                    beloteRound.defender = BeloteTeamEnum.US,
                  },
                  label: Text(
                    BeloteTeamEnum.THEM.name(context),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
