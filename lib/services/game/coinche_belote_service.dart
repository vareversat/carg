import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/score/coinche_belote_score.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/game/belote_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/services/score/coinche_belote_score_service.dart';
import 'package:carg/services/team_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CoincheBeloteService implements BeloteService<CoincheBelote> {
  final TeamService _teamService = TeamService();
  final PlayerService _playerService = PlayerService();
  final CoincheScoreService _coincheScoreService = CoincheScoreService();
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  CoincheBeloteService() : super();

  @override
  Future<List<CoincheBelote>> getAllGames(String? playerId) async {
    try {
      var coincheGames = <CoincheBelote>[];
      var querySnapshot = await FirebaseFirestore.instance
          .collection('coinche-game-' + flavor)
          .where('players.player_list', arrayContains: playerId)
          .orderBy('starting_date', descending: true)
          .get();
      for (var doc in querySnapshot.docs) {
        coincheGames.add(CoincheBelote.fromJSON(doc.data(), doc.id));
      }
      return coincheGames;
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future<CoincheBelote> getGame(String id) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('coinche-game-' + flavor)
          .doc(id)
          .get();
      return CoincheBelote.fromJSON(querySnapshot.data(), querySnapshot.id);
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future deleteGame(String? id) async {
    try {
      await FirebaseFirestore.instance
          .collection('coinche-game-' + flavor)
          .doc(id)
          .delete();
      await _coincheScoreService.deleteScoreByGame(id);
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future<CoincheBelote> createGameWithPlayerList(
      List<String?> playerList) async {
    try {
      var usTeam = await _teamService
          .getTeamByPlayers(playerList.sublist(0, 2).map((e) => e).toList());
      var themTeam = await _teamService
          .getTeamByPlayers(playerList.sublist(2, 4).map((e) => e).toList());
      var coincheGame = CoincheBelote(
          players: BelotePlayers(
              us: usTeam.id, them: themTeam.id, playerList: playerList));
      var documentReference = await FirebaseFirestore.instance
          .collection('coinche-game-' + flavor)
          .add(coincheGame.toJSON());
      coincheGame.id = documentReference.id;
      var coincheScore = CoincheBeloteScore(
          usTotalPoints: 0,
          themTotalPoints: 0,
          game: coincheGame.id,
          rounds: <CoincheBeloteRound>[]);
      await _coincheScoreService.saveScore(coincheScore);
      return coincheGame;
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future endAGame(CoincheBelote game) async {
    try {
      Team? winners;
      game.players!.playerList!.forEach((player) async =>
          {await _playerService.incrementPlayedGamesByOne(player, game)});
      var score = await _coincheScoreService.getScoreByGame(game.id);
      if (score!.themTotalPoints > score.usTotalPoints) {
        winners =
            await _teamService.incrementWonGamesByOne(game.players!.them, game);
      } else if (score.themTotalPoints < score.usTotalPoints) {
        winners =
            await _teamService.incrementWonGamesByOne(game.players!.us, game);
      }
      await FirebaseFirestore.instance
          .collection('coinche-game-' + flavor)
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
}
