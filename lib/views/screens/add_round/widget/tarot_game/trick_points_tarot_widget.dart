import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';

class TrickPointsTarotWidget extends StatelessWidget {
  final TarotRound round;

  const TrickPointsTarotWidget({this.round});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitleWidget(title: 'Points des plis'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    round.attackTrickPoints--;
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: CircleBorder(),
                  child: Icon(Icons.chevron_left_outlined)),
            ),
            Flexible(
              flex: 5,
              child: Slider(
                value: round.attackTrickPoints,
                min: 0,
                max: TarotRound.maxTrickPoints,
                divisions: TarotRound.maxTrickPoints.toInt(),
                label:
                    'Attaque : ${round.attackTrickPoints.round().toString()} \nDéfense : ${(round.defenseTrickPoints.round()).toString()}',
                onChanged: (double value) {
                  round.attackTrickPoints = value.roundToDouble();
                },
              ),
            ),
            Flexible(
              child: MaterialButton(
                  onPressed: () {
                    round.attackTrickPoints++;
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.zero,
                  shape: CircleBorder(),
                  child: Icon(Icons.chevron_right_outlined)),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text('Attaque : ${round.attackTrickPoints.round().toString()} '
            '| Défense : ${round.defenseTrickPoints.round().toString()}')
      ],
    );
  }
}
