import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';

class ContractBeloteWidget extends StatelessWidget {
  final BeloteRound beloteRound;

  const ContractBeloteWidget({this.beloteRound});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SectionTitleWidget(title: 'Contrat'),
      CardColorPickerWidget(teamGameRound: beloteRound)
    ]);
  }
}
