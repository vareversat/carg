import 'package:carg/models/team.dart';
import 'package:carg/services/firebase_exception.dart';
import 'package:carg/services/player_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

class TeamService {
  final PlayerService _playerService = PlayerService();

  Future<Team> getTeamByPlayers(List<String> playerIds) async {
    try {
      var dbRef = FirebaseDatabase.instance.reference().child('team');
      playerIds.sort();
      var querySnapshot = await dbRef
          .child('players')
          .reference()
          .equalTo(playerIds.toString())
          .once();
      if (querySnapshot.value != null) {
        print(querySnapshot.value);
        var map = querySnapshot.value as Map;
        await dbRef
            .child(map.keys.first)
            .child('played_games')
            .runTransaction((mutableData) async {
          mutableData.value = (mutableData.value ?? 0) + 1;
          return mutableData;
        });
        return Team.fromJSON(map.values.first, map.keys.first);
      } else {
        var team = Team(players: playerIds);
        var documentReference = await dbRef.push();
        await dbRef.child(documentReference.key).set(team.toJSON());
        team.id = documentReference.key;
        return team;
      }
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future<Team> getTeam(String id) async {
    try {
      var querySnapshot = await FirebaseDatabase.instance
          .reference()
          .child('team')
          .child(id)
          .once();
      if (querySnapshot.value != null) {
        return Team.fromJSON(querySnapshot.value, querySnapshot.key);
      }
      return null;
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future<Team> incrementWonGamesByOne(String id) async {
    try {
      var team = await getTeam(id);
      team.wonGames += 1;
      await FirebaseDatabase.instance
          .reference()
          .child('team')
          .child(id)
          .update(team.toJSON());
      for (var player in team.players) {
        await _playerService.incrementWonGamesByOne(player);
      }
      return team;
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }
}
