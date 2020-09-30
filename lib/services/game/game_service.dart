import 'package:carg/models/game/game.dart';
import 'package:carg/models/player/players.dart';

abstract class GameService<T extends Game, P extends Players> {
  Future<List<T>> getAllGames();

  Future<T> getGame(String id);

  Future deleteGame(String id);

  Future endAGame(T game);

  Future<T> createGameWithPlayers(P players);
}
