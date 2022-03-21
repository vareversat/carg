import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/score/contree_belote_score.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/game/belote_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/score/contree_belote_score_service.dart';
import 'package:carg/services/team_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ContreeBeloteService extends BeloteService<ContreeBelote> {
  final TeamService _teamService = TeamService();
  final _playerService = PlayerService();
  final ContreeScoreService _contreeScoreService = ContreeScoreService();
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const String dataBase = 'contree-game';

  @override
  Future<List<ContreeBelote>> getAllGamesOfPlayerPaginated(
      String? playerId, int pageSize) async {
    try {
      var contreeGames = <ContreeBelote>[];
      if (playerId == null) {
        return contreeGames;
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
        return contreeGames;
      }
      lastFetchGameDocument = querySnapshot.docs.last;
      for (var doc in querySnapshot.docs) {
        contreeGames.add(ContreeBelote.fromJSON(doc.data(), doc.id));
      }
      return contreeGames;
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future<ContreeBelote> getGame(String id) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .doc(id)
          .get();
      return ContreeBelote.fromJSON(querySnapshot.data(), querySnapshot.id);
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
      await _contreeScoreService.deleteScoreByGame(id);
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future<ContreeBelote> createGameWithPlayerList(
      List<String?> playerListForOrder, List<String?> playerListForTeam) async {
    try {
      var usTeam = await _teamService.getTeamByPlayers(
          playerListForTeam.sublist(0, 2).map((e) => e).toList());
      var themTeam = await _teamService.getTeamByPlayers(
          playerListForTeam.sublist(2, 4).map((e) => e).toList());
      var contreeGame = ContreeBelote(
          players: BelotePlayers(
              us: usTeam.id,
              them: themTeam.id,
              playerList: playerListForOrder));
      var documentReference = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .add(contreeGame.toJSON());
      contreeGame.id = documentReference.id;
      var contreeScore = ContreeBeloteScore(
          usTotalPoints: 0,
          themTotalPoints: 0,
          game: contreeGame.id,
          rounds: <ContreeBeloteRound>[]);
      await _contreeScoreService.saveScore(contreeScore);
      return contreeGame;
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future endAGame(ContreeBelote game) async {
    try {
      Team? winners;
      for (var player in game.players!.playerList!) {
        {
          await _playerService.incrementPlayedGamesByOne(player!, game);
        }
      }
      var score = await _contreeScoreService.getScoreByGame(game.id);
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
  Future updateGame(ContreeBelote game) async {
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
