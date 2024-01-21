import 'package:carg/models/score/misc/tarot_contract.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ContractTarotWidget extends StatelessWidget {
  final TarotRound tarotRound;

  const ContractTarotWidget({super.key, required this.tarotRound});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: tarotRound,
      child: Consumer<TarotRound>(
        builder: (context, roundData, _) => Column(
          children: [
            SectionTitleWidget(title: AppLocalizations.of(context)!.contract),
            DropdownButton<TarotContract>(
              value: roundData.contract,
              itemHeight: 70,
              items: TarotContract.values.map((TarotContract value) {
                return DropdownMenuItem<TarotContract>(
                  value: value,
                  child: Text(
                    '${value.name(context)} \n x${value.multiplayer}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (TarotContract? val) {
                roundData.contract = val!;
              },
            ),
          ],
        ),
      ),
    );
  }
}
