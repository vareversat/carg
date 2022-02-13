import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/contree_belote_contract_name.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ContractContreeWidget extends StatelessWidget {
  final ContreeBeloteRound contreeRound;

  const ContractContreeWidget({Key? key, required this.contreeRound})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: contreeRound,
      child: Consumer<ContreeBeloteRound>(
          builder: (context, roundData, child) => Column(children: [
            const SectionTitleWidget(title: 'Contrat'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(children: <Widget>[
                const SizedBox(height: 15),
                Column(children: [
                  _ContractValueTextFieldWidget(contreeRound: roundData),
                  _ContractTypeWidget(roundData: roundData),
                  _ContractNameWidget(roundData: roundData),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Couleur :'),
                        CardColorPickerWidget(teamGameRound: contreeRound)
                      ])
                    ])
                  ]),
                )
              ])),
    );
  }
}

class _ContractValueTextFieldWidget extends StatelessWidget {
  final ContreeBeloteRound contreeRound;
  final TextEditingController _contractTextController = TextEditingController();

  _ContractValueTextFieldWidget({required this.contreeRound});

  @override
  Widget build(BuildContext context) {
    _contractTextController.text = contreeRound.contract.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Valeur :'),
        SizedBox(
          width: 100,
          child: TextField(
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3, color: Theme
                        .of(context)
                        .colorScheme
                        .primary),
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
                    borderSide: const BorderSide(width: 3, color: Colors.grey),
                    borderRadius:
                    BorderRadius.circular(CustomProperties.borderRadius),
                  )),
              controller: _contractTextController,
              enabled:
              !(contreeRound.contractType == BeloteContractType.CAPOT ||
                  contreeRound.contractType == BeloteContractType.GENERALE),
              keyboardType: TextInputType.number,
              inputFormatters: const <TextInputFormatter>[],
              onSubmitted: (String value) =>
              {contreeRound.contract = int.parse(value)}),
        ),
      ],
    );
  }
}

class _ContractTypeWidget extends StatelessWidget {
  final ContreeBeloteRound roundData;

  const _ContractTypeWidget({required this.roundData});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Type :'),
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
  final ContreeBeloteRound roundData;

  const _ContractNameWidget({required this.roundData});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Mise :'),
      DropdownButton<ContreeBeloteContractName>(
          value: roundData.contractName,
          items: ContreeBeloteContractName.values
              .map((ContreeBeloteContractName value) {
            return DropdownMenuItem<ContreeBeloteContractName>(
                value: value, child: Text(value.name));
          }).toList(),
          onChanged: (ContreeBeloteContractName? val) {
            roundData.contractName = val!;
          })
    ]);
  }
}
