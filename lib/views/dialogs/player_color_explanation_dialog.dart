import 'package:carg/models/player.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/widgets/players/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayerColorExplanationDialog extends StatelessWidget {
  final bool isAdmin;

  const PlayerColorExplanationDialog({super.key, required this.isAdmin});

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
          AppLocalizations.of(context)!.information,
          key: const ValueKey('titleText'),
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyle.dialogHeaderStyle(context)
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      content: ListBody(children: [
        PlayerWidget(
            key: const ValueKey('playerWidgetRealPlayer'),
            player: Player(
                userName: AppLocalizations.of(context)!.player(1),
                owned: false),
            onTap: () => {}),
        Padding(
            key: const ValueKey("realPlayerDescription"),
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
            child: Text(
                '"${AppLocalizations.of(context)!.player(2)}" : ${AppLocalizations.of(context)!.realPlayersExplanation}')),
        PlayerWidget(
            key: const ValueKey('playerWidgetOwnedPlayer'),
            player: Player(
                userName: AppLocalizations.of(context)!.player(1), owned: true),
            onTap: () => {}),
        Padding(
          key: const ValueKey('ownedPlayerDescription'),
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
          child: Text(
              '"${AppLocalizations.of(context)!.myPlayers}" : ${AppLocalizations.of(context)!.ownedPlayersExplanation}'),
        ),
        if (isAdmin)
          Column(children: [
            PlayerWidget(
                key: const ValueKey('playerWidgetTestingPlayer'),
                player: Player(
                    userName: AppLocalizations.of(context)!.player(1),
                    owned: false,
                    testing: true),
                onTap: () => {}),
            Padding(
              key: const ValueKey('testingPlayerDescription'),
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
              child: Text(
                  '"${AppLocalizations.of(context)!.testPlayers}" : ${AppLocalizations.of(context)!.testPlayersExplanation}'),
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
            child: Text('   ${AppLocalizations.of(context)!.wonGamesTotal}',
                style: CustomTextStyle.boldAndItalic(context)
                    .copyWith(fontSize: 15)),
          )
        ]),
        Row(children: [
          const Icon(FontAwesomeIcons.gamepad, color: Colors.black, size: 15),
          Flexible(
            key: const ValueKey('playedGamesDescription'),
            child: Text('   ${AppLocalizations.of(context)!.playedGamesTotal}',
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
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              foregroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
              shape: WidgetStateProperty.all<OutlinedBorder>(
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
