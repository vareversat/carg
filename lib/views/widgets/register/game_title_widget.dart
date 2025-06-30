import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/game/game.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameTitleWidget extends StatelessWidget {
  final Game? game;

  const GameTitleWidget({super.key, this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              DateFormat.yMMMMd(
                Localizations.localeOf(context).languageCode,
              ).format(game!.startingDate),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80.0),
              child: Container(
                color: game!.isEnded
                    ? Theme.of(context).colorScheme.tertiaryContainer
                    : Theme.of(context).colorScheme.primaryContainer,
                height: 30,
                child: Center(
                  child: Text(
                    game!.isEnded
                        ? AppLocalizations.of(context)!.ended
                        : AppLocalizations.of(context)!.inProgress,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: game!.isEnded
                          ? Theme.of(context).colorScheme.onTertiaryContainer
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
