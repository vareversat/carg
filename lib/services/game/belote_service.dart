import 'package:carg/models/game/team_game.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/services/game/game_service.dart';

abstract class BeloteService<T extends Belote>
    extends GameService<T, BelotePlayers> {
  @override
  Future<T> createGameWithPlayerList(List<String> playerList);
}
