import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PlayerInfoDialog extends StatelessWidget {
  final Player player;
  final AbstractPlayerService playerService;
  final bool isNewPlayer;

  const PlayerInfoDialog(
      {Key? key,
      required this.player,
      required this.playerService,
      required this.isNewPlayer})
      : super(key: key);

  String _getTitle() {
    if (isNewPlayer) {
      return 'Nouveau joueur';
    } else if (player.owned) {
      return 'Edition';
    } else {
      return 'Informations';
    }
  }

  Future<void> _savePlayer(BuildContext context) async {
    if (isNewPlayer) {
      player.ownedBy =
          Provider.of<AuthService>(context, listen: false).getPlayerIdOfUser();
      await playerService.create(player);
      Navigator.of(context).pop('Joueur créé avec succès');
    } else {
      await playerService.create(player);
      Navigator.of(context).pop('Joueur modifié avec succès');
    }
  }

  void _copyId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: player.id)).then((_) {
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
            color: player.getSideColor(context),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _getTitle(),
                key: const ValueKey('titleText'),
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyle.dialogHeaderStyle(context),
              ),
            ),
            if (player.owned && !isNewPlayer)
              Flexible(
                child: ElevatedButton.icon(
                  key: const ValueKey('copyIDButton'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          player.getSideColor(context)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  CustomProperties.borderRadius)))),
                  onPressed: () => {_copyId(context)},
                  icon: const Icon(Icons.copy),
                  label: const Text("Copier l'ID"),
                ),
              )
          ],
        ),
      ),
      content: ChangeNotifierProvider.value(
        value: player,
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
                              width: 2, color: player.getSideColor(context)),
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
                        key: const ValueKey('usernameTextField'),
                        initialValue: playerData.userName,
                        enabled: playerData.owned,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        maxLines: null,
                        onChanged: (value) => playerData.userName = value,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: player.getSideColor(context), width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: player.getSideColor(context), width: 2),
                            ),
                            disabledBorder: InputBorder.none,
                            labelStyle:
                                TextStyle(color: player.getSideColor(context)),
                            hintStyle: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context).hintColor),
                            labelText: playerData.owned && isNewPlayer
                                ? "Nom d'utilisateur"
                                : null)),
                  ),
                ),
              ),
            ],
          ),
          if (isNewPlayer)
            Consumer<Player>(
              builder: (context, playerData, _) => TextFormField(
                  key: const ValueKey('profilePictureTextField'),
                  initialValue: playerData.profilePicture,
                  enabled: playerData.owned,
                  onChanged: (value) => playerData.profilePicture = value,
                  style: const TextStyle(fontSize: 20),
                  maxLines: null,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: player.getSideColor(context), width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: player.getSideColor(context), width: 2),
                      ),
                      labelStyle: TextStyle(color: player.getSideColor(context)),
                      hintStyle: TextStyle(
                          fontSize: 15, color: Theme.of(context).hintColor),
                      labelText: 'Image de profile (url)')),
            ),
          if (player.gameStatsList != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Column(
                children: player.gameStatsList!
                    .map(
                      (stat) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              width: 100,
                              child: Text('${stat.gameType.name} : ',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 22))),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Icon(FontAwesomeIcons.trophy, size: 15),
                          ),
                          Text(
                            ' ' + stat.wonGames.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Text(
                            ' - ',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            stat.playedGames.toString() + ' ',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
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
        if (player.owned)
          ElevatedButton.icon(
              key: const ValueKey('editButton'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(player.getSideColor(context)),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).cardColor),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              CustomProperties.borderRadius)))),
              onPressed: () async => await _savePlayer(context),
              label: Text(MaterialLocalizations.of(context).saveButtonLabel),
              icon: const Icon(Icons.check))
        else
          ElevatedButton.icon(
            key: const ValueKey('closeButton'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                foregroundColor:
                    MaterialStateProperty.all<Color>(player.getSideColor(context)),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius)))),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: Text(MaterialLocalizations.of(context).closeButtonLabel),
          )
      ],
      scrollable: true,
    );
  }
}
