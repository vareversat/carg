import 'package:carg/models/player.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/widgets/players/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerColorExplanationDialog extends StatelessWidget {
  final bool isAdmin;

  const PlayerColorExplanationDialog({Key? key, required this.isAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        child: Text(
          'Informations',
          key: const ValueKey('titleText'),
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyle.dialogHeaderStyle(context)
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      content: ListBody(children: [
        PlayerWidget(
            key: const ValueKey('playerWidgetRealPlayer'),
            player: Player(userName: 'Joueur', owned: false),
            onTap: () => {}),
        const Padding(
            key: ValueKey("realPlayerDescription"),
            padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
            child: Text(
                '"Joueurs" : Cette couleur indique que ce joueur dispose de l\'application Carg')),
        PlayerWidget(
            key: const ValueKey('playerWidgetOwnedPlayer'),
            player: Player(userName: 'Joueur', owned: true),
            onTap: () => {}),
        const Padding(
          key: ValueKey('ownedPlayerDescription'),
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
          child: Text(
              '"Mes joueurs" : Cette couleur indique que ce joueur a été créé par vous. Il n\'est accessible que pour les parties que vous créé sur votre application'),
        ),
        if (isAdmin)
          Column(children: [
            PlayerWidget(
                key: const ValueKey('playerWidgetTestingPlayer'),
                player: Player(userName: 'Joueur', owned: false, testing: true),
                onTap: () => {}),
            const Padding(
              key: ValueKey('testingPlayerDescription'),
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
              child: Text(
                  '"Jouers de test" : Cette couleur indique que ce joueur est utilisé pour les tests d\'intégrations. Si vous voyez ce type de joueurs, cela indique que vous ếtes administrateur de l\'application'),
            )
          ]),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(
            height: 10,
            color: Colors.black,
          ),
        ),
        Row(children: [
          const Icon(FontAwesomeIcons.trophy, color: Colors.black, size: 15),
          Flexible(
            key: const ValueKey('wonGamesDescription'),
            child: Text('   Nombre total de parties remportées',
                style: CustomTextStyle.boldAndItalic(context)
                    .copyWith(fontSize: 15)),
          )
        ]),
        Row(children: [
          const Icon(FontAwesomeIcons.gamepad, color: Colors.black, size: 15),
          Flexible(
            key: const ValueKey('playedGamesDescription'),
            child: Text('   Nombre total de parties jouées',
                overflow: TextOverflow.clip,
                style: CustomTextStyle.boldAndItalic(context)
                    .copyWith(fontSize: 15)),
          )
        ])
      ]),
      actions: <Widget>[
        ElevatedButton.icon(
          key: const ValueKey('closeButton'),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
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
