import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/coinche_belote_contract_name.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ContractCoincheWidget extends StatelessWidget {
  final CoincheBeloteRound? coincheRound;

  ContractCoincheWidget({this.coincheRound});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: coincheRound,
      child: Consumer<CoincheBeloteRound>(
          builder: (context, roundData, child) => Column(children: [
                SectionTitleWidget(title: 'Contrat'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(children: <Widget>[
                    SizedBox(height: 15),
                    Column(children: [
                      _ContractValueTextFieldWidget(coincheRound: roundData),
                      _ContractTypeWidget(roundData: roundData),
                      _ContractNameWidget(roundData: roundData),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Couleur :'),
                            CardColorPickerWidget(teamGameRound: coincheRound)
                          ])
                    ])
                  ]),
                )
              ])),
    );
  }
}

class _ContractValueTextFieldWidget extends StatelessWidget {
  final CoincheBeloteRound coincheRound;
  final TextEditingController _contractTextController = TextEditingController();

  _ContractValueTextFieldWidget({required this.coincheRound});

  @override
  Widget build(BuildContext context) {
    _contractTextController.text = coincheRound.contract.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Valeur :'),
        SizedBox(
          width: 100,
          child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Theme.of(context).colorScheme.primary),
                    borderRadius:
                        BorderRadius.circular(CustomProperties.borderRadius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 4,
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(CustomProperties.borderRadius),
                  )),
              controller: _contractTextController,
              enabled:
                  !(coincheRound.contractType == BeloteContractType.CAPOT ||
                      coincheRound.contractType == BeloteContractType.GENERALE),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[],
              onSubmitted: (String value) =>
                  {coincheRound.contract = int.parse(value)}),
        ),
      ],
    );
  }
}

class _ContractTypeWidget extends StatelessWidget {
  final CoincheBeloteRound roundData;

  const _ContractTypeWidget({required this.roundData});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Type :'),
      DropdownButton<BeloteContractType>(
          value: roundData.contractType,
          items: BeloteContractType.values.map((BeloteContractType value) {
            return DropdownMenuItem<BeloteContractType>(
                value: value, child: Text(value.name));
          }).toList(),
          onChanged: (BeloteContractType? val) {
            roundData.contractType = val!;
          })
    ]);
  }
}

class _ContractNameWidget extends StatelessWidget {
  final CoincheBeloteRound roundData;

  const _ContractNameWidget({required this.roundData});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Mise :'),
      DropdownButton<CoincheBeloteContractName>(
          value: roundData.contractName,
          items: CoincheBeloteContractName.values
              .map((CoincheBeloteContractName value) {
            return DropdownMenuItem<CoincheBeloteContractName>(
                value: value, child: Text(value.name));
          }).toList(),
          onChanged: (CoincheBeloteContractName? val) {
            roundData.contractName = val!;
          })
    ]);
  }
}
