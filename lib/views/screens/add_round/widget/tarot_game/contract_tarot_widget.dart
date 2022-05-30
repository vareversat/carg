import 'package:carg/models/score/misc/tarot_contract.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContractTarotWidget extends StatelessWidget {
  final TarotRound tarotRound;

  const ContractTarotWidget({Key? key, required this.tarotRound})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: tarotRound..computeRound(),
      child: Consumer<TarotRound>(
          builder: (context, roundData, _) => Column(
                children: [
                  const SectionTitleWidget(title: 'Contrat'),
                  DropdownButton<TarotContract>(
                      value: roundData.contract,
                      items: TarotContract.values.map((TarotContract value) {
                        return DropdownMenuItem<TarotContract>(
                          value: value,
                          child: Text('${value.name} (x${value.multiplayer})'),
                        );
                      }).toList(),
                      onChanged: (TarotContract? val) {
                        roundData.contract = val!;
                      }),
                ],
              )),
    );
  }
}
