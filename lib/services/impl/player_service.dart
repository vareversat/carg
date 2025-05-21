import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/helpers/algolia_helper.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/player.dart';
import 'package:carg/repositories/impl/player_repository.dart';
import 'package:carg/repositories/player/abstract_player_repository.dart';
import 'package:carg/services/player/abstract_player_service.dart';

class PlayerService extends AbstractPlayerService {
  PlayerService({AbstractPlayerRepository? playerRepository})
    : super(playerRepository: playerRepository ?? PlayerRepository());

  @override
  Future<String> create(Player? t) async {
    if (t == null || t.userName == '') {
      throw ServiceException('Please set a non empty username');
    }
    var id = await playerRepository.create(t);
    return id;
  }

  @override
  Future<void> incrementPlayedGamesByOne(String? playerId, Game? game) async {
    if (playerId == null || game == null) {
      throw ServiceException('Please use a non null team id and game object');
    }
    try {
      var player = await playerRepository.get(playerId);
      if (player == null) {
        throw ServiceException(
          'The player you are trying to modify does not exist',
        );
      }
      player.incrementPlayedGamesByOne(game);
      await playerRepository.update(player);
    } on RepositoryException catch (e) {
      throw throw ServiceException(
        'Impossible to modify the player $playerId : ${e.message}',
      );
    }
  }

  @override
  Future<void> incrementWonGamesByOne(String? playerId, Game? game) async {
    if (playerId == null || game == null) {
      throw ServiceException('Please use a non null team id and game object');
    }
    try {
      var player = await playerRepository.get(playerId);
      if (player == null) {
        throw ServiceException(
          'The player you are trying to modify does not exist',
        );
      }
      player.incrementWonGamesByOne(game);
      await playerRepository.update(player);
    } on RepositoryException catch (e) {
      throw ServiceException(
        'Impossible to modify the player $playerId : ${e.message}',
      );
    }
  }

  @override
  Future<Player?> getPlayerOfUser(String? userId) async {
    if (userId == null) {
      throw ServiceException('Please provide an user ID');
    }
    try {
      return playerRepository.getPlayerOfUser(userId);
    } on RepositoryException catch (e) {
      throw ServiceException(
        'Impossible to get the player of the user $userId : ${e.message}',
      );
    }
  }

  @override
  Future<List<Player>> searchPlayers({
    String query = '',
    Player? currentPlayer,
    bool? myPlayers,
  }) async {
    var algoliaHelper = await AlgoliaHelper.create();
    if (currentPlayer == null) {
      throw throw ServiceException(
        'You have to specify the current user to search into the index',
      );
    }
    try {
      var players = <Player>[];
      var snapshot = await algoliaHelper.filter(
        query: query,
        currentPlayer: currentPlayer,
        myPlayers: myPlayers,
      );
      for (var doc in snapshot) {
        players.add(Player.fromJSON(doc, doc['objectID']));
      }
      return players;
    } on Exception catch (e) {
      throw ServiceException('Error during the index search : ${e.toString()}');
    }
  }
}
