import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/coinche_belote_contract_name.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ContractCoincheWidget extends StatelessWidget {
  final CoincheBeloteRound? coincheRound;

  const ContractCoincheWidget({Key? key, this.coincheRound}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: coincheRound,
      child: Consumer<CoincheBeloteRound>(
          builder: (context, roundData, child) => Column(children: [
                const SectionTitleWidget(title: 'Contrat'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(children: <Widget>[
                    const SizedBox(height: 15),
                    Column(children: [
                      _ContractValueTextFieldWidget(coincheRound: roundData),
                      const SizedBox(height: 15),
                      _ContractTypeWidget(roundData: roundData),
                      const SizedBox(height: 15),
                      _ContractNameWidget(roundData: roundData),
                      const SizedBox(height: 15),
                      CardColorPickerWidget(beloteRound: coincheRound)
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
        mainAxisAlignment: MainAxisAlignment.center,
        key: const ValueKey('contractValueTextFieldWidget'),
        children: [
          SizedBox(
            width: 100,
            child: TextField(
                key: const ValueKey('contractValueTextFieldValue'),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                controller: _contractTextController,
                enabled: !(coincheRound.contractType ==
                        BeloteContractType.CAPOT ||
                    coincheRound.contractType == BeloteContractType.GENERALE),
                keyboardType: TextInputType.number,
                inputFormatters: const <TextInputFormatter>[],
                onSubmitted: (String value) =>
                    {coincheRound.contract = int.parse(value)}),
          ),
          AnimatedSize(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 500),
            child: (coincheRound.contractType == BeloteContractType.CAPOT ||
                    coincheRound.contractType == BeloteContractType.GENERALE)
                ? Icon(
                    key: const ValueKey('lockWidget'),
                    FontAwesomeIcons.lock,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  )
                : const SizedBox(key: ValueKey('noLockWidget')),
          )
        ]);
  }
}

class _ContractTypeWidget extends StatelessWidget {
  final CoincheBeloteRound roundData;

  const _ContractTypeWidget({required this.roundData});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('contractTypeWidget'),
      children: [
        const Text("Type"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 5,
                children: BeloteContractType.values
                    .map((contractType) => InputChip(
                        key:
                            ValueKey('contractTypeWidget-${contractType.name}'),
                        checkmarkColor: Theme.of(context).cardColor,
                        selected: roundData.contractType == contractType,
                        selectedColor: Theme.of(context).primaryColor,
                        onPressed: () =>
                            {roundData.contractType = contractType},
                        label: Text(contractType.name,
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).cardColor),
                            overflow: TextOverflow.ellipsis)))
                    .toList()
                    .cast<Widget>(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ContractNameWidget extends StatelessWidget {
  final CoincheBeloteRound roundData;

  const _ContractNameWidget({required this.roundData});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('contractNameWidget'),
      children: [
        Text("Mise (x${roundData.contractName.multiplier})"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 5,
                children: CoincheBeloteContractName.values
                    .map((contractName) => InputChip(
                        key:
                            ValueKey('contractNameWidget-${contractName.name}'),
                        checkmarkColor: Theme.of(context).cardColor,
                        selected: roundData.contractName == contractName,
                        selectedColor: Theme.of(context).primaryColor,
                        onPressed: () =>
                            {roundData.contractName = contractName},
                        label: Text(contractName.name,
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).cardColor),
                            overflow: TextOverflow.ellipsis)))
                    .toList()
                    .cast<Widget>(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
