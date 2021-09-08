import 'package:carg/helpers/algolia_helper.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class PlayerService {
  static const String dataBase = 'player';
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  Future<List<Player>> searchPlayers(
      {String query = '', String? playerId}) async {
    var algoliaHelper = await AlgoliaHelper.create();
    try {
      var players = <Player>[];
      var snapshot = await algoliaHelper.filter(
          filters: 'owned_by:$playerId OR owned:false', query: query);
      for (var doc in snapshot) {
        players.add(Player.fromJSON(doc, doc['objectID']));
      }
      return players;
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future incrementPlayedGamesByOne(String? id, Game game) async {
    try {
      var player = await getPlayer(id);
      game.incrementPlayerPlayedGamesByOne(player);
      await updatePlayer(player);
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future incrementWonGamesByOne(String? id, Game game) async {
    try {
      var player = await getPlayer(id);
      game.incrementPlayerWonGamesByOne(player);
      await updatePlayer(player);
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<Player> getPlayer(String? id) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .doc(id)
          .get();
      if (querySnapshot.data() != null) {
        return Player.fromJSON(querySnapshot.data(), querySnapshot.id);
      } else {
        throw CustomException('Erreur : Aucun joueur trouvé');
      }
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<Player?> getPlayerOfUser(String? userId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .where('linked_user_id', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return Player.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future updatePlayer(Player player) async {
    try {
      await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .doc(player.id)
          .update(player.toJSON());
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<String> addPlayer(Player player) async {
    try {
      if (player.userName == '' || player.userName == null) {
        throw CustomException('Veuillez renseigner un nom d\'utilisateur');
      }
      var documentReference = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .add(player.toJSON());
      return documentReference.id;
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future deletePlayer(Player player) async {
    try {
      await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .doc(player.id)
          .delete();
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
