import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/game/belote_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/services/score/belote_score_service.dart';
import 'package:carg/services/score/french_belote_score_service.dart';
import 'package:carg/services/team_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FrenchBeloteService implements BeloteService<FrenchBelote> {
  TeamService _teamService;
  PlayerService _playerService;
  BeloteScoreService _beloteScoreService;
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  FrenchBeloteService() : super() {
    _teamService = TeamService();
    _playerService = PlayerService();
    _beloteScoreService = FrenchBeloteScoreService();
  }

  @override
  Future<List<FrenchBelote>> getAllGames() async {
    try {
      var beloteGames = <FrenchBelote>[];
      var querySnapshot = await FirebaseFirestore.instance
          .collection('belote-game-' + flavor)
          .orderBy('starting_date', descending: true)
          .get();
      for (var doc in querySnapshot.docs) {
        beloteGames.add(FrenchBelote.fromJSON(doc.data(), doc.id));
      }
      return beloteGames;
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  @override
  Future<FrenchBelote> getGame(String id) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('belote-game-' + flavor)
          .doc(id)
          .get();
      return FrenchBelote.fromJSON(querySnapshot.data(), querySnapshot.id);
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  @override
  Future deleteGame(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('belote-game-' + flavor)
          .doc(id)
          .delete();
      await _beloteScoreService.deleteScoreByGame(id);
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  @override
  Future<FrenchBelote> createGameWithPlayerList(List<String> playerList) async {
    try {
      var usTeam = await _teamService
          .getTeamByPlayers(playerList.sublist(0, 2).map((e) => e).toList());
      var themTeam = await _teamService
          .getTeamByPlayers(playerList.sublist(2, 4).map((e) => e).toList());
      var beloteGame = FrenchBelote(
          players: BelotePlayers(
              us: usTeam.id, them: themTeam.id, playerList: playerList));
      playerList.forEach((playerId) async => {
            await _playerService.incrementPlayedGamesByOne(playerId, beloteGame)
          });
      var documentReference = await FirebaseFirestore.instance
          .collection('belote-game-' + flavor)
          .add(beloteGame.toJSON());
      beloteGame.id = documentReference.id;
      var beloteScore = FrenchBeloteScore(
          usTotalPoints: 0,
          themTotalPoints: 0,
          game: beloteGame.id,
          rounds: <FrenchBeloteRound>[]);
      await _beloteScoreService.saveScore(beloteScore);
      return beloteGame;
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  @override
  Future endAGame(FrenchBelote game) async {
    try {
      Team winners;
      var score = await _beloteScoreService.getScoreByGame(game.id);
      if (score.themTotalPoints > score.usTotalPoints) {
        winners =
            await _teamService.incrementWonGamesByOne(game.players.them, game);
      } else if (score.themTotalPoints < score.usTotalPoints) {
        winners =
            await _teamService.incrementWonGamesByOne(game.players.us, game);
      }
      await FirebaseFirestore.instance
          .collection('belote-game-' + flavor)
          .doc(game.id)
          .update({
        'is_ended': true,
        'ending_date': DateTime.now().toString(),
        'winners': winners?.id
      });
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }
}
