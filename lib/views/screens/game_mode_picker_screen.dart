import 'package:carg/helpers/custom_route.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/game_settings_screen.dart';
import 'package:flutter/material.dart';

class GameModePickerScreen extends StatelessWidget {
  const GameModePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: Hero(
            tag: 'game_screen_title',
            child: Text(
              AppLocalizations.of(context)!.newGame,
              style: CustomTextStyle.screenHeadLine1(context),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.gameSelection,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    _GameModeButton(game: CoincheBelote()),
                    _GameModeButton(game: FrenchBelote()),
                    _GameModeButton(game: ContreeBelote()),
                    _GameModeButton(game: Tarot()),
                    //_GameModeButton(game: TarotGame())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameModeButton extends StatelessWidget {
  final Game? game;

  const _GameModeButton({this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            foregroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.onPrimary,
            ),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
              ),
            ),
          ),
          onPressed: () => {
            Navigator.of(context).push(
              CustomRouteLeftToRight(
                builder: (context) =>
                    GameSettingsScreen(game: game, title: game!.gameType.name),
              ),
            ),
          },
          child: Text(
            game!.gameType.name,
            style: const TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
