import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:carg/views/screens/game_list_screen.dart';
import 'package:carg/views/screens/player_list_screen.dart';
import 'package:carg/views/screens/user_screen.dart';
import 'package:carg/views/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final int requestedIndex;

  const HomeScreen({super.key, required this.requestedIndex});

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _HomeScreenState(requestedIndex);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex;
  final List<Widget> _children = [
    const UserScreen(),
    const GameListScreen(),
    PlayerListScreen(
        teamService: TeamService(), playerService: PlayerService()),
  ];

  _HomeScreenState(this._currentIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: NavBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.decelerate,
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.account_circle),
            title: Text(AppLocalizations.of(context)!.profileTitle),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(FontAwesomeIcons.gamepad),
            title: Text(AppLocalizations.of(context)!.games),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.people),
            title: Text(AppLocalizations.of(context)!.player(2)),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
