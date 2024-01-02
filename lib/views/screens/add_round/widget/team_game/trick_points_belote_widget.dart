import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TrickPointsBeloteWidget extends StatefulWidget {
  final BeloteRound round;

  const TrickPointsBeloteWidget({super.key, required this.round});

  @override
  State<StatefulWidget> createState() {
    return _TrickPointsBeloteWidgetState();
  }
}

class _TrickPointsBeloteWidgetState extends State<TrickPointsBeloteWidget> {
  final TextEditingController _usPointsTextController = TextEditingController();
  final TextEditingController _themPointsTextController =
      TextEditingController();

  @override
  void initState() {
    _usPointsTextController.text = widget.round.usTrickScore.toString();
    _themPointsTextController.text = widget.round.themTrickScore.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.round,
      child: Consumer<BeloteRound>(
        builder: (context, roundData, child) => Column(
          children: [
            SectionTitleWidget(
                title: AppLocalizations.of(context)!.trickPoints),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                            '${AppLocalizations.of(context)!.us} : ${roundData.usTrickScore.round().toString()} | '
                            '${(roundData.themTrickScore.round()).toString()} : ${AppLocalizations.of(context)!.them}',
                            key: const ValueKey('trickPointsBeloteRealTime'))
                      ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Flexible(
                      child: MaterialButton(
                          key: const ValueKey('trickPointsBeloteLeftButton'),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            roundData.usTrickScore > 0
                                ? roundData.usTrickScore--
                                : null;
                            roundData.themTrickScore <
                                    BeloteRound.totalTrickScore
                                ? roundData.themTrickScore++
                                : null;
                          },
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          shape: const CircleBorder(),
                          child: const Icon(Icons.chevron_left_outlined)),
                    ),
                    Flexible(
                      flex: 5,
                      child: Slider(
                        inactiveColor: Theme.of(context).colorScheme.secondary,
                        value: roundData.usTrickScore.toDouble(),
                        min: 0,
                        max: BeloteRound.totalTrickScore.toDouble(),
                        divisions: BeloteRound.totalTrickScore,
                        onChanged: (double value) {
                          roundData.usTrickScore = value.toInt();
                          roundData.themTrickScore =
                              BeloteRound.totalTrickScore - value.toInt();
                        },
                      ),
                    ),
                    Flexible(
                      child: MaterialButton(
                        key: const ValueKey('trickPointsBeloteRightButton'),
                        onPressed: () {
                          roundData.usTrickScore < BeloteRound.totalTrickScore
                              ? roundData.usTrickScore++
                              : null;
                          roundData.themTrickScore > 0
                              ? roundData.themTrickScore--
                              : null;
                        },
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.chevron_right_outlined,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  _BeloteRebeloteWidget(round: roundData),
                  _DixDeDerWidget(round: roundData)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BeloteRebeloteWidget extends StatelessWidget {
  final BeloteRound? round;

  const _BeloteRebeloteWidget({this.round});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InputChip(
          key: const ValueKey('beloteRebeloteWidgetUs'),
          checkmarkColor: Theme.of(context).cardColor,
          selected: round?.beloteRebelote == BeloteTeamEnum.US,
          selectedColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(
            color: round?.beloteRebelote == BeloteTeamEnum.US
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => {
            if (round?.beloteRebelote != BeloteTeamEnum.US)
              round?.beloteRebelote = BeloteTeamEnum.US
            else
              round?.beloteRebelote = null
          },
          label: Text(
            BeloteTeamEnum.US.name(context),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(AppLocalizations.of(context)!.beloteRebelote),
        InputChip(
          key: const ValueKey('beloteRebeloteWidgetThem'),
          checkmarkColor: Theme.of(context).cardColor,
          selected: round?.beloteRebelote == BeloteTeamEnum.THEM,
          selectedColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(
            color: round?.beloteRebelote == BeloteTeamEnum.THEM
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => {
            if (round?.beloteRebelote != BeloteTeamEnum.THEM)
              round?.beloteRebelote = BeloteTeamEnum.THEM
            else
              round?.beloteRebelote = null
          },
          label: Text(
            BeloteTeamEnum.THEM.name(context),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DixDeDerWidget extends StatelessWidget {
  final BeloteRound? round;

  const _DixDeDerWidget({this.round});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InputChip(
          key: const ValueKey('dixDeDerWidgetUs'),
          checkmarkColor: Theme.of(context).cardColor,
          selected: round?.dixDeDer == BeloteTeamEnum.US,
          selectedColor: Theme.of(context).primaryColor,
          onPressed: () => {round?.dixDeDer = BeloteTeamEnum.US},
          labelStyle: TextStyle(
            color: round?.dixDeDer == BeloteTeamEnum.US
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onBackground,
          ),
          label: Text(
            BeloteTeamEnum.US.name(context),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(AppLocalizations.of(context)!.dixDeDer),
        InputChip(
          key: const ValueKey('dixDeDerWidgetThem'),
          checkmarkColor: Theme.of(context).cardColor,
          selected: round?.dixDeDer == BeloteTeamEnum.THEM,
          selectedColor: Theme.of(context).primaryColor,
          onPressed: () => {round?.dixDeDer = BeloteTeamEnum.THEM},
          labelStyle: TextStyle(
            color: round?.dixDeDer == BeloteTeamEnum.THEM
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onBackground,
          ),
          label: Text(
            BeloteTeamEnum.THEM.name(context),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
