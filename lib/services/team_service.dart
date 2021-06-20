import 'package:carg/models/game/game.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/player_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class TeamService {
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  final PlayerService _playerService = PlayerService();

  Future<Team> getTeamByPlayers(List<String?> playerIds) async {
    try {
      playerIds.sort();
      var querySnapshot = await FirebaseFirestore.instance
          .collection('team-' + flavor)
          .where('players', isEqualTo: playerIds)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs[0].reference.update(
            {'played_games': querySnapshot.docs[0].data()['played_games'] + 1});
        return Team.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      } else {
        var team = Team(players: playerIds);
        var documentReference = await FirebaseFirestore.instance
            .collection('team-' + flavor)
            .add(team.toJSON());
        team.id = documentReference.id;
        return team;
      }
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<Team> getTeam(String? id) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('team-' + flavor)
          .doc(id)
          .get();
      if (querySnapshot.data() != null) {
        return Team.fromJSON(querySnapshot.data(), querySnapshot.id);
      } else {
        throw CustomException('unknown_team');
      }
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<Team> incrementPlayedGamesByOne(String id, Game game) async {
    try {
      var team = await getTeam(id);
      await FirebaseFirestore.instance
          .collection('team-' + flavor)
          .doc(id)
          .update({'won_games': team.wonGames + 1});
      for (var player in team.players!) {
        await _playerService.incrementPlayedGamesByOne(player, game);
      }
      return team;
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  Future<Team> incrementWonGamesByOne(String? id, Game game) async {
    try {
      var team = await getTeam(id);
      await FirebaseFirestore.instance
          .collection('team-' + flavor)
          .doc(id)
          .update({'won_games': team.wonGames + 1});
      for (var player in team.players!) {
        await _playerService.incrementWonGamesByOne(player, game);
      }
      return team;
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
