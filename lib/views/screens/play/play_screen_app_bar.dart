import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/game_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class PlayScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Game game;

  const PlayScreenAppBar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      toolbarHeight: 80,
      actions: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () async => await showDialog(
            context: context,
            builder: (BuildContext context) => GameInfoDialog(
              game: game,
            ),
          ),
        ),
      ],
      title: Column(
        children: [
          Text(game.gameType.name,
              style: CustomTextStyle.screenHeadLine1(context)),
          Text(
            AppLocalizations.of(context)!.startedOn(
              DateFormat.yMd(Localizations.localeOf(context).languageCode)
                  .format(
                game.startingDate,
              ),
              DateFormat.jm(Localizations.localeOf(context).languageCode)
                  .format(
                game.startingDate,
              ),
            ),
            style: TextStyle(
                fontSize: 12, color: Theme.of(context).colorScheme.onPrimary),
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(color: Colors.transparent, height: 5),
          if (game.isEnded)
            Text(
              AppLocalizations.of(context)!.completedOn(
                DateFormat.yMd(Localizations.localeOf(context).languageCode)
                    .format(
                  game.endingDate!,
                ),
                DateFormat.jm(Localizations.localeOf(context).languageCode)
                    .format(
                  game.endingDate!,
                ),
              ),
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).colorScheme.onPrimary),
              overflow: TextOverflow.ellipsis,
            )
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () => Navigator.pop(context, 1),
        icon: Icon(
          Icons.cancel,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
