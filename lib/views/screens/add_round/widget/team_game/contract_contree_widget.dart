import 'package:carg/models/score/misc/contree_belote_contract_name.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ContractContreeWidget extends StatelessWidget {
  final ContreeBeloteRound contreeRound;

  ContractContreeWidget({required this.contreeRound});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: contreeRound,
      child: Consumer<ContreeBeloteRound>(
          builder: (context, roundData, child) => Column(children: [
                SectionTitleWidget(title: 'Contrat'),
                Column(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: _ContractTextFieldWidget(coincheRound: roundData)),
                  SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DropdownButton<ContreeBeloteContractName>(
                          value: roundData.contractName,
                          items: ContreeBeloteContractName.values
                              .map((ContreeBeloteContractName value) {
                            return DropdownMenuItem<ContreeBeloteContractName>(
                                value: value, child: Text(value.name));
                          }).toList(),
                          onChanged: (ContreeBeloteContractName? val) {
                            roundData.contractName = val!;
                            if (roundData.contractName ==
                                    ContreeBeloteContractName.CAPOT ||
                                roundData.contractName ==
                                    ContreeBeloteContractName.GENERALE) {
                              roundData.contract = BeloteRound.totalTrickScore +
                                  BeloteRound.dixDeDerBonus;
                            }
                          },
                        ),
                        CardColorPickerWidget(teamGameRound: contreeRound)
                      ])
                ])
              ])),
    );
  }
}

class _ContractTextFieldWidget extends StatefulWidget {
  final ContreeBeloteRound? coincheRound;

  const _ContractTextFieldWidget({this.coincheRound});

  @override
  State<StatefulWidget> createState() {
    return _ContractTextFieldWidgetState(coincheRound);
  }
}

class _ContractTextFieldWidgetState extends State<_ContractTextFieldWidget> {
  final ContreeBeloteRound? _coincheRound;
  TextEditingController? _contractTextController;

  _ContractTextFieldWidgetState(this._coincheRound);

  @override
  void initState() {
    _contractTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _contractTextController!.text = _coincheRound!.contract.toString();
    return TextField(
        controller: _contractTextController,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        enabled: !(_coincheRound!.contractName ==
                ContreeBeloteContractName.CAPOT ||
            _coincheRound!.contractName == ContreeBeloteContractName.GENERALE),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[],
        decoration: InputDecoration(
            hintStyle:
                TextStyle(fontSize: 20, color: Theme.of(context).hintColor),
            labelText: 'Valeur'),
        onSubmitted: (String value) =>
            {_coincheRound!.contract = int.parse(value)});
  }
}
