import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/coinche_game.dart';
import 'package:carg/models/game/team_game.dart';
import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/models/score/misc/contract_name.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/score/round/coinche_round.dart';
import 'package:carg/services/score/belote_score_service.dart';
import 'package:carg/services/score/coinche_score_service.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTeamGameRoundDialog extends StatefulWidget {
  final TeamGame teamGame;

  const AddTeamGameRoundDialog({@required this.teamGame});

  @override
  State<StatefulWidget> createState() {
    return _AddTeamGameRoundDialogState(teamGame);
  }
}

class _AddTeamGameRoundDialogState extends State<AddTeamGameRoundDialog> {
  final TeamGame _teamGame;
  final int _dixDeDerBonus = 10;
  final int _beloteRebeloteBonus = 20;
  final TextEditingController _contractTextController = TextEditingController();
  final TextEditingController _usPointsTextController = TextEditingController();
  final TextEditingController _themPointsTextController =
      TextEditingController();
  final BeloteScoreService _beloteScoreService = BeloteScoreService();
  final CoincheScoreService _coincheScoreService = CoincheScoreService();
  ContractName _selectedContract = ContractName.NORMAL;
  String _selectedTeam;
  TeamGameEnum _takerTeam;
  TeamGameEnum _defenderTeam;
  CardColor _selectedCardColor;
  bool _usDidDixDeDer = true;
  bool _usBeloteRebelote = false;
  bool _themBeloteRebelote = false;
  int _takerPoints = 0;
  int _defenderPoints = 0;

  bool _isContractFulfilled() {
    if (_teamGame is CoincheGame) {
      return _getPoints(_takerTeam) >= _getContract();
    }
    if (_teamGame is BeloteGame) {
      return (_usBeloteRebelote || _themBeloteRebelote)
          ? _getPoints(_takerTeam) > 80
          : _getPoints(_takerTeam) > 90;
    }
    return false;
  }

  int _getPoints(TeamGameEnum teamGameEnum) {
    switch (teamGameEnum) {
      case TeamGameEnum.US:
        return _getUsScore();
      case TeamGameEnum.THEM:
        return _getThemScore();
    }
    return 0;
  }

  int _getBeloteRebelote(TeamGameEnum teamGameEnum) {
    switch (teamGameEnum) {
      case TeamGameEnum.THEM:
        return _themBeloteRebelote ? _beloteRebeloteBonus : 0;
      case TeamGameEnum.US:
        return _usBeloteRebelote ? _beloteRebeloteBonus : 0;
    }
    return 0;
  }

  int _getDixDeDerScore(TeamGameEnum teamGameEnum) {
    switch (teamGameEnum) {
      case TeamGameEnum.THEM:
        return _usDidDixDeDer ? 0 : _dixDeDerBonus;
      case TeamGameEnum.US:
        return _usDidDixDeDer ? _dixDeDerBonus : 0;
    }
    return 0;
  }

  TeamGameEnum _getDixDeDerTeam() {
    return _usDidDixDeDer ? TeamGameEnum.US : TeamGameEnum.THEM;
  }

  TeamGameEnum _getBeloteRebeloteTeam() {
    if (!_usBeloteRebelote && !_themBeloteRebelote) {
      return null;
    }
    return _usBeloteRebelote ? TeamGameEnum.US : TeamGameEnum.THEM;
  }

  void _computeScore() {
    if (_isContractFulfilled()) {
      _takerPoints = _getContract() +
          _getPoints(_takerTeam) +
          _getBeloteRebelote(_takerTeam);
      _defenderPoints =
          _getPoints(_defenderTeam) + _getBeloteRebelote(_defenderTeam);
    } else if (!_isContractFulfilled()) {
      _takerPoints = _getBeloteRebelote(_takerTeam);
      _defenderPoints =
          160 + _getContract() + _getBeloteRebelote(_defenderTeam);
    }
  }

  void _createRound() {
    _computeScore();
    if (_teamGame is BeloteGame) {
      var round = BeloteRound(
          cardColor: _selectedCardColor,
          contractFulfilled: _isContractFulfilled(),
          taker: _takerTeam,
          dixDeDer: _getDixDeDerTeam(),
          beloteRebelote: _getBeloteRebeloteTeam(),
          takerScore: _takerPoints,
          defenderScore: _defenderPoints);
      _beloteScoreService.addRoundToGame(_teamGame.id, round);
    } else if (_teamGame is CoincheGame) {
      var round = CoincheRound(
          cardColor: _selectedCardColor,
          contract: _getContract(),
          contractFulfilled: _isContractFulfilled(),
          taker: _takerTeam,
          dixDeDer: _getDixDeDerTeam(),
          beloteRebelote: _getBeloteRebeloteTeam(),
          takerScore: _takerPoints,
          defenderScore: _defenderPoints);
      _coincheScoreService.addRoundToGame(_teamGame.id, round);
    }
  }

  _AddTeamGameRoundDialogState(this._teamGame) {
    _selectedTeam = _teamGame.us;
    _takerTeam = TeamGameEnum.US;
    _defenderTeam = TeamGameEnum.THEM;
    _selectedCardColor = CardColor.COEUR;
  }

  int _getContract() {
    return _contractTextController.text != ''
        ? int.parse(_contractTextController.text)
        : 0;
  }

  int _getUsScore() {
    var score = _usPointsTextController.text != ''
        ? int.parse(_usPointsTextController.text)
        : 0;
    return score + _getDixDeDerScore(TeamGameEnum.US);
  }

  int _getThemScore() {
    var score = _themPointsTextController.text != ''
        ? int.parse(_themPointsTextController.text)
        : 0;
    return score + _getDixDeDerScore(TeamGameEnum.THEM);
  }

  @override
  void dispose() {
    _usPointsTextController.dispose();
    _themPointsTextController.dispose();
    _contractTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      titlePadding: const EdgeInsets.all(0),
      title: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0))),
          padding: const EdgeInsets.all(20),
          child: Text('Nouvelle manche',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Theme.of(context).cardColor))),
      children: <Widget>[
        Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Equipe preneuse : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Row(children: <Widget>[
                  Radio(
                    visualDensity: VisualDensity.compact,
                    value: _teamGame.us,
                    groupValue: _selectedTeam,
                    onChanged: (String value) {
                      setState(() {
                        _selectedTeam = value;
                        _takerTeam = TeamGameEnum.US;
                        _defenderTeam = TeamGameEnum.THEM;
                      });
                    },
                  ),
                  Text(
                    'Nous',
                    style: TextStyle(fontSize: 13.0),
                  ),
                ]),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Radio(
                      visualDensity: VisualDensity.compact,
                      value: _teamGame.them,
                      groupValue: _selectedTeam,
                      onChanged: (String value) {
                        setState(() {
                          _selectedTeam = value;
                          _takerTeam = TeamGameEnum.THEM;
                          _defenderTeam = TeamGameEnum.US;
                        });
                      },
                    ),
                    Text(
                      'Eux',
                      style: TextStyle(fontSize: 13.0),
                    )
                  ],
                ),
              ],
            ),
          ],
        )),
        InputDecorator(
            decoration: InputDecoration(
                labelText: 'Points des plis',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow))),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: TextField(
                          controller: _usPointsTextController,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).hintColor),
                            border: InputBorder.none,
                            hintText: 'Nous..',
                          )),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextField(
                          controller: _themPointsTextController,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).hintColor),
                            hintText: 'Eux..',
                          )),
                    ),
                  ],
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.vertical,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Belote-Re',
                                style: TextStyle(fontSize: 13.0),
                              ),
                              Checkbox(
                                visualDensity: VisualDensity.compact,
                                value: _usBeloteRebelote,
                                onChanged: (bool value) {
                                  setState(() {
                                    _usBeloteRebelote = value;
                                    _themBeloteRebelote = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(children: <Widget>[
                            Text(
                              'Dix de Der',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            Radio(
                              visualDensity: VisualDensity.compact,
                              value: true,
                              onChanged: (bool value) {
                                setState(() {
                                  _usDidDixDeDer = value;
                                });
                              },
                              groupValue: _usDidDixDeDer,
                            ),
                          ]),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.vertical,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Checkbox(
                                visualDensity: VisualDensity.compact,
                                value: _themBeloteRebelote,
                                onChanged: (bool value) {
                                  setState(() {
                                    _themBeloteRebelote = value;
                                    _usBeloteRebelote = false;
                                  });
                                },
                              ),
                              Text(
                                'Belote-Re',
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ],
                          ),
                          Row(children: <Widget>[
                            Radio(
                              visualDensity: VisualDensity.compact,
                              value: false,
                              onChanged: (bool value) {
                                setState(() {
                                  _usDidDixDeDer = value;
                                });
                              },
                              groupValue: _usDidDixDeDer,
                            ),
                            Text(
                              'Dix de Der',
                              style: TextStyle(fontSize: 13.0),
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
        Divider(),
        InputDecorator(
          decoration: InputDecoration(
              labelText: 'Contrat',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow))),
          child: Column(
            children: <Widget>[
              _teamGame is CoincheGame
                  ? DropdownButton<ContractName>(
                      value: _selectedContract,
                      items: ContractName.values.map((ContractName value) {
                        return DropdownMenuItem<ContractName>(
                          value: value,
                          child: Text(EnumToString.convertToString(value)),
                        );
                      }).toList(),
                      onChanged: (ContractName val) {
                        setState(() {
                          _selectedContract = val;
                        });
                      },
                    )
                  : Container(),
              _teamGame is CoincheGame
                  ? TextField(
                      controller: _contractTextController,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[],
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontSize: 20, color: Theme.of(context).hintColor),
                        border: InputBorder.none,
                        hintText: 'Valeur...',
                      ))
                  : Container(),
              DropdownButton<CardColor>(
                value: _selectedCardColor,
                items: CardColor.values.map((CardColor value) {
                  return DropdownMenuItem<CardColor>(
                    value: value,
                    child: Text(EnumToString.convertToString(value)),
                  );
                }).toList(),
                onChanged: (CardColor val) {
                  setState(() {
                    _selectedCardColor = val;
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                onPressed: () => {Navigator.pop(context)},
                color: Colors.white,
                textColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.close),
                label: Text('Annuler',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                width: 10,
              ),
              RaisedButton.icon(
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  onPressed: () async =>
                      {await _createRound(), Navigator.pop(context)},
                  label: Text('Confirmer', style: TextStyle(fontSize: 14)),
                  icon: Icon(Icons.check)),
            ],
          ),
        ),
      ],
    );
  }
}
