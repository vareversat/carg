import 'package:carg/models/game/tarot_game.dart';
import 'package:carg/models/player/tarot_game_players.dart';
import 'package:carg/models/score/misc/player_score.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/game/game_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/services/score/tarot_score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class TarotGameService extends GameService<TarotGame, TarotGamePlayers> {
  TarotScoreService _tarotScoreService;
  PlayerService _playerService;
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  TarotGameService() : super() {
    _tarotScoreService = TarotScoreService();
    _playerService = PlayerService();
  }

  @override
  Future<List<TarotGame>> getAllGames() async {
    try {
      var beloteGames = <TarotGame>[];
      var querySnapshot = await FirebaseFirestore.instance
          .collection('tarot-game-' + flavor)
          .orderBy('starting_date', descending: true)
          .get();
      for (var doc in querySnapshot.docs) {
        beloteGames.add(TarotGame.fromJSON(doc.data(), doc.id));
      }
      return beloteGames;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future<TarotGame> getGame(String id) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('tarot-game-' + flavor)
          .doc(id)
          .get();
      return TarotGame.fromJSON(querySnapshot.data(), querySnapshot.id);
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future deleteGame(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('tarot-game-' + flavor)
          .doc(id)
          .delete();
      await _tarotScoreService.deleteScoreByGame(id);
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future<TarotGame> createGameWithPlayers(TarotGamePlayers players) async {
    try {
      players.players.forEach((player) async =>
      {await _playerService.incrementPlayedGamesByOne(player)});
      var tarotGame = TarotGame(
          isEnded: false,
          startingDate: DateTime.now(),
          playerIds: players.getPlayerIds());
      var documentReference = await FirebaseFirestore.instance
          .collection('tarot-game-' + flavor)
          .add(tarotGame.toJSON());
      tarotGame.id = documentReference.id;
      var tarotScore = TarotScore(
          game: tarotGame.id,
          rounds: <TarotRound>[],
          players: players.getPlayerIds());
      await _tarotScoreService.saveScore(tarotScore);
      return tarotGame;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future endAGame(TarotGame game) async {
    try {
      PlayerScore winner;
      var score = await _tarotScoreService.getScoreByGame(game.id);
      var totalPoints = score?.totalPoints;
      if (totalPoints != null && totalPoints.isNotEmpty) {
        totalPoints.sort((a, b) => a.score.compareTo(b.score));
        winner = totalPoints.last;
        await _playerService.incrementWonGamesByOne(winner.player);
      }
      await FirebaseFirestore.instance
          .collection('tarot-game-' + flavor)
          .doc(game.id)
          .update({
        'is_ended': true,
        'ending_date': DateTime.now().toString(),
        'winner': winner?.player
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }
}














