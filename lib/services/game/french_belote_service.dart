import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/game/belote_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/score/belote_score_service.dart';
import 'package:carg/services/score/french_belote_score_service.dart';
import 'package:carg/services/team_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FrenchBeloteService extends BeloteService<FrenchBelote> {
  final TeamService _teamService = TeamService();
  final _playerService = PlayerService();
  final BeloteScoreService _beloteScoreService = FrenchBeloteScoreService();
  static const String dataBase = 'belote-game';
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  @override
  Future<List<FrenchBelote>> getAllGamesOfPlayerPaginated(
      String? playerId, int pageSize) async {
    try {
      var beloteGames = <FrenchBelote>[];
      if (playerId == null) {
        return beloteGames;
      }
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      if (lastFetchGameDocument != null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection(dataBase + '-' + flavor)
            .where('players.player_list', arrayContains: playerId)
            .orderBy('starting_date', descending: true)
            .startAfterDocument(lastFetchGameDocument!)
            .limit(pageSize)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection(dataBase + '-' + flavor)
            .where('players.player_list', arrayContains: playerId)
            .orderBy('starting_date', descending: true)
            .limit(pageSize)
            .get();
      }
      if (querySnapshot.docs.isEmpty) {
        return beloteGames;
      }
      lastFetchGameDocument = querySnapshot.docs.last;
      for (var doc in querySnapshot.docs) {
        beloteGames.add(FrenchBelote.fromJSON(doc.data(), doc.id));
      }
      return beloteGames;
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future<FrenchBelote> getGame(String id) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .doc(id)
          .get();
      return FrenchBelote.fromJSON(querySnapshot.data(), querySnapshot.id);
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future deleteGame(String? id) async {
    try {
      await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .doc(id)
          .delete();
      await _beloteScoreService.deleteScoreByGame(id);
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future<FrenchBelote> createGameWithPlayerList(
      List<String?> playerListForOrder, List<String?> playerListForTeam) async {
    try {
      var usTeam = await _teamService.getTeamByPlayers(
          playerListForTeam.sublist(0, 2).map((e) => e).toList());
      var themTeam = await _teamService.getTeamByPlayers(
          playerListForTeam.sublist(2, 4).map((e) => e).toList());
      var beloteGame = FrenchBelote(
          players: BelotePlayers(
              us: usTeam.id,
              them: themTeam.id,
              playerList: playerListForOrder));
      var documentReference = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
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
      throw CustomException(e.message!);
    }
  }

  @override
  Future endAGame(FrenchBelote game) async {
    try {
      Team? winners;
      for (var player in game.players!.playerList!) {
        {
          await _playerService.incrementPlayedGamesByOne(player!, game);
        }
      }
      var score = await _beloteScoreService.getScoreByGame(game.id);
      if (score!.themTotalPoints > score.usTotalPoints) {
        winners =
            await _teamService.incrementWonGamesByOne(game.players!.them, game);
      } else if (score.themTotalPoints < score.usTotalPoints) {
        winners =
            await _teamService.incrementWonGamesByOne(game.players!.us, game);
      }
      await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .doc(game.id)
          .update({
        'is_ended': true,
        'ending_date': DateTime.now().toString(),
        'winners': winners?.id
      });
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future updateGame(FrenchBelote game) async {
    try {
      await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .doc(game.id)
          .update(game.toJSON());
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }
}
