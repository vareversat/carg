import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PlayerInfoDialog extends StatefulWidget {
  final Player player;
  final PlayerService playerService;
  final bool isNewPlayer;

  PlayerInfoDialog(
      {required this.player,
      required this.playerService,
      required this.isNewPlayer});

  @override
  State<StatefulWidget> createState() {
    return _PlayerInfoDialogState();
  }
}

class _PlayerInfoDialogState extends State<PlayerInfoDialog> {

  String _getTitle() {
    if (widget.isNewPlayer) {
      return 'Nouveau joueur';
    } else if (widget.player.owned) {
      return 'Edition';
    } else {
      return 'Informations';
    }
  }

  Future<void> _savePlayer() async {
    print(widget.player);
    if (widget.isNewPlayer) {
      widget.player.ownedBy =
          Provider.of<AuthService>(context, listen: false).getPlayerIdOfUser();
      await widget.playerService.addPlayer(widget.player);
      Navigator.of(context).pop('Joueur créé avec succès');
    } else {
      await widget.playerService.updatePlayer(widget.player);
      Navigator.of(context).pop('Joueur modifié avec succès');
    }
  }

  void _copyId() {
    Clipboard.setData(ClipboardData(text: widget.player.id)).then((_) {
      InfoSnackBar.showSnackBar(context, 'ID copié dans le presse papier');
    });
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _getTitle(),
                key: ValueKey('titleText'),
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyle.dialogHeaderStyle(context),
              ),
            ),
            if (widget.player.owned && !widget.isNewPlayer)
              Flexible(
                child: ElevatedButton.icon(
                  key: ValueKey('copyIDButton'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  CustomProperties.borderRadius)))),
                  onPressed: () => {_copyId()},
                  icon: Icon(Icons.copy),
                  label: Text("Copier l'ID"),
                ),
              )
          ],
        ),
      ),
      content: ChangeNotifierProvider.value(
        value: widget.player,
        child: ListBody(children: [
          Row(
            children: <Widget>[
              Consumer<Player>(
                builder: (context, playerData, _) => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                  child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2, color: Theme.of(context).primaryColor),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(playerData.profilePicture)))),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Consumer<Player>(
                    builder: (context, playerData, _) => TextFormField(
                        key: ValueKey('usernameTextField'),
                        initialValue: playerData.userName,
                        enabled: playerData.owned,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        maxLines: null,
                        onChanged: (value) => playerData.userName = value,
                        decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context).hintColor),
                            labelText: playerData.owned && widget.isNewPlayer
                                ? "Nom d'utilisateur"
                                : null)),
                  ),
                ),
              ),
            ],
          ),
          if (widget.isNewPlayer)
            Consumer<Player>(
              builder: (context, playerData, _) => Container(
                child: TextFormField(
                    key: ValueKey('profilePictureTextField'),
                    initialValue: playerData.profilePicture,
                    enabled: playerData.owned,
                    onChanged: (value) => playerData.profilePicture = value,
                    style: TextStyle(fontSize: 20),
                    maxLines: null,
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize: 15, color: Theme.of(context).hintColor),
                        labelText: 'Image de profile (url)')),
              ),
            ),
          if (widget.player.gameStatsList != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: widget.player.gameStatsList!
                    .map(
                      (stat) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              width: 100,
                              child: Text('${stat.gameType.name} : ',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 22))),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Icon(FontAwesomeIcons.trophy, size: 15),
                          ),
                          Text(
                            ' ' + stat.wonGames.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            ' - ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            stat.playedGames.toString() + ' ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Icon(FontAwesomeIcons.gamepad, size: 15),
                          )
                        ],
                      ),
                    )
                    .toList()
                    .cast<Widget>(),
              ),
            ),
        ]),
      ),
      actions: <Widget>[
        if (widget.player.owned)
          ElevatedButton.icon(
            key: ValueKey('editButton'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).cardColor),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              CustomProperties.borderRadius)))),
              onPressed: () async => await _savePlayer(),
              label: Text(MaterialLocalizations.of(context).saveButtonLabel),
              icon: Icon(Icons.check))
        else
          ElevatedButton.icon(
            key: ValueKey('closeButton'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius)))),
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
            label: Text(MaterialLocalizations.of(context).closeButtonLabel),
          )
      ],
      scrollable: true,
    );
  }
}
