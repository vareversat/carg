import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/score/misc/tarot_chelem.dart';
import 'package:carg/models/score/misc/tarot_handful.dart';
import 'package:carg/models/score/misc/tarot_perk.dart';
import 'package:carg/models/score/misc/tarot_team.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TarotPerkWidget extends StatelessWidget {
  final TarotRound tarotRound;
  final Tarot? tarotGame;

  const TarotPerkWidget({super.key, required this.tarotRound, this.tarotGame});

  @override
  Widget build(BuildContext context) {
    Future<dynamic> showHandfulPicker() {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return _HandfulPicker(
            tarotRound.handful,
            tarotRound.handfulTeam,
            tarotGame!.players!.playerList!.length,
          );
        },
      );
    }

    Future<dynamic> showChelemPicker() {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return _ChelemPicker(tarotRound.chelem);
        },
      );
    }

    Future<TarotTeam?> showSmallToTheEndPicker() {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return _PetitAuBoutPicker(tarotRound.smallToTheEndTeam);
        },
      );
    }

    return ChangeNotifierProvider.value(
      value: tarotRound,
      child: Consumer<TarotRound>(
        builder: (context, roundData, _) => Column(
          children: [
            SectionTitleWidget(title: AppLocalizations.of(context)!.bonus),
            Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: [
                InputChip(
                  onDeleted: roundData.smallToTheEndTeam != null
                      ? () => {roundData.smallToTheEndTeam = null}
                      : null,
                  avatar: roundData.smallToTheEndTeam != null
                      ? CircleAvatar(
                          child: Text(
                            EnumToString.convertToString(
                              roundData.smallToTheEndTeam,
                            ).substring(0, 1),
                          ),
                        )
                      : null,
                  showCheckmark: false,
                  selected: roundData.smallToTheEndTeam != null,
                  onPressed: () async {
                    await showSmallToTheEndPicker().then(
                      (value) => {
                        if (value != null) roundData.smallToTheEndTeam = value,
                      },
                    );
                  },
                  label: Text(
                    TarotBonus.SMALL_TO_THE_END.name(context) +
                        (roundData.smallToTheEndTeam != null
                            ? ' | ${AppLocalizations.of(context)!.points(TarotRound.smallToTheEndBonus.round())}'
                            : ''),
                  ),
                ),
                InputChip(
                  onDeleted: roundData.handful != null
                      ? () => {roundData.handful = null}
                      : null,
                  avatar: roundData.handful != null
                      ? CircleAvatar(
                          child: Text(
                            EnumToString.convertToString(
                              roundData.handfulTeam,
                            ).substring(0, 1),
                          ),
                        )
                      : null,
                  showCheckmark: false,
                  selected: roundData.handful != null,
                  onPressed: () async {
                    await showHandfulPicker().then(
                      (value) => {
                        if (value != null)
                          {
                            roundData.handful = value[0],
                            roundData.handfulTeam = value[1],
                          },
                      },
                    );
                  },
                  label: Text(
                    TarotBonus.HANDFUL.name(context) +
                        (roundData.handful != null
                            ? ' ${roundData.handful.name(context)}'
                            : ''),
                  ),
                ),
                InputChip(
                  onDeleted: roundData.chelem != null
                      ? () => {roundData.chelem = null}
                      : null,
                  avatar: roundData.chelem != null
                      ? CircleAvatar(
                          child: Text(
                            EnumToString.convertToString(
                              roundData.chelem,
                            ).substring(0, 1),
                          ),
                        )
                      : null,
                  showCheckmark: false,
                  selected: roundData.chelem != null,
                  onPressed: () async {
                    await showChelemPicker().then(
                      (value) => {if (value != null) roundData.chelem = value},
                    );
                  },
                  label: Text(
                    TarotBonus.CHELEM.name(context) +
                        (roundData.chelem != null
                            ? ' | ${AppLocalizations.of(context)!.points(roundData.chelem.bonus)}'
                            : ''),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HandfulPicker extends StatelessWidget {
  final TarotHandful? handful;
  final TarotTeam? handfulTeam;
  final int playerCount;

  const _HandfulPicker(this.handful, this.handfulTeam, this.playerCount);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(18),
      titlePadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: <Widget>[
        Wrap(
          spacing: 5,
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: TarotHandful.values
              .map(
                (poingnee) => Column(
                  children: [
                    Text(
                      '${poingnee.name(context)} (${AppLocalizations.of(context)!.trump(poingnee.perkCount)} = ${AppLocalizations.of(context)!.points(poingnee.bonus!)})',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InputChip(
                          selected:
                              handful == poingnee &&
                              handfulTeam == TarotTeam.ATTACK,
                          onPressed: () {
                            Navigator.pop(context, [
                              poingnee,
                              TarotTeam.ATTACK,
                            ]);
                          },
                          label: Text(AppLocalizations.of(context)!.attack),
                        ),
                        InputChip(
                          selected:
                              handful == poingnee &&
                              handfulTeam == TarotTeam.DEFENSE,
                          onPressed: () {
                            Navigator.pop(context, [
                              poingnee,
                              TarotTeam.DEFENSE,
                            ]);
                          },
                          label: Text(AppLocalizations.of(context)!.defense),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .toList()
              .cast<Widget>(),
        ),
      ],
    );
  }
}

class _PetitAuBoutPicker extends StatelessWidget {
  final TarotTeam? selectedTeamForBout;

  const _PetitAuBoutPicker(this.selectedTeamForBout);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(18),
      titlePadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: <Widget>[
        Center(
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 20,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              InputChip(
                selected: selectedTeamForBout == TarotTeam.ATTACK,
                onPressed: () {
                  Navigator.pop(context, TarotTeam.ATTACK);
                },
                label: Text(AppLocalizations.of(context)!.attack),
              ),
              InputChip(
                selected: selectedTeamForBout == TarotTeam.DEFENSE,
                onPressed: () {
                  Navigator.pop(context, TarotTeam.DEFENSE);
                },
                label: Text(AppLocalizations.of(context)!.defense),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChelemPicker extends StatelessWidget {
  final TarotChelem? tarotChelem;

  const _ChelemPicker(this.tarotChelem);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(18),
      titlePadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: <Widget>[
        Wrap(
          spacing: 5,
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: TarotChelem.values
              .map(
                (chelem) => InputChip(
                  selected: tarotChelem == chelem,
                  onPressed: () {
                    Navigator.pop(context, chelem);
                  },
                  label: Text(
                    '${chelem.name(context)} (${AppLocalizations.of(context)!.points(chelem.bonus)})',
                    overflow: TextOverflow.clip,
                  ),
                ),
              )
              .toList()
              .cast<Widget>(),
        ),
      ],
    );
  }
}
