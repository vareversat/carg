import 'package:carg/views/screens/game_list_screen.dart';
import 'package:carg/views/screens/player_list_screen.dart';
import 'package:carg/views/screens/user_screen.dart';
import 'package:carg/views/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    UserScreen(),
    GameListScreen(),
    PlayerListScreen(),
  ];

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
            icon: Icon(Icons.account_circle),
            title: Text('Moi'),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.games),
            title: Text('Parties'),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.people),
            title: Text('Joueurs'),
            activeColor: Theme.of(context).primaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
