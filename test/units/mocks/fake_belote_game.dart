import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/setting/belote_game_setting.dart';
import 'package:carg/models/players/belote_players.dart';

class FakeBeloteGame extends Belote {
  FakeBeloteGame(String? id, DateTime startingDate, BelotePlayers players,
      BeloteGameSetting settings)
      : super(
            players: players,
            id: id,
            startingDate: startingDate,
            settings: settings);
}
