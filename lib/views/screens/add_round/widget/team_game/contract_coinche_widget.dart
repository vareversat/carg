import 'package:carg/models/score/misc/coinche_belote_contract_name.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ContractCoincheWidget extends StatelessWidget {
  final CoincheBeloteRound coincheRound;

  ContractCoincheWidget({required this.coincheRound});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: coincheRound,
      child: Consumer<CoincheBeloteRound>(
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
                        DropdownButton<CoincheBeloteContractName>(
                          value: roundData.contractName,
                          items: CoincheBeloteContractName.values
                              .map((CoincheBeloteContractName value) {
                            return DropdownMenuItem<CoincheBeloteContractName>(
                                value: value, child: Text(value.name));
                          }).toList(),
                          onChanged: (CoincheBeloteContractName? val) {
                            roundData.contractName = val!;
                            if (roundData.contractName ==
                                    CoincheBeloteContractName.CAPOT ||
                                roundData.contractName ==
                                    CoincheBeloteContractName.GENERALE) {
                              roundData.contract = BeloteRound.totalTrickScore +
                                  BeloteRound.dixDeDerBonus;
                            }
                          },
                        ),
                        CardColorPickerWidget(teamGameRound: coincheRound)
                      ])
                ])
              ])),
    );
  }
}

class _ContractTextFieldWidget extends StatefulWidget {
  final CoincheBeloteRound? coincheRound;

  const _ContractTextFieldWidget({this.coincheRound});

  @override
  State<StatefulWidget> createState() {
    return _ContractTextFieldWidgetState(coincheRound);
  }
}

class _ContractTextFieldWidgetState extends State<_ContractTextFieldWidget> {
  final CoincheBeloteRound? _coincheRound;
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
                CoincheBeloteContractName.CAPOT ||
            _coincheRound!.contractName == CoincheBeloteContractName.GENERALE),
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
