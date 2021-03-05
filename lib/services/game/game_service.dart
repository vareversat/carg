import 'package:carg/models/game/game.dart';
import 'package:carg/models/players/players.dart';

abstract class GameService<T extends Game?, P extends Players> {
  Future<List<T>> getAllGames(String playerId);

  Future<T> getGame(String id);

  Future deleteGame(String? id);

  Future endAGame(T game);

  Future<T> createGameWithPlayerList(List<String?> playerList);
}
