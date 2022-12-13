import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/contree_belote_contract_name.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        builder: (context, roundData, child) => Column(
          children: [
            SectionTitleWidget(title: AppLocalizations.of(context)!.contract),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      _ContractValueTextFieldWidget(
                        contreeBeloteRound: roundData,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _ContractTypeWidget(
                        roundData: roundData,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _ContractNameWidget(
                        roundData: roundData,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CardColorPickerWidget(
                        beloteRound: roundData,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContractValueTextFieldWidget extends StatelessWidget {
  final ContreeBeloteRound contreeBeloteRound;
  final TextEditingController _contractTextController = TextEditingController();

  _ContractValueTextFieldWidget({required this.contreeBeloteRound});

  @override
  Widget build(BuildContext context) {
    _contractTextController.text = contreeBeloteRound.contract.toString();
    return Row(
      key: const ValueKey('contractValueTextFieldWidget'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: TextField(
            key: const ValueKey('contractValueTextFieldValue'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            controller: _contractTextController,
            enabled: !(contreeBeloteRound.contractType ==
                    BeloteContractType.CAPOT ||
                contreeBeloteRound.contractType == BeloteContractType.GENERALE),
            keyboardType: TextInputType.number,
            inputFormatters: const <TextInputFormatter>[],
            onSubmitted: (String value) => {
              contreeBeloteRound.contract = int.parse(value),
            },
          ),
        ),
        AnimatedSize(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 500),
          child: (contreeBeloteRound.contractType == BeloteContractType.CAPOT ||
                  contreeBeloteRound.contractType ==
                      BeloteContractType.GENERALE)
              ? Icon(
                  key: const ValueKey('lockWidget'),
                  FontAwesomeIcons.lock,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                )
              : const SizedBox(
                  key: ValueKey('noLockWidget'),
                ),
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
    return Column(
      key: const ValueKey('contractTypeWidget'),
      children: [
        Text(AppLocalizations.of(context)!.type),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 5,
                children: BeloteContractType.values
                    .map(
                      (contractType) => InputChip(
                        key: ValueKey(
                            'contractTypeWidget-${contractType.name(context)}'),
                        checkmarkColor: Theme.of(context).cardColor,
                        selected: roundData.contractType == contractType,
                        selectedColor: Theme.of(context).primaryColor,
                        onPressed: () =>
                            {roundData.contractType = contractType},
                        label: Text(
                          contractType.name(context),
                          style: TextStyle(
                              fontSize: 20, color: Theme.of(context).cardColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
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
  final ContreeBeloteRound roundData;

  const _ContractNameWidget({required this.roundData});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('contractNameWidget'),
      children: [
        Text(
            '${AppLocalizations.of(context)!.bet} (x${roundData.contractName.multiplier})'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 5,
                children: ContreeBeloteContractName.values
                    .map(
                      (contractName) => InputChip(
                        key:
                            ValueKey('contractNameWidget-${contractName.name}'),
                        checkmarkColor: Theme.of(context).cardColor,
                        selected: roundData.contractName == contractName,
                        selectedColor: Theme.of(context).primaryColor,
                        onPressed: () =>
                            {roundData.contractName = contractName},
                        label: Text(
                          contractName.name,
                          style: TextStyle(
                              fontSize: 20, color: Theme.of(context).cardColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
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
