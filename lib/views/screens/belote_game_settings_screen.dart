import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/player_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Center(child: Text("Nombre de points à atteindre")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextField(
                          key: const ValueKey('maxPointsTextFieldValue'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40),
                          controller: _contractTextController,
                          enabled: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: const <TextInputFormatter>[],
                          onSubmitted: (String value) => {
                            print(value),
                          },
                        ),
                      ),
                      Flexible(
                        child: ElevatedButton.icon(
                          key: const ValueKey('infinitePoints'),
                          onPressed: () => {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor,
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).cardColor),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  CustomProperties.borderRadius,
                                ),
                              ),
                            ),
                          ),
                          label: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Infini",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          icon: const Icon(
                            FontAwesomeIcons.check,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child:
                      Center(child: Text("Additioner annonce et points fait")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Non",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      // This bool value toggles the switch.
                      value: true,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) {
                        print(value);
                      },
                    ),
                    const Text(
                      "Oui",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Exemple : L'attaque annonce 110 points. Elle remporte en faisant un total de 125.\n "
                    "L'attaque marque donc 125 + 110 = 235 et la défence 160 - 125 = 35",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                ),
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
