import 'package:carg/models/game/game.dart';
import 'package:carg/models/players/players.dart';

class FakeGame extends Game {
  FakeGame(String? id, DateTime startingDate, Players players)
      : super(players: players, id: id, startingDate: startingDate);
}
