import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/games.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/players/players.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/views/widgets/belote_game_widget.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/tarot_game_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameListWidget extends StatefulWidget {
  final GameType gameType;

  GameListWidget({required this.gameType});

  @override
  State<StatefulWidget> createState() {
    return _GameListWidgetState(gameType);
  }
}

class _GameListWidgetState extends State<GameListWidget> {
  final GameType _gameType;
  final Games _games = Games();
  final ScrollController _scrollController = ScrollController();
  String _errorMessage = '';

  _GameListWidgetState(this._gameType) {
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      var currentScroll = _scrollController.position.pixels;
      print('maxScroll : $maxScroll');
      print('currentScroll : $currentScroll');
      print('direction: ${_scrollController.position.userScrollDirection}');
      print(_scrollController.offset);
    });
  }

  Future<void> _getGames() async {
    _games.gameList = await _gameType.gameService.getAllGames(
        Provider.of<AuthService>(context, listen: false).getPlayerIdOfUser()!);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Game>>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.data == null) {
            return ErrorMessageWidget(message: _errorMessage);
          }
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Pas encore de parties ',
                        style: TextStyle(fontSize: 18)),
                    Icon(Icons.games),
                    Text(' enregistrées', style: TextStyle(fontSize: 18))
                  ]),
            );
          }
          if (snapshot.hasData) {
            _games.gameList = snapshot.data!;
            return RefreshIndicator(
              // notificationPredicate: (ScrollNotification scrollInfo) {
              //   var maxScroll = scrollInfo.metrics.maxScrollExtent;
              //   var currentScroll =scrollInfo.metrics.pixels;
              //   print('maxScroll : $maxScroll');
              //   print('currentScroll : $currentScroll');
              //   print('direction : ${scrollInfo.metrics.atEdge.toString()}');
              //   return true;
              // },
              backgroundColor: Theme.of(context).primaryColor,
              color: Theme.of(context).cardColor,
              displacement: 20,
              strokeWidth: 3,
              onRefresh: () => _getGames(),
              child: ChangeNotifierProvider.value(
                  value: _games,
                  child: Consumer<Games>(
                    builder: (context, gamesData, _) => Scrollbar(
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: gamesData.gameList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (gamesData.gameList[0]!.getGameTypeName() !=
                                GameType.TAROT.name) {
                              return BeloteWidget(
                                beloteGame: gamesData.gameList[index] as Belote,
                              );
                            } else {
                              return TarotGameWidget(
                                  tarotGame:
                                      gamesData.gameList[index] as Tarot);
                            }
                          }),
                    ),
                  )),
            );
          }
          return Container();
        },
        future: _gameType.gameService
                .getAllGames(Provider.of<AuthService>(context, listen: false)
                    .getPlayerIdOfUser()!)
                .catchError((error) =>
                    // ignore: return_of_invalid_type_from_catch_error
                    _errorMessage = (error as CustomException).message)
            as Future<List<Game<Players>>>);
  }
}
