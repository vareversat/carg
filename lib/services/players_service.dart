/*import 'package:carg/models/player/player.dart';
import 'package:carg/models/player/team_game_players.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/services/team_service.dart';
import 'package:flutter/services.dart';

class PlayersService {
  final TeamService _teamService = TeamService();
  final PlayerService _playersService = PlayerService();

  Future<TeamGamePlayers> getTeamGamePlayers(
      Map<String, dynamic> players) async {
    if (players == null) return null;
    var us = await _teamService.getTeam(players['us']);
    var them = await _teamService.getTeam(players['them']);
    var playerList = <Player>[];
    for (var playerId in players['players']) {
      try {
        playerList.add(await _playersService.getPlayer(playerId));
      } on PlatformException catch (e) {
        throw CustomException(e.message);
      }
    }
    return TeamGamePlayers(us: us.id, them: them.id, playerList: playerList);
  }
}*/
