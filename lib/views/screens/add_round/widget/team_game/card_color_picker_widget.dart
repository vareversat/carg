import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:flutter/material.dart';

class CardColorPickerWidget extends StatelessWidget {
  final BeloteRound teamGameRound;

  const CardColorPickerWidget({@required this.teamGameRound});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<CardColor>(
        value: teamGameRound.cardColor,
        items: CardColor.values.map((CardColor value) {
          return DropdownMenuItem<CardColor>(
              value: value, child: Text(value.name + ' ' + value.symbol));
        }).toList(),
        onChanged: (CardColor val) => {teamGameRound.cardColor = val});
  }
}
