import 'package:carg/models/player/player.dart';
import 'package:carg/services/player_service.dart';
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
  final String _title = 'Infos';
  var _isCreating;
  bool _isLoading = false;

  String _profilePictureUrl = '';
  Player _player;

  _EditPlayerDialogState(Player player) {
    _isCreating = player == null ? true : false;
    _player = player ?? Player();
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
        child: Text(
          _title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
      ),
      children: <Widget>[
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
                      hintText: 'Pseudo')),
            )
          ],
        ),
        _isCreating ? Container(
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
                  hintText: 'Image de profile (url)')),
        ) : Container(),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _isCreating
                  ? FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      onPressed: () => {Navigator.pop(context)},
                      color: Colors.white,
                      textColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.close),
                      label: Text('Annuler',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    )
                  : Container(),
              SizedBox(
                width: 10,
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton.icon(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      onPressed: () async => _isCreating
                          ? {await _commitPlayer(), Navigator.pop(context)}
                          : Navigator.pop(context),
                      label: Text(_isCreating ? 'Confirmer' : 'Fermer',
                          style: TextStyle(fontSize: 14)),
                      icon: Icon(_isCreating ? Icons.check : Icons.close)),
            ],
          ),
        ),
      ],
    );
  }
}
