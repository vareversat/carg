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
import 'package:cloud_firestore/cloud_firestore.dart';
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
      var querySnapshot =
          await Firestore.instance.collection('belote-game').getDocuments();
      for (var doc in querySnapshot.documents) {
        beloteGames.add(BeloteGame.fromJSON(doc.data, doc.documentID));
      }
      return beloteGames;
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  @override
  Future<BeloteGame> getGame(String id) async {
    try {
      var querySnapshot =
          await Firestore.instance.collection('belote-game').document(id).get();
      return BeloteGame.fromJSON(querySnapshot.data, querySnapshot.documentID);
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }

  @override
  Future deleteGame(String id) async {
    try {
      await Firestore.instance.collection('belote-game').document(id).delete();
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
      var documentReference = await Firestore.instance
          .collection('belote-game')
          .add(beloteGame.toJSON());
      beloteGame.id = documentReference.documentID;
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
      await Firestore.instance
          .collection('belote-game')
          .document(game.id)
          .updateData({
        'is_ended': true,
        'ending_date': DateTime.now().toString(),
        'winners': winners?.id
      });
    } on PlatformException catch (e) {
      throw FirebaseException(e.message);
    }
  }
}
