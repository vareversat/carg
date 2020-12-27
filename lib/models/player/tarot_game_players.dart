import 'package:carg/models/player/player.dart';
import 'package:carg/models/player/players.dart';

class TarotGamePlayers extends Players {
  final List<Player> _players = [];

  List<Player> get players => _players;

  TarotGamePlayers();

  @override
  void onSelectedPlayer(Player player) {
    if (_players.length < 5 && !_players.contains(player)) {
      player.selected = true;
      _players.add(player);
      notifyListeners();
    } else if (_players.contains(player)) {
      player.selected = false;
      _players.remove(player);
      notifyListeners();
    }
  }

  @override
  String getSelectedPlayersStatus() {
    return 'Joueurs : ' + _players.length.toString() + '/5';
  }

  @override
  bool isFull() {
    return _players.length >= 3;
  }

  @override
  List<String> getPlayerIds() {
    return _players.map((e) => e.id).toList();
  }

  @override
  String toString() {
    return 'TarotGamePlayers{_players: $_players}';
  }
}
