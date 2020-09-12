import 'package:carg/models/player/player.dart';
import 'package:carg/models/player/players.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';

class TeamGamePlayers extends Players {
  final List<Player> _us = [];
  final List<Player> _them = [];

  List<Player> get us => _us;
  List<Player> get them => _them;

  TeamGamePlayers();

  @override
  void onSelectedPlayer(Player player) {
    if (!_isFull(TeamGameEnum.US)) {
      if (!_contains(player, TeamGameEnum.US) &&
          !_contains(player, TeamGameEnum.THEM)) {
        _add(player, TeamGameEnum.US);
      } else {
        _remove(player, TeamGameEnum.US);
      }
    } else if (_isFull(TeamGameEnum.US) && _contains(player, TeamGameEnum.US)) {
      _remove(player, TeamGameEnum.US);
    } else if (!_isFull(TeamGameEnum.THEM)) {
      if (!_contains(player, TeamGameEnum.US) &&
          !_contains(player, TeamGameEnum.THEM)) {
        _add(player, TeamGameEnum.THEM);
      } else {
        _remove(player, TeamGameEnum.THEM);
      }
    } else if (_isFull(TeamGameEnum.THEM) &&
        _contains(player, TeamGameEnum.THEM)) {
      _remove(player, TeamGameEnum.THEM);
    }
  }

  @override
  List<String> getPlayerIds() {
    var playerIds = _us.map((e) => e.id);
    playerIds.toList().addAll(_them.map((e) => e.id));
    return playerIds;
  }

  void _add(Player player, TeamGameEnum teamGameEnum) {
    player.selected = true;
    switch (teamGameEnum) {
      case TeamGameEnum.US:
        _us.add(player);
        notifyListeners();
        break;
      case TeamGameEnum.THEM:
        _them.add(player);
        notifyListeners();
        break;
    }
  }

  void _remove(Player player, TeamGameEnum teamGameEnum) {
    player.selected = false;
    switch (teamGameEnum) {
      case TeamGameEnum.US:
        _us.remove(player);
        notifyListeners();
        break;
      case TeamGameEnum.THEM:
        _them.remove(player);
        notifyListeners();
        break;
    }
  }

  bool _contains(Player player, TeamGameEnum teamGameEnum) {
    switch (teamGameEnum) {
      case TeamGameEnum.US:
        return _us.contains(player);
        break;
      case TeamGameEnum.THEM:
        return _them.contains(player);
      default:
        return false;
    }
  }

  bool _isFull(TeamGameEnum teamGameEnum) {
    switch (teamGameEnum) {
      case TeamGameEnum.US:
        return _us.length == 2;
        break;
      case TeamGameEnum.THEM:
        return _them.length == 2;
      default:
        return false;
    }
  }

  @override
  String getSelectedPlayersStatus() {
    return 'Nous ' +
        _us.length.toString() +
        '/2 - ' +
        'Eux ' +
        _them.length.toString() +
        '/2';
  }

  @override
  bool isFull() {
    return _us.length == 2 && _them.length == 2;
  }

  @override
  String toString() {
    return 'TeamGamePlayers{_us: $_us, _them: $_them}';
  }
}
