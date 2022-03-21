import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/helpers/algolia_helper.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/player.dart';
import 'package:carg/repositories/impl/player_repository.dart';
import 'package:carg/services/abstract_player_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerService extends AbstractPlayerService {
  PlayerService() : super(playerRepository: PlayerRepository());

  @override
  Future<String> create(Player? t) {
    throw UnimplementedError('Please use "createPlayer" instead');
  }

  @override
  Future<String> createPlayer(Player player) async {
    if (player.userName == '') {
      throw ServiceException('Please set a non empty username');
    }
    return playerRepository.create(player);
  }

  @override
  Future<void> incrementPlayedGamesByOne(String playerId, Game game) async {
    try {
      var player = await playerRepository.get(playerId);
      if (player == null) {
        throw ServiceException(
            'The player you are trying to modify does not exist');
      }
      game.incrementPlayerPlayedGamesByOne(player);
      await playerRepository.update(player);
    } on FirebaseException catch (e) {
      throw throw ServiceException(
          'Impossible to modify the player $playerId : ${e.message}');
    }
  }

  @override
  Future<void> incrementWonGamesByOne(String playerId, Game game) async {
    try {
      var player = await playerRepository.get(playerId);
      if (player == null) {
        throw ServiceException(
            'The player you are trying to modify does not exist');
      }
      game.incrementPlayerWonGamesByOne(player);
      await playerRepository.update(player);
    } on FirebaseException catch (e) {
      throw ServiceException(
          'Impossible to modify the player $playerId : ${e.message}');
    }
  }

  @override
  Future<Player?> getPlayerOfUser(String? userId) async {
    if (userId == null) {
      throw ServiceException(
          'Please provide an user ID');
    }
    try {
      return playerRepository.getPlayerOfUser(userId);
    } on FirebaseException catch (e) {
      throw ServiceException(
          'Impossible to get the player of the user $userId : ${e.message}');
    }
  }

  @override
  Future<List<Player>> searchPlayers(
      {String query = '', Player? currentPlayer}) async {
    var algoliaHelper = await AlgoliaHelper.create();
    if (currentPlayer == null) {
      throw throw ServiceException(
          'You have to specify the current user to search into the index');
    }
    try {
      var players = <Player>[];
      var snapshot = await algoliaHelper.filter(
          query: query, currentPlayer: currentPlayer);
      for (var doc in snapshot) {
        players.add(Player.fromJSON(doc, doc['objectID']));
      }
      return players;
    } on Exception catch (e) {
      throw ServiceException('Error during the index search : ${e.toString()}');
    }
  }
}
