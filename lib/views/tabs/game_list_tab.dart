import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/views/widgets/belote_game_widget.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/tarot_game_widget.dart';
import 'package:flutter/material.dart';

class GameListWidget extends StatefulWidget {
  final Future<List<Game>>? gamesFuture;

  GameListWidget({this.gamesFuture});

  @override
  State<StatefulWidget> createState() {
    return _GameListWidgetState(gamesFuture);
  }
}

class _GameListWidgetState extends State<GameListWidget> {
  final Future<List<Game>>? _gamesFuture;
  String? _errorMessage;

  _GameListWidgetState(this._gamesFuture);

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
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.data![0].getGameTypeName() !=
                    GameType.TAROT.name) {
                  return BeloteWidget(
                    beloteGame: snapshot.data![index] as Belote,
                  );
                } else {
                  return TarotGameWidget(
                      tarotGame: snapshot.data![index] as Tarot);
                }
              });
        }
        return Container();
      },
      future: _gamesFuture!
          // ignore: return_of_invalid_type_from_catch_error
          .catchError((onError) => {_errorMessage = onError.toString()}),
    );
  }
}
