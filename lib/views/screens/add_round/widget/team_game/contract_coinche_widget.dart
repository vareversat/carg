import 'package:carg/models/score/misc/contract_name.dart';
import 'package:carg/models/score/round/coinche_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContractCoincheWidget extends StatelessWidget {
  final CoincheRound coincheRound;

  ContractCoincheWidget({this.coincheRound});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SectionTitleWidget(title: 'Contrat'),
      Column(children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: _ContractTextFieldWidget(coincheRound: coincheRound)),
        SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          DropdownButton<ContractName>(
            value: coincheRound.contractName,
            items: ContractName.values.map((ContractName value) {
              return DropdownMenuItem<ContractName>(
                  value: value, child: Text(value.name));
            }).toList(),
            onChanged: (ContractName val) {
              coincheRound.contractName = val;
            },
          ),
          CardColorPickerWidget(teamGameRound: coincheRound)
        ])
      ])
    ]);
  }
}

class _ContractTextFieldWidget extends StatefulWidget {
  final CoincheRound coincheRound;

  const _ContractTextFieldWidget({this.coincheRound});

  @override
  State<StatefulWidget> createState() {
    return _ContractTextFieldWidgetState(coincheRound);
  }
}

class _ContractTextFieldWidgetState extends State<_ContractTextFieldWidget> {
  final CoincheRound _coincheRound;
  TextEditingController _contractTextController;

  _ContractTextFieldWidgetState(this._coincheRound);

  @override
  void initState() {
    _contractTextController = TextEditingController();
    _contractTextController.text = _coincheRound.contract.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: _contractTextController,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[],
        decoration: InputDecoration(
            hintStyle:
                TextStyle(fontSize: 20, color: Theme.of(context).hintColor),
            labelText: 'Valeur'),
        onSubmitted: (String value) =>
            {_coincheRound.contract = int.parse(value)});
  }
}
