import 'package:carg/models/score/misc/tarot_oudler.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';

class OudlerPickerWidget extends StatelessWidget {
  final TarotRound round;

  const OudlerPickerWidget({this.round});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitleWidget(title: 'Nombre de bout(s)'),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: TarotOudler.values
                .map((tarotBoutCount) => InputChip(
                    selectedColor: Theme.of(context).accentColor,
                    selected: round.oudler == tarotBoutCount,
                    onPressed: () {
                      round.oudler = tarotBoutCount;
                      round.attackTrickPoints = tarotBoutCount.pointToDo;
                    },
                    label: Text(tarotBoutCount.name +
                        (round.oudler == tarotBoutCount
                            ? ' (' +
                                round.oudler.pointToDo.round().toString() +
                                ')'
                            : ''))))
                .toList()
                .cast<Widget>())
      ],
    );
  }
}
