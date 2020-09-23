import 'package:carg/environment_config.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/firebase_exception.dart';
import 'package:carg/services/player_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class TeamService {
  final String flavor = EnvironmentConfig.flavor;
  final PlayerService _playerService = PlayerService();

  Future<Team> getTeamByPlayers(List<String> playerIds) async {
    try {
      playerIds.sort();
      var querySnapshot = await Firestore.instance
          .collection('team-' + flavor)
          .reference()
          .where('players', isEqualTo: playerIds)
          .getDocuments();
      if (querySnapshot.documents.isNotEmpty) {
        await querySnapshot.documents[0].reference.updateData({
          'played_games': querySnapshot.documents[0].data['played_games'] + 1
        });
        return Team.fromJSON(querySnapshot.documents.first.data,
            querySnapshot.documents.first.documentID);
      } else {
        var team = Team(players: playerIds);
        var documentReference =
            await Firestore.instance.collection('team-' + flavor).add(team.toJSON());
        team.id = documentReference.documentID;
        return team;
      }
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future<Team> getTeam(String id) async {
    try {
      var querySnapshot =
      await Firestore.instance.collection('team-' + flavor).document(id).get();
      return Team.fromJSON(querySnapshot.data, querySnapshot.documentID);
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future<Team> incrementWonGamesByOne(String id) async {
    try {
      var team = await getTeam(id);
      await Firestore.instance
          .collection('team-' + flavor)
          .document(id)
          .updateData({'won_games': team.wonGames + 1});
      for (var player in team.players) {
        await _playerService.incrementWonGamesByOne(player);
      }
      return team;
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }
}
