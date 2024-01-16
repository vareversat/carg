import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/services/impl/game/coinche_belote_game_service.dart';
import 'package:carg/services/impl/game/contree_belote_game_service.dart';
import 'package:carg/services/impl/game/french_belote_game_service.dart';
import 'package:carg/services/impl/game/tarot_game_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/game_mode_picker_screen.dart';
import 'package:carg/views/tabs/game_list_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameListScreen extends StatelessWidget {
  const GameListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                automaticallyImplyLeading: false,
                title: Hero(
                  tag: 'game_screen_title',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.games,
                        style: CustomTextStyle.screenHeadLine1(
                          context,
                        ),
                      ),
                      FilledButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).cardColor),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                CustomProperties.borderRadius,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () async => Navigator.push(
                          context,
                          CustomRouteFade(
                            builder: (context) => const GameModePickerScreen(),
                          ),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.circlePlus,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                ),
                bottom: TabBar(
                  indicatorWeight: 4,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      child: Text(
                        GameType.COINCHE.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        GameType.BELOTE.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        GameType.CONTREE.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        GameType.TAROT.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                GameListTabWidget(gameService: CoincheBeloteGameService()),
                GameListTabWidget(gameService: FrenchBeloteGameService()),
                GameListTabWidget(gameService: ContreeBeloteGameService()),
                GameListTabWidget(gameService: TarotGameService())
              ],
            )));
  }
}
