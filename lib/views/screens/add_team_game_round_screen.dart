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

class AddTeamGameRoundScreen extends StatefulWidget {
  final TeamGame teamGame;

  const AddTeamGameRoundScreen({@required this.teamGame});

  @override
  State<StatefulWidget> createState() {
    return _AddTeamGameRoundScreenState(teamGame);
  }
}

class _AddTeamGameRoundScreenState extends State<AddTeamGameRoundScreen> {
  final TeamGame _teamGame;
  final int _dixDeDerBonus = 10;
  final int _beloteRebeloteBonus = 20;
  final int _totalPoints = 160;
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

  void _refreshScore() {
    _computeScore();
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

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
      setState(() {
        _takerPoints = _getContract() +
            _getPoints(_takerTeam) +
            _getBeloteRebelote(_takerTeam);
        _defenderPoints =
            _getPoints(_defenderTeam) + _getBeloteRebelote(_defenderTeam);
      });
    } else if (!_isContractFulfilled()) {
      setState(() {
        _takerPoints = _getBeloteRebelote(_takerTeam);
        _defenderPoints =
            _totalPoints + _getContract() + _getBeloteRebelote(_defenderTeam);
      });
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

  _AddTeamGameRoundScreenState(this._teamGame) {
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
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () => Navigator.pop(context),
            ),
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
                        color: Theme.of(context).cardColor)))),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text('Equipe preneuse',
                          style: Theme.of(context).textTheme.headline2),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: <Widget>[
                        Text(
                          'Nous',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
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
                            _computeScore();
                          },
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
                              _computeScore();
                            },
                          ),
                          Text(
                            'Eux',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              )),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Points des plis',
                      style: Theme.of(context).textTheme.headline2),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Nous',
                            style: Theme.of(context).textTheme.bodyText2),
                        Text('Eux',
                            style: Theme.of(context).textTheme.bodyText2),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              controller: _usPointsTextController,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[],
                              onSubmitted: (String value) => _refreshScore(),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).hintColor),
                                hintText: 'Points',
                              )),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              controller: _themPointsTextController,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[],
                              onSubmitted: (String value) => _refreshScore(),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).hintColor),
                                hintText: 'Points',
                              )),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  _computeScore();
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
                                _computeScore();
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
                                  _computeScore();
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
                                _computeScore();
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: Text(
                    'Attaque : ' +
                        _takerPoints.toString() +
                        ' | ' +
                        'Défense : ' +
                        _defenderPoints.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Contrat',
                      style: Theme.of(context).textTheme.headline2),
                ),
              ),
              Column(
                children: <Widget>[
                  _teamGame is CoincheGame
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: TextField(
                            controller: _contractTextController,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[],
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).hintColor),
                              hintText: 'Valeur',
                            ),
                            onSubmitted: (String value) => _refreshScore(),
                          ),
                        )
                      : Container(),
                  _teamGame is CoincheGame
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DropdownButton<ContractName>(
                              value: _selectedContract,
                              items:
                                  ContractName.values.map((ContractName value) {
                                return DropdownMenuItem<ContractName>(
                                  value: value,
                                  child:
                                      Text(EnumToString.convertToString(value)),
                                );
                              }).toList(),
                              onChanged: (ContractName val) {
                                setState(() {
                                  _selectedContract = val;
                                });
                              },
                            ),
                            DropdownButton<CardColor>(
                              value: _selectedCardColor,
                              items: CardColor.values.map((CardColor value) {
                                return DropdownMenuItem<CardColor>(
                                  value: value,
                                  child:
                                      Text(EnumToString.convertToString(value)),
                                );
                              }).toList(),
                              onChanged: (CardColor val) {
                                setState(() {
                                  _selectedCardColor = val;
                                });
                              },
                            ),
                          ],
                        )
                      : DropdownButton<ContractName>(
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
                        ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: RaisedButton.icon(
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    onPressed: () async =>
                        {await _createRound(), Navigator.pop(context)},
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Valider',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    icon: Icon(Icons.check)),
              )
            ],
          ),
        ));
  }
}
