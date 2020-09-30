import 'package:carg/models/game/team_game.dart';
import 'package:carg/models/player/team_game_players.dart';
import 'package:carg/services/game/game_service.dart';

abstract class TeamGameService<T extends TeamGame>
    extends GameService<T, TeamGamePlayers> {
  @override
  Future<T> createGameWithPlayers(TeamGamePlayers players);
}
