import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/styles/custom_text_style.dart';
import 'package:carg/views/screens/rules_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class PlayScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Game game;

  const PlayScreenAppBar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return AppBar(
      toolbarHeight: 80,
      actions: [
        IconButton(
          icon: const Icon(Icons.help),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RulesScreen(gameType: game.gameType),
            ),
          ),
        ),
      ],
      title: Column(
        children: [
          Text(
            game.gameType.name,
            style: CustomTextStyle.screenDisplayLarge(
              context,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.startedOn(
              DateFormat.yMd(
                languageCode,
              ).format(game.startingDate),
              DateFormat.jm(
                languageCode,
              ).format(
                game.startingDate,
              ),
            ),
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(color: Colors.transparent, height: 5),
          if (game.isEnded)
            Text(
              AppLocalizations.of(context)!.completedOn(
                DateFormat.yMd(
                  languageCode,
                ).format(game.endingDate!),
                DateFormat.jm(
                  languageCode,
                ).format(
                  game.endingDate!,
                ),
              ),
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () => Navigator.pop(context, 1),
        icon: const Icon(
          Icons.cancel,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
