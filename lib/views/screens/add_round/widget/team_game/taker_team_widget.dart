import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/team_game_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';

class TakerTeamWidget extends StatelessWidget {
  final TeamGameRound round;

  const TakerTeamWidget({this.round});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SectionTitleWidget(title: 'Équipe preneuse'),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _RadioButtonRow(team: TeamGameEnum.US, round: round),
            _RadioButtonRow(team: TeamGameEnum.THEM, round: round)
          ])
        ]);
  }
}

class _RadioButtonRow extends StatelessWidget {
  final TeamGameEnum team;
  final TeamGameRound round;

  const _RadioButtonRow({this.team, this.round});

  @override
  Widget build(BuildContext context) {
    return Wrap(
        textDirection:
            team == TeamGameEnum.US ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Radio(
              visualDensity: VisualDensity.compact,
              value: team,
              groupValue: round.taker,
              onChanged: (TeamGameEnum value) {
                round.taker = value;
                if (team == TeamGameEnum.US) {
                  round.defender = TeamGameEnum.THEM;
                } else {
                  round.defender = TeamGameEnum.US;
                }
              }),
          Text(team.name, style: Theme.of(context).textTheme.bodyText2)
        ]);
  }
}
