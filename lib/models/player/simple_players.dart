import 'package:carg/models/player/player.dart';
import 'package:carg/models/player/players.dart';

class SimplePlayers extends Players {
  final List<Player> players;
  final List<Player> _selectedPlayers = [];
  int _selectionLimit;

  SimplePlayers(this.players) {
    _selectionLimit = players.length < 5 ? 1 : 2;
  }


  @override
  void onSelectedPlayer(Player selectedPlayer) {
    if(_selectedPlayers.length < _selectionLimit && !_selectedPlayers.contains(selectedPlayer)) {
      _selectedPlayers.add(selectedPlayer);
    } else if (_selectedPlayers.contains(selectedPlayer)) {
      _selectedPlayers.remove(selectedPlayer);
    }
    for (var player in players) {
      if (_selectedPlayers.contains(player)) {
        player.selected = true;
      } else {
        player.selected = false;
      }
    }
    notifyListeners();
  }

  @override
  String getSelectedPlayersStatus() {
    throw UnimplementedError();
  }

  @override
  bool isFull() {
    throw UnimplementedError();
  }

  @override
  List<String> getPlayerIds() {
    throw UnimplementedError();
  }

  @override
  String toString() {
    throw UnimplementedError();
  }
}
