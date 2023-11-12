import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/styles/custom_properties.dart';
import 'package:carg/styles/custom_text_style.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TeamStatDialog extends StatelessWidget {
  final Team team;
  final AbstractPlayerService playerService;
  final AbstractTeamService teamService;
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  TeamStatDialog({
    super.key,
    required this.team,
    required this.playerService,
    required this.teamService,
  });

  Future<void> _saveTeam(BuildContext context) async {
    try {
      await teamService.update(team).then((value) => {
            InfoSnackBar.showSnackBar(
              context,
              AppLocalizations.of(context)!.teamNameEdited,
            ),
            Navigator.pop(context),
          });
    } on ServiceException catch (e) {
      InfoSnackBar.showErrorSnackBar(context, e.message);
    }
  }

  String _getHintText(BuildContext context) {
    return team.name != null && team.name != ''
        ? ''
        : AppLocalizations.of(context)!.noName;
  }

  Color _getHintColor(BuildContext context) {
    return team.name != null && team.name != ''
        ? Theme.of(context).cardColor
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    textEditingController.text = team.name ?? '';
    final primaryColor = Theme.of(context).primaryColor;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Container(
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(
              15.0,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Semantics(
                explicitChildNodes: true,
                child: TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  key: const ValueKey('nameTextField'),
                  style: CustomTextStyle.dialogHeaderStyle(context),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: _getHintColor(context)),
                    fillColor: Colors.red,
                    hintText: _getHintText(context),
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (value) {
                    team.name = value;
                    _saveTeam(context);
                  },
                ),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).cardColor,
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        CustomProperties.borderRadius,
                      ),
                    ),
                  ),
                ),
                key: const ValueKey('editNameButton'),
                onPressed: () => {
                  FocusScope.of(context).requestFocus(focusNode),
                },
                child: Icon(Icons.edit, color: primaryColor),
              ),
            ),
          ],
        ),
      ),
      content: Column(
        children: [
          Column(
            children: team.gameStatsList!
                .map(
                  (stat) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              Text(
                                stat.gameType.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.victoryPercentage(
                                  stat.winPercentage().toString(),
                                ),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 120,
                              maxWidth: 120,
                            ),
                            child: _StatGauge(gameStats: stat),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList()
                .cast<Widget>(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(
                      CustomProperties.borderRadius,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 9.0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.playedGames,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(
                      CustomProperties.borderRadius,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 9.0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.wonGames,
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton.icon(
          key: const ValueKey('closeButton'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
              ),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          label: Text(
            MaterialLocalizations.of(context).closeButtonLabel,
          ),
        ),
      ],
      scrollable: true,
    );
  }
}

class _StatGauge extends StatelessWidget {
  final GameStats? gameStats;

  const _StatGauge({this.gameStats});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                axisValue: 50,
                positionFactor: 0.1,
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${gameStats!.wonGames}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Text(
                      ' | ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${gameStats!.playedGames}',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            startAngle: 270,
            endAngle: 270,
            interval: 10,
            showLabels: false,
            showTicks: false,
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: gameStats!.winPercentage(),
                color: primaryColor,
              ),
              GaugeRange(
                startValue: gameStats!.winPercentage(),
                endValue: 100,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ],
        enableLoadingAnimation: false,
      ),
    );
  }
}
