import 'package:carg/models/game/game.dart';
import 'package:carg/models/players/players.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class GameService<T extends Game, P extends Players> {
  DocumentSnapshot? lastFetchGameDocument;

  Future<List<T>> getAllGamesOfPlayerPaginated(String? playerId, int pageSize);

  Future<T> getGame(String id);

  Future deleteGame(String? id);

  Future endAGame(T game);

  Future<T> createGameWithPlayerList(List<String?> playerList);

  Future updateGame(T game);
}
