import 'package:carg/models/game/tarot_game.dart';
import 'package:carg/models/game/tarot_team.dart';
import 'package:carg/models/player/player.dart';
import 'package:carg/models/player/simple_players.dart';
import 'package:carg/models/score/misc/tarot_bout_count.dart';
import 'package:carg/models/score/misc/tarot_contract.dart';
import 'package:carg/models/score/misc/tarot_perk.dart';
import 'package:carg/models/score/misc/tarot_poignee.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/services/score/tarot_score_service.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AddTarotGameRoundDialog extends StatelessWidget {
  final PlayerService _playerService = PlayerService();
  final TarotGame tarotGame;

  AddTarotGameRoundDialog({this.tarotGame}) {
    print(tarotGame.players);
  }

  Future<SimplePlayers> _getAllPlayer() async {
    var players = <Player>[];
    for (var playerId in tarotGame.playerIds) {
      players.add(await _playerService.getPlayer(playerId));
    }
    return SimplePlayers(players);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            padding: const EdgeInsets.all(20),
            child: Text('Nouvelle manche',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Theme
                        .of(context)
                        .cardColor))),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
                'Preneur' + (tarotGame.playerIds.length == 5 ? 's' : ''),
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<SimplePlayers>(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SpinKitDualRing(
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ));
              }
              return ChangeNotifierProvider.value(
                  value: snapshot.data,
                  child: Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    children: snapshot.data.players
                        .map((player) =>
                        Consumer<SimplePlayers>(
                            builder: (context, simplePlayers, _) =>
                                InputChip(
                                    selected: player.selected,
                                    selectedColor: Theme
                                        .of(context)
                                        .accentColor,
                                    onPressed: () {
                                      simplePlayers.onSelectedPlayer(player);
                                    },
                                    label: Text(
                                      player.userName,
                                      overflow: TextOverflow.ellipsis,
                                    ))))
                        .toList()
                        .cast<Widget>(),
                  ));
            },
            future: _getAllPlayer(),
          ),
        ),
        Divider(),
        _PlayerPicker(tarotGame)
      ]),
    );
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
              direction: Axis.vertical,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                InputChip(
                  selectedColor: Theme
                      .of(context)
                      .primaryColor,
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
                  selectedColor: Theme
                      .of(context)
                      .primaryColor,
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

class _PoigneePicker extends StatelessWidget {
  final TarotPoignee tarotPoignee;
  final int playerCount;

  const _PoigneePicker(this.tarotPoignee, this.playerCount);

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
            children: TarotPoignee.values
                .map(
                  (poingnee) =>
                  InputChip(
                    selectedColor: Theme
                        .of(context)
                        .primaryColor,
                    checkmarkColor:
                    tarotPoignee == poingnee ? Colors.white : Colors.black,
                    selected: tarotPoignee == poingnee,
                    onPressed: () {
                      Navigator.pop(context, poingnee);
                    },
                    label: Text(
                      poingnee.name +
                          ' (' +
                          poingnee.perkCount(playerCount) +
                          ')',
                      style: TextStyle(
                          color: tarotPoignee == poingnee
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

class _PlayerPicker extends StatefulWidget {
  final TarotGame tarotGame;

  const _PlayerPicker(this.tarotGame);

  @override
  State<StatefulWidget> createState() {
    return _PlayerPickerState(tarotGame);
  }
}

class _PlayerPickerState extends State<_PlayerPicker> {
  final TarotScoreService _tarotScoreService = TarotScoreService();
  TarotTeam _selectedTeamForBout;
  TarotPoignee _selectedPoignee;
  TarotGame tarotGame;
  TarotBoutCount _selectedBout = TarotBoutCount.ZERO;
  TarotContract _selectedTarotContract = TarotContract.PETITE;
  int _selectedPoints = 0;
  int _attackPoints = 0;
  int _defensePoints = 0;
  final _maxPoints = 91;
  final _victoryBonus = 25;
  final _petitAuBoutBonus = 10;

  _PlayerPickerState(this.tarotGame);

  int _computePoints() {
    var pointsToDo = _selectedBout.pointToDo;
    var gain = (_selectedPoints - pointsToDo);
    var score = 0;
    // Pour l'attaque
    score = _victoryBonus + gain.abs();
    score *= _selectedTarotContract.multiplayer;
    if (_selectedPoignee != null) {
      score += _selectedPoignee.bonus;
    }
    if (gain >= 0) {
      if (_selectedTeamForBout == TarotTeam.ATTACK) {
        score += (_petitAuBoutBonus * _selectedTarotContract.multiplayer);
      }
      if (_selectedTeamForBout == TarotTeam.DEFENSE) {
        score -= _petitAuBoutBonus;
      }
      setState(() {
        _attackPoints = score * (tarotGame.playerIds.length - 1);
        _defensePoints = -score;
      });
      // Pour la défense
    } else {
      if (_selectedTeamForBout == TarotTeam.DEFENSE) {
        score += (_petitAuBoutBonus * _selectedTarotContract.multiplayer);
      }
      if (_selectedTeamForBout == TarotTeam.ATTACK) {
        score -= _petitAuBoutBonus;
      }
      setState(() {
        _attackPoints = -score * (tarotGame.playerIds.length - 1);
        _defensePoints = score;
      });
    }

    return score;
  }

  Future<TarotTeam> _showPetitAuBoutPicker() {
    return showDialog(
      context: context,
      builder: (BuildContext context,) {
        return _PetitAuBoutPicker(_selectedTeamForBout);
      },
    );
  }

  Future<dynamic> _showPoigneePicker() {
    return showDialog(
      context: context,
      builder: (BuildContext context,) {
        return _PoigneePicker(_selectedPoignee, tarotGame.playerIds.length);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child:
            Text('Contrat', style: Theme
                .of(context)
                .textTheme
                .bodyText1),
          ),
        ),
        Center(
          child: DropdownButton<TarotContract>(
            value: _selectedTarotContract,
            items: TarotContract.values.map((TarotContract value) {
              return DropdownMenuItem<TarotContract>(
                value: value,
                child: Text(EnumToString.convertToString(value)),
              );
            }).toList(),
            onChanged: (TarotContract val) {
              setState(() {
                _selectedTarotContract = val;
                _computePoints();
              });
            },
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text('Nombre de bout(s)',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: TarotBoutCount.values
                .map((tarotBoutCount) =>
                InputChip(
                  selectedColor: Theme
                      .of(context)
                      .accentColor,
                  selected: _selectedBout == tarotBoutCount,
                  onPressed: () {
                    setState(() {
                      _selectedBout = tarotBoutCount;
                      _computePoints();
                    });
                  },
                  label: Text(tarotBoutCount.string),
                ))
                .toList()
                .cast<Widget>()),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text('Bonus', style: Theme
                .of(context)
                .textTheme
                .bodyText1),
          ),
        ),
        Wrap(spacing: 10, alignment: WrapAlignment.center, children: [
          InputChip(
            onDeleted: _selectedTeamForBout != null
                ? () =>
            {
              setState(() {
                _selectedTeamForBout = null;
                _computePoints();
              })
            }
                : null,
            avatar: _selectedTeamForBout != null
                ? CircleAvatar(
                child: Text(EnumToString.convertToString(_selectedTeamForBout)
                    ?.substring(0, 1)))
                : null,
            showCheckmark: false,
            selectedColor: Theme
                .of(context)
                .accentColor,
            selected: _selectedTeamForBout != null,
            onPressed: () async {
              await _showPetitAuBoutPicker().then((value) =>
                  setState(() {
                    _selectedTeamForBout = value;
                    _computePoints();
                  }));
            },
            label: Text(TarotPerk.PETIT_AU_BOUT.string),
          ),
          InputChip(
            onDeleted: _selectedPoignee != null
                ? () =>
            {
              setState(() {
                _selectedPoignee = null;
                _computePoints();
              })
            }
                : null,
            avatar: _selectedPoignee != null
                ? CircleAvatar(
                child: Text(_selectedPoignee.name.substring(0, 1)))
                : null,
            showCheckmark: false,
            selectedColor: Theme
                .of(context)
                .accentColor,
            selected: _selectedPoignee != null,
            onPressed: () async {
              await _showPoigneePicker().then((value) =>
                  setState(() {
                    _selectedPoignee = value;
                    _computePoints();
                  }));
            },
            label: Text(TarotPerk.POIGNEE.string),
          ),
        ]),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text('Points des plis',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1),
          ),
        ),
        Slider(
          value: _selectedPoints.toDouble(),
          min: 0,
          max: _maxPoints.toDouble(),
          divisions: _maxPoints,
          label: 'Attaque : ' +
              _selectedPoints.round().toString() +
              '\n' +
              'Défense : ' +
              (_maxPoints - _selectedPoints.round()).toString(),
          onChanged: (double value) {
            setState(() {
              _selectedPoints = value.toInt();
              _computePoints();
            });
          },
        ),
        Text(
          'Attaque : ' +
              _selectedPoints.round().toString() +
              ' (' +
              _attackPoints.toString() +
              ')' +
              ' | ' +
              'Défense : ' +
              (_maxPoints - _selectedPoints.round()).toString() +
              ' (' +
              _defensePoints.toString() +
              ')',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: RaisedButton.icon(
              color: Theme
                  .of(context)
                  .primaryColor,
              textColor: Theme
                  .of(context)
                  .cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () async => {await _tarotScoreService.addRoundToGame(tarotGame.id, TarotRound())},
              label: Text('Valider', style: TextStyle(fontSize: 14)),
              icon: Icon(Icons.check)),
        )
      ],
    );
  }
}
