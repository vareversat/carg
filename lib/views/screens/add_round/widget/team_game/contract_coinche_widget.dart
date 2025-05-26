import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/coinche_belote_contract_name.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ContractCoincheWidget extends StatelessWidget {
  final CoincheBeloteRound? coincheRound;

  const ContractCoincheWidget({super.key, this.coincheRound});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: coincheRound,
      child: Consumer<CoincheBeloteRound>(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: _ContractValueTextFieldWidget(
                              coincheRound: roundData,
                            ),
                          ),
                          Flexible(
                            child: _ContractTypeWidget(roundData: roundData),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _ContractNameWidget(roundData: roundData),
                      const SizedBox(height: 15),
                      CardColorPickerWidget(beloteRound: coincheRound),
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
  final CoincheBeloteRound coincheRound;
  final TextEditingController _contractTextController = TextEditingController();

  _ContractValueTextFieldWidget({required this.coincheRound});

  @override
  Widget build(BuildContext context) {
    _contractTextController.text = coincheRound.contract.toString();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: const ValueKey('contractValueTextFieldWidget'),
      children: [
        AnimatedSize(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 500),
          child:
              (coincheRound.contractType == BeloteContractType.CAPOT ||
                  coincheRound.contractType == BeloteContractType.GENERALE)
              ? Icon(
                  key: const ValueKey('lockWidget'),
                  FontAwesomeIcons.lock,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                )
              : const SizedBox(key: ValueKey('noLockWidget')),
        ),
        SizedBox(
          width: 100,
          child: TextField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
                borderSide: const BorderSide(),
              ),
            ),
            key: const ValueKey('contractValueTextFieldValue'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            controller: _contractTextController,
            enabled:
                !(coincheRound.contractType == BeloteContractType.CAPOT ||
                    coincheRound.contractType == BeloteContractType.GENERALE),
            keyboardType: TextInputType.number,
            inputFormatters: const <TextInputFormatter>[],
            onSubmitted: (String value) => {
              coincheRound.contract = int.parse(value),
            },
          ),
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
                          'contractTypeWidget-${contractType.name(context)}',
                        ),
                        checkmarkColor: Theme.of(context).cardColor,
                        selected: roundData.contractType == contractType,
                        selectedColor: Theme.of(context).primaryColor,
                        labelStyle: TextStyle(
                          color: roundData.contractType == contractType
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () => {
                          roundData.contractType = contractType,
                        },
                        label: Text(
                          contractType.name(context),
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
  final CoincheBeloteRound roundData;

  const _ContractNameWidget({required this.roundData});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('contractNameWidget'),
      children: [
        Text(
          '${AppLocalizations.of(context)!.bet} (x${roundData.contractName.multiplier})',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 5,
                children: CoincheBeloteContractName.values
                    .map(
                      (contractName) => InputChip(
                        key: ValueKey(
                          'contractNameWidget-${contractName.name}',
                        ),
                        checkmarkColor: Theme.of(context).cardColor,
                        selected: roundData.contractName == contractName,
                        selectedColor: Theme.of(context).primaryColor,
                        labelStyle: TextStyle(
                          color: roundData.contractName == contractName
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () => {
                          roundData.contractName = contractName,
                        },
                        label: Text(
                          contractName.name,
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
