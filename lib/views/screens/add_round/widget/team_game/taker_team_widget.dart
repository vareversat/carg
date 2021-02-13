import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';

class TakerTeamWidget extends StatelessWidget {
  final BeloteRound round;

  const TakerTeamWidget({this.round});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SectionTitleWidget(title: 'Équipe preneuse'),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _RadioButtonRow(team: BeloteTeamEnum.US, round: round),
            _RadioButtonRow(team: BeloteTeamEnum.THEM, round: round)
          ])
        ]);
  }
}

class _RadioButtonRow extends StatelessWidget {
  final BeloteTeamEnum team;
  final BeloteRound round;

  const _RadioButtonRow({this.team, this.round});

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
              groupValue: round.taker,
              onChanged: (BeloteTeamEnum value) {
                round.taker = value;
                if (team == BeloteTeamEnum.US) {
                  round.defender = BeloteTeamEnum.THEM;
                } else {
                  round.defender = BeloteTeamEnum.US;
                }
              }),
          Text(team.name, style: Theme.of(context).textTheme.bodyText2)
        ]);
  }
}
