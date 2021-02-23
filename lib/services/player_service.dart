import 'dart:convert';

import 'package:algolia/algolia.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class PlayerService {
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  Future<List<Player>> getAllPlayers({String query = ''}) async {
    final algoliaConfig = jsonDecode(await rootBundle.loadString(
      'assets/config/algolia.json',
    ));
    var algolia = Algolia.init(
        applicationId: algoliaConfig['app_id'],
        apiKey: algoliaConfig['api_key']);
    var algoliaQuery = algolia.instance.index('player_' + flavor).search(query);
    try {
      var players = <Player>[];
      var snapshot = await algoliaQuery.getObjects();
      for (var doc in snapshot.hits) {
        players.add(Player.fromJSON(doc.data, doc.objectID));
      }
      return players;
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  Future incrementPlayedGamesByOne(String id, Game game) async {
    try {
      var player = await getPlayer(id);
      game.incrementPlayerPlayedGamesByOne(player);
      await updatePlayer(player);
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  Future incrementWonGamesByOne(String id, Game game) async {
    try {
      var player = await getPlayer(id);
      game.incrementPlayerWonGamesByOne(player);
      await updatePlayer(player);
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  Future<Player> getPlayer(String id) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('player-' + flavor)
          .doc(id)
          .get();
      if (querySnapshot.data() != null) {
      return Player.fromJSON(querySnapshot.data(), querySnapshot.id);
      } else {
        throw CustomException('unknown_user');
      }
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  Future<Player> getPlayerOfUser(String userId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('player-' + flavor)
          .where('linked_user_id', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return Player.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  Future updatePlayer(Player player) async {
    try {
      await FirebaseFirestore.instance
          .collection('player-' + flavor)
          .doc(player.id)
          .update(player.toJSON());
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  Future<String> addPlayer(Player player) async {
    try {
      var documentReference = await FirebaseFirestore.instance
          .collection('player-' + flavor)
          .add(player.toJSON());
      return documentReference.id;
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  Future deletePlayer(Player player) async {
    try {
      await FirebaseFirestore.instance
          .collection('player-' + flavor)
          .doc(player.id)
          .delete();
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }
}
