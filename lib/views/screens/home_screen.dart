import 'package:carg/services/player_service.dart';
import 'package:carg/views/screens/game_list_screen.dart';
import 'package:carg/views/screens/player_list_screen.dart';
import 'package:carg/views/screens/user_screen.dart';
import 'package:carg/views/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final int requestedIndex;

  const HomeScreen({Key? key, required this.requestedIndex}) : super(key: key);

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
    PlayerListScreen(playerService: PlayerService(), textEditingController: TextEditingController()),
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
            title: const Text('Profil'),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(FontAwesomeIcons.gamepad),
            title: const Text('Parties'),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.people),
            title: const Text('Joueurs'),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
