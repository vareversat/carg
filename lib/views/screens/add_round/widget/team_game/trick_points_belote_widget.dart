import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TrickPointsBeloteWidget extends StatefulWidget {
  final BeloteRound round;

  TrickPointsBeloteWidget({this.round});

  @override
  State<StatefulWidget> createState() {
    return _TrickPointsBeloteWidgetState(round);
  }
}

class _TrickPointsBeloteWidgetState extends State<TrickPointsBeloteWidget> {
  TextEditingController _usPointsTextController;
  TextEditingController _themPointsTextController;
  final int _totalPoints = 160;
  final int _dixDeDerBonus = 10;
  final BeloteRound _round;

  _TrickPointsBeloteWidgetState(this._round);

  @override
  void initState() {
    _usPointsTextController = TextEditingController();
    _themPointsTextController = TextEditingController();
    _usPointsTextController.text = _round.usTrickScore.toString();
    _themPointsTextController.text = _round.themTrickScore.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SectionTitleWidget(title: 'Points des plis'),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: <Widget>[
            SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Nous', style: CustomTextStyle.boldAndItalic(context)),
                  Text('Eux', style: CustomTextStyle.boldAndItalic(context))
                ]),
            Row(children: <Widget>[
              Flexible(
                  child: TextField(
                      controller: _usPointsTextController,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[],
                      onSubmitted: (String value) => {
                            _round.usTrickScore = int.parse(value),
                            _round.themTrickScore = (_totalPoints -
                                _dixDeDerBonus -
                                int.parse(value)),
                            _themPointsTextController.text = (_totalPoints -
                                    _dixDeDerBonus -
                                    int.parse(value))
                                .toString(),
                          },
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                              fontSize: 20, color: Theme.of(context).hintColor),
                          labelText: 'Points'))),
              SizedBox(width: 20),
              Flexible(
                  child: TextField(
                      controller: _themPointsTextController,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[],
                      onSubmitted: (String value) => {
                            _round.themTrickScore = int.parse(value),
                            _round.usTrickScore = (_totalPoints -
                                _dixDeDerBonus -
                                int.parse(value)),
                            _usPointsTextController.text = (_totalPoints -
                                    _dixDeDerBonus -
                                    int.parse(value))
                                .toString(),
                          },
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                              fontSize: 20, color: Theme.of(context).hintColor),
                          labelText: 'Points')))
            ]),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _BeloteRebeloteDixDeDerWidget(
                  round: _round, team: BeloteTeamEnum.US),
              _BeloteRebeloteDixDeDerWidget(
                  round: _round, team: BeloteTeamEnum.THEM)
            ])
          ]))
    ]);
  }
}

class _BeloteRebeloteDixDeDerWidget extends StatelessWidget {
  final BeloteRound round;
  final BeloteTeamEnum team;

  const _BeloteRebeloteDixDeDerWidget({this.round, this.team});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
          textDirection:
              team == BeloteTeamEnum.US ? TextDirection.ltr : TextDirection.rtl,
          children: <Widget>[
            Text('Belote-Rebelote'),
            Checkbox(
                visualDensity: VisualDensity.compact,
                value: round.beloteRebelote == team,
                onChanged: (bool value) {
                  round.beloteRebelote = team;
                })
          ]),
      Row(
          textDirection:
              team == BeloteTeamEnum.US ? TextDirection.ltr : TextDirection.rtl,
          children: <Widget>[
            Text('Dix de Der'),
            Radio(
                visualDensity: VisualDensity.compact,
                value: team == BeloteTeamEnum.US,
                onChanged: (bool value) {
                  round.dixDeDer = team;
                },
                groupValue: round.dixDeDer == BeloteTeamEnum.US)
          ])
    ]);
  }
}
