import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/player/team_game_players.dart';
import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/firebase_exception.dart';
import 'package:carg/services/game/team_game_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/services/score/belote_score_service.dart';
import 'package:carg/services/team_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

class BeloteGameService implements TeamGameService<BeloteGame> {
  TeamService _teamService;
  PlayerService _playerService;
  BeloteScoreService _beloteScoreService;

  BeloteGameService() : super() {
    _teamService = TeamService();
    _playerService = PlayerService();
    _beloteScoreService = BeloteScoreService();
  }

  @override
  Future<List<BeloteGame>> getAllGames() async {
    try {
      var beloteGames = <BeloteGame>[];
      var querySnapshot = await FirebaseDatabase.instance
          .reference()
          .child('belote-game')
          .once();
      if (querySnapshot.value != null) {
        var map = querySnapshot.value as Map;
        for (var key in map.keys) {
          beloteGames.add(BeloteGame.fromJSON(map[key], key));
        }
      }
      return beloteGames;
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  @override
  Future<BeloteGame> getGame(String id) async {
    try {
      var querySnapshot = await FirebaseDatabase.instance
          .reference()
          .child('belote-game')
          .child(id)
          .once();
      var map = querySnapshot.value as Map;
      return BeloteGame.fromJSON(map.values.first, map.keys.first);
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  @override
  Future deleteGame(String id) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('belote-game')
          .child(id)
          .remove();
      await _beloteScoreService.deleteScoreByGame(id);
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  @override
  Future<BeloteGame> createGameWithPlayers(TeamGamePlayers players) async {
    try {
      var usTeam = await _teamService
          .getTeamByPlayers(players.us.map((e) => e.id).toList());
      var themTeam = await _teamService
          .getTeamByPlayers(players.them.map((e) => e.id).toList());
      players.us.addAll(players.them);
      players.us.forEach((player) async =>
          {await _playerService.incrementPlayedGamesByOne(player)});
      var beloteGame = BeloteGame(
          isEnded: false,
          startingDate: DateTime.now(),
          us: usTeam.id,
          them: themTeam.id);
      var documentReference = await FirebaseDatabase.instance
          .reference()
          .child('belote-game')
          .push();
      await FirebaseDatabase.instance
          .reference()
          .child('belote-game')
          .child(documentReference.key)
          .set(beloteGame.toJSON());
      beloteGame.id = documentReference.key;
      var beloteScore = BeloteScore(
          usTotalPoints: 0,
          themTotalPoints: 0,
          game: beloteGame.id,
          rounds: <BeloteRound>[]);
      await _beloteScoreService.saveScore(beloteScore);
      return beloteGame;
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  @override
  Future endAGame(BeloteGame game) async {
    try {
      Team winners;
      var score = await _beloteScoreService.getScoreByGame(game.id);
      if (score.themTotalPoints > score.usTotalPoints) {
        winners = await _teamService.incrementWonGamesByOne(game.them);
      } else if (score.themTotalPoints < score.usTotalPoints) {
        winners = await _teamService.incrementWonGamesByOne(game.us);
      }
      game.isEnded = true;
      game.endingDate = DateTime.now();
      game.winner = winners?.id;
      await _updateGame(game);
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  Future _updateGame(BeloteGame game) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('belote-game')
          .child(game.id)
          .update(game.toJSON());
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }
}
