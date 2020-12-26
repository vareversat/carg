import 'package:carg/models/game/tarot_game.dart';
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
  final TarotGame tarotGame;

  const TarotPerkWidget({this.round, this.tarotGame});

  @override
  Widget build(BuildContext context) {
    Future<dynamic> _showHandfulPicker() {
      return showDialog(
        context: context,
        builder: (
          BuildContext context,
        ) {
          return _HandfulPicker(round.handful, tarotGame.playerIds.length);
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
              await _showSmallToTheEndPicker()
                  .then((value) => round.smallToTheEndTeam = value);
            },
            label: Text('${TarotBonus.SMALL_TO_THE_END.name}' +
                (round.smallToTheEndTeam != null
                    ? ' |  ${TarotRound.smallToTheEndBonus.round()} points'
                    : '')),
          ),
          InputChip(
            onDeleted:
                round.handful != null ? () => {round.handful = null} : null,
            avatar: round.handful != null
                ? CircleAvatar(
                    child: Text(EnumToString.convertToString(round.handful)
                        ?.substring(0, 1)))
                : null,
            showCheckmark: false,
            selectedColor: Theme.of(context).accentColor,
            selected: round.handful != null,
            onPressed: () async {
              await _showHandfulPicker().then((value) => round.handful = value);
            },
            label: Text('${TarotBonus.HANDFUL.name}' +
                (round.handful != null
                    ? ' |  ${round.handful.bonus} points'
                    : '')),
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
              await _showChelemPicker().then((value) => round.chelem = value);
            },
            label: Text('${TarotBonus.CHELEM.name}' +
                (round.chelem != null
                    ? ' |  ${round.chelem.bonus} points'
                    : '')),
          ),
        ])
      ],
    );
  }
}

class _HandfulPicker extends StatelessWidget {
  final TarotHandful handful;
  final int playerCount;

  const _HandfulPicker(this.handful, this.playerCount);

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
                  (poingnee) => InputChip(
                    selectedColor: Theme.of(context).primaryColor,
                    checkmarkColor:
                        handful == poingnee ? Colors.white : Colors.black,
                    selected: handful == poingnee,
                    onPressed: () {
                      Navigator.pop(context, poingnee);
                    },
                    label: Text(
                      '${poingnee.name} (${poingnee.perkCount(playerCount)} atouts | ${poingnee.bonus} points)',
                      style: TextStyle(
                          color: handful == poingnee
                              ? Colors.white
                              : Colors.black),
                    ),
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
                      '${chelem.name} (${chelem.bonus.toString()} points)',
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
