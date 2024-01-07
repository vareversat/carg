import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/setting/game_setting.dart';
import 'package:carg/models/players/players.dart';

class FakeGame extends Game {
  FakeGame(
      String? id, DateTime startingDate, Players players, GameSetting settings)
      : super(
            players: players,
            id: id,
            startingDate: startingDate,
            settings: settings);
}
