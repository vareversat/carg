import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TakerTeamWidget extends StatelessWidget {
  final BeloteRound beloteRound;

  const TakerTeamWidget({required this.beloteRound});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: beloteRound,
      child: Consumer<BeloteRound>(
        builder: (context, roundData, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SectionTitleWidget(title: 'Équipe preneuse'),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _RadioButtonRow(
                    team: BeloteTeamEnum.US, beloteRound: roundData),
                _RadioButtonRow(
                    team: BeloteTeamEnum.THEM, beloteRound: roundData)
              ])
            ]),
      ),
    );
  }
}

class _RadioButtonRow extends StatelessWidget {
  final BeloteTeamEnum team;
  final BeloteRound beloteRound;

  const _RadioButtonRow({required this.team, required this.beloteRound});

  @override
  Widget build(BuildContext context) {
    return Wrap(
        textDirection:
            team == BeloteTeamEnum.US ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Radio(
              visualDensity: VisualDensity.compact,
              value: team,
              groupValue: beloteRound.taker,
              onChanged: (BeloteTeamEnum? value) {
                beloteRound.taker = value!;
                if (team == BeloteTeamEnum.US) {
                  beloteRound.defender = BeloteTeamEnum.THEM;
                } else {
                  beloteRound.defender = BeloteTeamEnum.US;
                }
              }),
          Text(team.name, style: Theme.of(context).textTheme.bodyText2)
        ]);
  }
}
