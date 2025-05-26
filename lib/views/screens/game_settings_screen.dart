import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/setting/belote_game_setting.dart';
import 'package:carg/models/game/setting/game_setting.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/player_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class GameSettingsScreen extends StatelessWidget {
  final Game? game;
  final String title;
  final TextEditingController _contractTextController = TextEditingController();

  GameSettingsScreen({super.key, required this.game, required this.title});

  int sanitizeMaxContractValue(String value) {
    return int.tryParse(value)?.abs() ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(title, style: CustomTextStyle.screenHeadLine1(context)),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.gameSettings,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.numberOfPointToReach,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChangeNotifierProvider.value(
                    value: game?.settings,
                    child: Consumer<GameSetting>(
                      builder: (context, settingsData, child) {
                        _contractTextController.text = settingsData.maxPoint
                            .toString();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: AnimatedSize(
                                curve: Curves.ease,
                                duration: const Duration(milliseconds: 500),
                                child: Center(
                                  child: settingsData.isInfinite
                                      ? Icon(
                                          FontAwesomeIcons.infinity,
                                          color: Theme.of(context).primaryColor,
                                          size: 50,
                                        )
                                      : TextField(
                                          key: const ValueKey(
                                            'maxPointsTextFieldValue',
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 40,
                                          ),
                                          controller: _contractTextController,
                                          enabled: !settingsData.isInfinite,
                                          keyboardType: TextInputType.number,
                                          inputFormatters:
                                              const <TextInputFormatter>[],
                                          onSubmitted: (String value) => {
                                            settingsData.maxPoint =
                                                sanitizeMaxContractValue(value),
                                          },
                                        ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: ElevatedButton.icon(
                                key: const ValueKey('infinitePoints'),
                                onPressed: () => {
                                  settingsData.isInfinite =
                                      !settingsData.isInfinite,
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                        settingsData.isInfinite
                                            ? Theme.of(context).cardColor
                                            : Theme.of(context).primaryColor,
                                      ),
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                        settingsData.isInfinite
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).cardColor,
                                      ),
                                  shape:
                                      WidgetStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            CustomProperties.borderRadius,
                                          ),
                                          side: BorderSide(
                                            color: settingsData.isInfinite
                                                ? Theme.of(context).primaryColor
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                ),
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.infinite,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                icon: settingsData.isInfinite
                                    ? const Icon(
                                        Icons.cancel_outlined,
                                        size: 20,
                                      )
                                    : const Icon(
                                        FontAwesomeIcons.check,
                                        size: 20,
                                      ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                (game is Belote && game is! FrenchBelote)
                    ? Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.sumTrickPointsAndContract,
                              ),
                            ),
                          ),
                          ChangeNotifierProvider.value(
                            value: (game?.settings as BeloteGameSetting),
                            child: Consumer<BeloteGameSetting>(
                              builder: (context, settingsData, child) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 120,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.no,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Switch(
                                            value: settingsData
                                                .sumTrickPointsAndContract,
                                            activeColor: Theme.of(
                                              context,
                                            ).primaryColor,
                                            onChanged: (bool value) {
                                              settingsData
                                                      .sumTrickPointsAndContract =
                                                  value;
                                            },
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.yes,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Text(
                                        settingsData.sumTrickPointsAndContract
                                            ? AppLocalizations.of(
                                                context,
                                              )!.sumTrickPointsAndContractYesExample
                                            : AppLocalizations.of(
                                                context,
                                              )!.sumTrickPointsAndContractNoExample,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
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
                onPressed: () async => {
                  Navigator.of(context).push(
                    CustomRouteLeftToRight(
                      builder: (context) => PlayerPickerScreen(
                        game: game,
                        title: game!.gameType.name,
                      ),
                    ),
                  ),
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.playerSelection,
                      style: const TextStyle(fontSize: 23),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_right_alt_outlined, size: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
