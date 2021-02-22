import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditPlayerDialog extends StatefulWidget {
  final Player player;

  EditPlayerDialog({this.player});

  @override
  State<StatefulWidget> createState() {
    return _EditPlayerDialogState(player);
  }
}

class _EditPlayerDialogState extends State<EditPlayerDialog> {
  final _pseudoTextController = TextEditingController();
  final _profilePictureTextController = TextEditingController();
  final _playerService = PlayerService();
  var _title;
  var _isCreating;
  bool _isLoading = false;

  String _profilePictureUrl = '';
  Player _player;

  _EditPlayerDialogState(Player player) {
    _isCreating = player == null ? true : false;
    _title = _isCreating ? 'Nouveau joueur' : 'Infos';
    _player = player ?? Player();
    print(_player);
  }

  void _setProfilePictureUrl(String url) {
    setState(() {
      _profilePictureUrl = url;
    });
  }

  Future _commitPlayer() async {
    setState(() {
      _isLoading = true;
    });
    if (_isCreating) {
      _player = Player(
          userName: _pseudoTextController.text,
          profilePicture: _profilePictureUrl);
      await _playerService.addPlayer(_player);
    } else {
      _player.userName = _pseudoTextController.text;
      _player.profilePicture = _profilePictureTextController.text;
      await _playerService.updatePlayer(_player);
    }
    setState(() {
      _isLoading = true;
    });
  }

  void _getInitialValues() {
    if (_player != null) {
      _profilePictureUrl = _player.profilePicture;
      _pseudoTextController.text = _player.userName;
      _profilePictureTextController.text = _player.profilePicture;
    }
  }

  @override
  void initState() {
    _getInitialValues();
    super.initState();
  }

  @override
  void dispose() {
    _pseudoTextController.dispose();
    _profilePictureTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0))),
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 15),
        child: Text(
          _title,
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyle.screenHeadLine1(context),
        ),
      ),
      content: ListBody(children: [
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 2, color: Theme.of(context).primaryColor),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(_profilePictureUrl)))),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                  enabled: _isCreating,
                  controller: _pseudoTextController,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  maxLines: null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: 25, color: Theme.of(context).hintColor),
                      labelText: 'Pseudo')),
            ),
          ],
        ),
        if (_isCreating)
          Container(
            child: TextFormField(
                enabled: _isCreating,
                onChanged: (text) => _setProfilePictureUrl(text),
                controller: _profilePictureTextController,
                style: TextStyle(fontSize: 15),
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontSize: 15, color: Theme.of(context).hintColor),
                    labelText: 'Image de profile (url)')),
          )
        else
          Container(),
        Column(
          children: _player.gameStatsList
              .map(
                (stat) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${stat.gameType.name} : '),
                    Icon(Icons.stars, size: 15),
                    Text(
                      ' ' + stat.wonGames.toString(),
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      ' | ',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      stat.playedGames.toString() + ' ',
                      style: TextStyle(fontSize: 17),
                    ),
                    Icon(Icons.gamepad, size: 15)
                  ],
                ),
              )
              .toList()
              .cast<Widget>(),
        ),
      ]),
      actions: <Widget>[
        if (_isLoading)
          CircularProgressIndicator()
        else
          RaisedButton.icon(
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () async => _isCreating
                  ? {await _commitPlayer(), Navigator.pop(context)}
                  : Navigator.pop(context),
              label: Text(_isCreating
                  ? MaterialLocalizations.of(context).okButtonLabel
                  : MaterialLocalizations.of(context).closeButtonLabel),
              icon: Icon(_isCreating ? Icons.check : Icons.close)),
        if (_isCreating)
          FlatButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Theme.of(context).primaryColor)),
            onPressed: () => {Navigator.pop(context)},
            color: Colors.white,
            textColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.close),
            label: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          )
        else
          Container(),
      ],
      scrollable: true,
    );
  }
}
