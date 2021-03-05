import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContractBeloteWidget extends StatelessWidget {
  final FrenchBeloteRound frenchBeloteRound;

  const ContractBeloteWidget({required this.frenchBeloteRound});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: frenchBeloteRound,
      child: Consumer<FrenchBeloteRound>(
          builder: (context, roundData, child) =>
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SectionTitleWidget(title: 'Contrat'),
                CardColorPickerWidget(teamGameRound: roundData)
              ])),
    );
  }
}
