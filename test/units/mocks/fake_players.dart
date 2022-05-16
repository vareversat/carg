import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';

class FakePlayers extends Players {
  FakePlayers(List<String> players) : super(playerList: players);

  @override
  String getSelectedPlayersStatus() {
    throw UnimplementedError();
  }

  @override
  bool isFull() {
    throw UnimplementedError();
  }

  @override
  void onSelectedPlayer(Player player) {}

  @override
  void reset() {}
}
