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
import 'package:carg/l10n/app_localizations.dart';

class PlayerInfoDialog extends StatelessWidget {
  final Player player;
  final AbstractPlayerService playerService;
  final bool isNewPlayer;

  const PlayerInfoDialog({
    super.key,
    required this.player,
    required this.playerService,
    required this.isNewPlayer,
  });

  String _getTitle(BuildContext context) {
    if (isNewPlayer) {
      return AppLocalizations.of(context)!.newPlayer;
    } else if (player.owned) {
      return AppLocalizations.of(context)!.edition;
    } else {
      return AppLocalizations.of(context)!.information;
    }
  }

  Future<void> _savePlayer(BuildContext context) async {
    if (isNewPlayer) {
      player.ownedBy = Provider.of<AuthService>(
        context,
        listen: false,
      ).getPlayerIdOfUser();
      await playerService.create(player);
      Navigator.of(context).pop(AppLocalizations.of(context)!.playerCreated);
    } else {
      await playerService.update(player);
      Navigator.of(context).pop(AppLocalizations.of(context)!.playerEdited);
    }
  }

  Future _copyId(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: player.id!));
    InfoSnackBar.showSnackBar(context, AppLocalizations.of(context)!.idCopied);
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
            topRight: Radius.circular(15.0),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _getTitle(context),
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
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      player.getSideColor(context),
                    ),
                    shape: WidgetStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          CustomProperties.borderRadius,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async => {await _copyId(context)},
                  icon: const Icon(Icons.copy),
                  label: Text(AppLocalizations.of(context)!.copyId),
                ),
              ),
          ],
        ),
      ),
      content: ChangeNotifierProvider.value(
        value: player,
        child: ListBody(
          children: [
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
                          width: 2,
                          color: player.getSideColor(context),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(playerData.profilePicture),
                        ),
                      ),
                    ),
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
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                        onChanged: (value) => playerData.userName = value,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: player.getSideColor(context),
                              width: 2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: player.getSideColor(context),
                              width: 2,
                            ),
                          ),
                          disabledBorder: InputBorder.none,
                          labelStyle: TextStyle(
                            color: player.getSideColor(context),
                          ),
                          hintStyle: TextStyle(
                            fontSize: 25,
                            color: Theme.of(context).hintColor,
                          ),
                          labelText: playerData.owned && isNewPlayer
                              ? AppLocalizations.of(context)!.username
                              : null,
                        ),
                      ),
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
                      borderSide: BorderSide(
                        color: player.getSideColor(context),
                        width: 2,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: player.getSideColor(context),
                        width: 2,
                      ),
                    ),
                    labelStyle: TextStyle(color: player.getSideColor(context)),
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).hintColor,
                    ),
                    labelText: AppLocalizations.of(context)!.profilePicture,
                  ),
                ),
              ),
            if (player.gameStatsList!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 20,
                ),
                child: Column(
                  // MamEntry : For testing purpose
                  children: player.gameStatsList!
                      .asMap()
                      .map(
                        (i, stat) => MapEntry(
                          i,
                          Row(
                            key: ValueKey('stat-$i-${stat.gameType.name}'),
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 100,
                                child: Text(
                                  '${stat.gameType.name} : ',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(FontAwesomeIcons.trophy, size: 15),
                              ),
                              Text(
                                ' ${stat.wonGames}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Text(' - ', style: TextStyle(fontSize: 20)),
                              Text(
                                '${stat.playedGames} ',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(FontAwesomeIcons.gamepad, size: 15),
                              ),
                            ],
                          ),
                        ),
                      )
                      .values
                      .toList()
                      .cast<Widget>(),
                ),
              )
            else if (!isNewPlayer)
              Text(
                AppLocalizations.of(context)!.noStatisticYet,
                key: const ValueKey('noStatsText'),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      actions: <Widget>[
        if (player.owned)
          ElevatedButton.icon(
            key: const ValueKey('saveButton'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                player.getSideColor(context),
              ),
              foregroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).cardColor,
              ),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    CustomProperties.borderRadius,
                  ),
                ),
              ),
            ),
            onPressed: () async => await _savePlayer(context),
            label: Text(MaterialLocalizations.of(context).saveButtonLabel),
            icon: const Icon(Icons.check),
          )
        else
          ElevatedButton.icon(
            key: const ValueKey('closeButton'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              foregroundColor: WidgetStateProperty.all<Color>(
                player.getSideColor(context),
              ),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    CustomProperties.borderRadius,
                  ),
                ),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: Text(MaterialLocalizations.of(context).closeButtonLabel),
          ),
      ],
      scrollable: true,
    );
  }
}
