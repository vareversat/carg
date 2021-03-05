import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/score/misc/tarot_chelem.dart';
import 'package:carg/models/score/misc/tarot_handful.dart';
import 'package:carg/models/score/misc/tarot_perk.dart';
import 'package:carg/models/score/misc/tarot_team.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TarotPerkWidget extends StatelessWidget {
  final TarotRound round;
  final Tarot tarotGame;

  const TarotPerkWidget({this.round, this.tarotGame});

  @override
  Widget build(BuildContext context) {
    Future<dynamic> _showHandfulPicker() {
      return showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return _HandfulPicker(round.handful, round.handfulTeam,
              tarotGame.players.playerList.length);
        },
      );
    }

    Future<dynamic> _showChelemPicker() {
      return showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return _ChelemPicker(round.chelem);
        },
      );
    }

    Future<TarotTeam> _showSmallToTheEndPicker() {
      return showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return _PetitAuBoutPicker(round.smallToTheEndTeam);
        },
      );
    }

    return Column(
      children: [
        SectionTitleWidget(title: 'Bonus'),
        Wrap(spacing: 10, alignment: WrapAlignment.center, children: [
          InputChip(
            onDeleted: round.smallToTheEndTeam != null
                ? () => {round.smallToTheEndTeam = null}
                : null,
            avatar: round.smallToTheEndTeam != null
                ? CircleAvatar(
                    child: Text(
                        EnumToString.convertToString(round.smallToTheEndTeam)
                            ?.substring(0, 1)))
                : null,
            showCheckmark: false,
            selectedColor: Theme.of(context).accentColor,
            selected: round.smallToTheEndTeam != null,
            onPressed: () async {
              await _showSmallToTheEndPicker().then((value) =>
                  {if (value != null) round.smallToTheEndTeam = value});
            },
            label: Text('${TarotBonus.SMALL_TO_THE_END.name}' +
                (round.smallToTheEndTeam != null
                    ? ' |  ${TarotRound.smallToTheEndBonus.round()} pts'
                    : '')),
          ),
          InputChip(
            onDeleted:
                round.handful != null ? () => {round.handful = null} : null,
            avatar: round.handful != null
                ? CircleAvatar(
                    child: Text(EnumToString.convertToString(round.handfulTeam)
                        ?.substring(0, 1)))
                : null,
            showCheckmark: false,
            selectedColor: Theme.of(context).accentColor,
            selected: round.handful != null,
            onPressed: () async {
              await _showHandfulPicker().then((value) => {
                    if (value != null)
                      {round.handful = value[0], round.handfulTeam = value[1]}
                  });
            },
            label: Text('${TarotBonus.HANDFUL.name}' +
                (round.handful != null ? ' ${round.handful.name}' : '')),
          ),
          InputChip(
            onDeleted:
                round.chelem != null ? () => {round.chelem = null} : null,
            avatar: round.chelem != null
                ? CircleAvatar(
                    child: Text(EnumToString.convertToString(round.chelem)
                        ?.substring(0, 1)))
                : null,
            showCheckmark: false,
            selectedColor: Theme.of(context).accentColor,
            selected: round.chelem != null,
            onPressed: () async {
              await _showChelemPicker()
                  .then((value) => {if (value != null) round.chelem = value});
            },
            label: Text('${TarotBonus.CHELEM.name}' +
                (round.chelem != null ? ' |  ${round.chelem.bonus} pts' : '')),
          ),
        ])
      ],
    );
  }
}

class _HandfulPicker extends StatelessWidget {
  final TarotHandful handful;
  final TarotTeam handfulTeam;
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
                          '${poingnee.name} (${poingnee.perkCount} atouts = ${poingnee.bonus} points)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InputChip(
                              selectedColor: Theme.of(context).primaryColor,
                              checkmarkColor: (handful == poingnee &&
                                      handfulTeam == TarotTeam.ATTACK)
                                  ? Colors.white
                                  : Colors.black,
                              selected: handful == poingnee &&
                                  handfulTeam == TarotTeam.ATTACK,
                              onPressed: () {
                                Navigator.pop(
                                    context, [poingnee, TarotTeam.ATTACK]);
                              },
                              label: Text(
                                'Attaque',
                                style: TextStyle(
                                    color: (handful == poingnee &&
                                            handfulTeam == TarotTeam.ATTACK)
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            InputChip(
                                selectedColor: Theme.of(context).primaryColor,
                                checkmarkColor: (handful == poingnee &&
                                        handfulTeam == TarotTeam.DEFENSE)
                                    ? Colors.white
                                    : Colors.black,
                                selected: handful == poingnee &&
                                    handfulTeam == TarotTeam.DEFENSE,
                                onPressed: () {
                                  Navigator.pop(
                                      context, [poingnee, TarotTeam.DEFENSE]);
                                },
                                label: Text(
                                  'Défense',
                                  style: TextStyle(
                                      color: (handful == poingnee &&
                                              handfulTeam == TarotTeam.DEFENSE)
                                          ? Colors.white
                                          : Colors.black),
                                ))
                          ])
                    ],
                  ),
                )
                .toList()
                .cast<Widget>(),
          ),
        ]);
  }
}

class _PetitAuBoutPicker extends StatelessWidget {
  final TarotTeam selectedTeamForBout;

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
                  selectedColor: Theme.of(context).primaryColor,
                  checkmarkColor: selectedTeamForBout == TarotTeam.ATTACK
                      ? Colors.white
                      : Colors.black,
                  selected: selectedTeamForBout == TarotTeam.ATTACK,
                  onPressed: () {
                    Navigator.pop(context, TarotTeam.ATTACK);
                  },
                  label: Text(
                    'Attaque',
                    style: TextStyle(
                        color: selectedTeamForBout == TarotTeam.ATTACK
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                InputChip(
                  selectedColor: Theme.of(context).primaryColor,
                  checkmarkColor: selectedTeamForBout == TarotTeam.DEFENSE
                      ? Colors.white
                      : Colors.black,
                  selected: selectedTeamForBout == TarotTeam.DEFENSE,
                  onPressed: () {
                    Navigator.pop(context, TarotTeam.DEFENSE);
                  },
                  label: Text(
                    'Défense',
                    style: TextStyle(
                        color: selectedTeamForBout == TarotTeam.DEFENSE
                            ? Colors.white
                            : Colors.black),
                  ),
                )
              ],
            ),
          ),
        ]);
  }
}

class _ChelemPicker extends StatelessWidget {
  final TarotChelem tarotChelem;

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
                    selectedColor: Theme.of(context).primaryColor,
                    checkmarkColor:
                        tarotChelem == chelem ? Colors.white : Colors.black,
                    selected: tarotChelem == chelem,
                    onPressed: () {
                      Navigator.pop(context, chelem);
                    },
                    label: Text(
                      '${chelem.name} (${chelem.bonus.toString()} pts)',
                      style: TextStyle(
                          color: tarotChelem == chelem
                              ? Colors.white
                              : Colors.black),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                )
                .toList()
                .cast<Widget>(),
          ),
        ]);
  }
}
