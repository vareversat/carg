import 'dart:convert';

import 'package:algolia/algolia.dart';
import 'package:carg/models/player/player.dart';
import 'package:carg/services/firebase_exception.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

class PlayerService {
  Future<List<Player>> getAllPlayers({String query = ''}) async {
    final algoliaConfig = jsonDecode(await rootBundle.loadString(
      'assets/config/algolia.json',
    ));
    var algolia = Algolia.init(
        applicationId: algoliaConfig['app_id'],
        apiKey: algoliaConfig['api_key']);
    var algoliaQuery = algolia.instance.index('players').search(query);
    try {
      var players = <Player>[];
      var snapshot = await algoliaQuery.getObjects();
      for (var doc in snapshot.hits) {
        players.add(Player.fromJSON(doc.data, doc.objectID));
      }
      return players;
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future incrementPlayedGamesByOne(Player player) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('player')
          .child(player.id)
          .child('played_games')
          .runTransaction((MutableData mutableData) async {
        mutableData.value = (mutableData.value ?? 0) + 1;
        return mutableData;
      });
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future incrementWonGamesByOne(String id) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('player')
          .child(id)
          .child('won_games')
          .runTransaction((MutableData mutableData) async {
        mutableData.value = (mutableData.value ?? 0) + 1;
        return mutableData;
      });
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future<Player> getPlayer(String id) async {
    try {
      var querySnapshot = await FirebaseDatabase.instance
          .reference()
          .child('player')
          .child(id)
          .once();
      return Player.fromJSON(querySnapshot.value, querySnapshot.key);
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future<Player> getPlayerOfUser(String userId) async {
    try {
      var querySnapshot = await FirebaseDatabase.instance
          .reference()
          .child('player')
          .orderByChild('linked_user_id')
          .equalTo(userId)
          .once();
      if (querySnapshot.value != null) {
        var map = querySnapshot.value as Map;
        return Player.fromJSON(map.values.first, map.keys.first);
      }
      return null;
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future updatePlayer(Player player) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('player')
          .child(player.id)
          .update(player.toJSON());
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future<void> addPlayer(Player player) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('player')
          .push()..set(player.toJSON());
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future<void> deletePlayer(Player player) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('player')
          .child(player.id)
          .remove();
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }
}
