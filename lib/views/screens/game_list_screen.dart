import 'package:carg/helpers/custom_route.dart';
import 'package:carg/services/game/belote_game_service.dart';
import 'package:carg/services/game/coinche_game_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/game_mode_picker_screen.dart';
import 'package:carg/views/tabs/game_list_tab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameListScreen extends StatelessWidget {
  final BeloteGameService _beloteGameService = BeloteGameService();
  final CoincheGameService _coincheGameService = CoincheGameService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Parties',
                        style: CustomTextStyle.screenHeadLine1(context)),
                    RaisedButton.icon(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        onPressed: () async => Navigator.push(
                              context,
                              CustomRouteLeftAndRight(
                                builder: (context) => GameModePickerScreen(),
                              ),
                            ),
                        label: Text('Nouvelle partie',
                            style: TextStyle(fontSize: 14)),
                        icon: FaIcon(
                          FontAwesomeIcons.plusCircle,
                          size: 15,
                        ))
                  ],
                ),
                bottom: TabBar(
                  indicatorWeight: 4,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                        child: Text(
                      'Coinche',
                      style: TextStyle(fontSize: 15),
                    )),
                    Tab(
                        child: Text(
                      'Belote',
                      style: TextStyle(fontSize: 15),
                    ))
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                GameListWidget(
                  gamesFuture: _coincheGameService.getAllGames(),
                ),
                GameListWidget(
                  gamesFuture: _beloteGameService.getAllGames(),
                )
              ],
            )));
  }
}
