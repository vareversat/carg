import 'package:carg/models/player.dart';
import 'package:carg/models/players/players.dart';

class BelotePlayers extends Players {
  String us;
  String them;

  BelotePlayers({this.us, this.them, playerList})
      : super.prefilledList(playerList: playerList);

  @override
  void onSelectedPlayer(Player player) {
    if (!playerList.contains(player.id) && !isFull()) {
      _add(player);
    } else {
      _remove(player);
    }
    notifyListeners();
  }

  @override
  String getSelectedPlayersStatus() {
    return 'Nous ' +
        _usCount().toString() +
        '/2 - ' +
        'Eux ' +
        _themCount().toString() +
        '/2';
  }

  @override
  bool isFull() {
    return _size() == 4;
  }

  void _add(Player player) {
    player.selected = true;
    var nullId = playerList.indexOf(' ');
    if (nullId != -1) {
      playerList[nullId] = player.id;
    } else {
      playerList.add(player.id);
    }
  }

  void _remove(Player player) {
    player.selected = false;
    playerList[playerList.indexOf(player.id)] = ' ';
  }

  int _size() {
    var size = 0;
    playerList.forEach((element) {
      element != ' ' ? size++ : size += 0;
    });
    return size;
  }

  int _usCount() {
    var size = 0;
    playerList.sublist(0, 2).forEach((element) {
      element != ' ' ? size++ : size += 0;
    });
    return size;
  }

  int _themCount() {
    var size = 0;
    playerList.sublist(2, 4).forEach((element) {
      element != ' ' ? size++ : size += 0;
    });
    return size;
  }

  @override
  void reset() {
    playerList = [' ', ' ', ' ', ' '];
  }

  @override
  String toString() {
    return 'TeamGamePlayers{us: $us, them: $them, playerList: $playerList}';
  }

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'us': us, 'them': them});
    return tmpJSON;
  }

  factory BelotePlayers.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return BelotePlayers(
        us: json['us'], them: json['them'], playerList: json['playerList']);
  }
}
