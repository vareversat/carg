import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/services/game/coinche_belote_service.dart';
import 'package:carg/services/game/contree_belote_service.dart';
import 'package:carg/services/game/french_belote_service.dart';
import 'package:carg/services/game/tarot_game_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/game_mode_picker_screen.dart';
import 'package:carg/views/tabs/game_list_tab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameListScreen extends StatelessWidget {
  const GameListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Hero(
                  tag: 'game_screen_title',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Parties',
                          style: CustomTextStyle.screenHeadLine1(context)),
                      ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).cardColor),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          CustomProperties.borderRadius)))),
                          onPressed: () async => Navigator.push(
                                context,
                                CustomRouteFade(
                                  builder: (context) =>
                                      const GameModePickerScreen(),
                                ),
                              ),
                          label: const Text(
                            'Nouvelle partie',
                          ),
                          icon: const FaIcon(FontAwesomeIcons.plusCircle,
                              size: 15))
                    ],
                  ),
                ),
                bottom: TabBar(
                  indicatorWeight: 4,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                        child: Text(GameType.COINCHE.name,
                            style: const TextStyle(fontSize: 15))),
                    Tab(
                        child: Text(GameType.BELOTE.name,
                            style: const TextStyle(fontSize: 15))),
                    Tab(
                        child: Text(GameType.CONTREE.name,
                            style: const TextStyle(fontSize: 15))),
                    Tab(
                        child: Text(GameType.TAROT.name,
                            style: const TextStyle(fontSize: 15)))
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                GameListTabWidget(gameService: CoincheBeloteService()),
                GameListTabWidget(gameService: FrenchBeloteService()),
                GameListTabWidget(gameService: ContreeBeloteService()),
                GameListTabWidget(gameService: TarotGameService())
              ],
            )));
  }
}
