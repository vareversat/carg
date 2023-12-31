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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BeloteGameSettingsScreen extends StatelessWidget {
  final Game? game;
  final String title;
  final TextEditingController _contractTextController = TextEditingController();

  BeloteGameSettingsScreen({super.key, required this.game, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
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
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                      _contractTextController.text =
                          settingsData.maxPoint.toString();
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
                                            'maxPointsTextFieldValue'),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 40),
                                        controller: _contractTextController,
                                        enabled: !settingsData.isInfinite,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: const <
                                            TextInputFormatter>[],
                                        onSubmitted: (String value) => {
                                          settingsData.maxPoint =
                                              int.parse(value),
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
                                    !settingsData.isInfinite
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  settingsData.isInfinite
                                      ? Theme.of(context).cardColor
                                      : Theme.of(context).primaryColor,
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  settingsData.isInfinite
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).cardColor,
                                ),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
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
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
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
                    }),
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
                                AppLocalizations.of(context)!
                                    .addAnnouncementAndPointDone,
                              ),
                            ),
                          ),
                          ChangeNotifierProvider.value(
                            value: (game?.settings as BeloteGameSetting),
                            child: Consumer<BeloteGameSetting>(
                                builder: (context, settingsData, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Non",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Switch(
                                    value: settingsData.addContractToScore,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (bool value) {
                                      settingsData.addContractToScore = value;
                                    },
                                  ),
                                  const Text(
                                    "Oui",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              );
                            }),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "Exemple : L'attaque annonce 110 points. Elle remporte en faisant un total de 125.\n "
                              "L'attaque marque donc 130 + 110 = 240 et la défense 40",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                              ),
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
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor,
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).cardColor,
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
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
                            game: game, title: game!.gameType.name),
                      ),
                    )
                  },
                  label: Text(
                    AppLocalizations.of(context)!.playerSelection,
                    style: const TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_right_alt,
                    size: 30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
