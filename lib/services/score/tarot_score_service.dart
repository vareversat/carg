import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/score/score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class TarotScoreService extends ScoreService<TarotScore?, TarotRound> {
  static const String dataBase = 'tarot-score';
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  @override
  Future<TarotScore?> getScoreByGame(String? gameId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .where('game', isEqualTo: gameId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return TarotScore.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Stream<TarotScore> getScoreByGameStream(String? gameId) {
    try {
      return FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
        final Map<dynamic, dynamic>? value = event.docs[0].data();
        return TarotScore.fromJSON(
            value as Map<String, dynamic>?, event.docs[0].id);
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future addRoundToGame(String? gameId, TarotRound round) async {
    try {
      var tarotScore = await getScoreByGame(gameId);
      if (tarotScore != null) {
        round = _computePlayerPoints(round, tarotScore);
        tarotScore.addRound(round);
        await FirebaseFirestore.instance
            .collection(dataBase + '-' + flavor)
            .doc(tarotScore.id)
            .update(tarotScore.toJSON());
      }
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future deleteScoreByGame(String? gameId) async {
    try {
      await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .where('game', isEqualTo: gameId)
          .get()
          .then((snapshot) {
        for (var ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future<String> saveScore(TarotScore? score) async {
    try {
      var documentReference = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .add(score!.toJSON());
      return documentReference.id;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future editLastRoundOfGame(String? gameId, TarotRound round) async {
    var tarotScore = await getScoreByGame(gameId);
    round = _computePlayerPoints(round, tarotScore!);
    tarotScore.replaceLastRound(round);
    await updateScore(tarotScore);
  }

  @override
  Future updateScore(TarotScore? score) async {
    try {
      await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .doc(score!.id)
          .update(score.toJSON());
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future deleteLastRoundOfGame(String? gameId) async {
    var tarotScore = await getScoreByGame(gameId);
    tarotScore?.removeRound(tarotScore.getLastRound());
    await updateScore(tarotScore);
  }

  @override
  TarotRound getNewRound() {
    return TarotRound();
  }

  TarotRound _computePlayerPoints(
      TarotRound tarotRound, TarotScore tarotScore) {
    var _playerPoints = <TarotPlayerScore>[];
    var realAttackScore = tarotRound.players!.playerList!.length <= 4
        ? tarotRound.attackScore
        : tarotRound.attackScore * (2 / 3);
    var calledPlayerScore = tarotRound.attackScore * (1 / 3);
    for (var player in tarotRound.players!.playerList!) {
      if (tarotRound.players!.attackPlayer == player) {
        _playerPoints
            .add(TarotPlayerScore(player: player, score: realAttackScore));
      } else if (tarotRound.players!.calledPlayer == player) {
        _playerPoints
            .add(TarotPlayerScore(player: player, score: calledPlayerScore));
      } else {
        _playerPoints.add(
            TarotPlayerScore(player: player, score: tarotRound.defenseScore));
      }
    }
    tarotRound.playerPoints = _playerPoints;
    tarotRound.index = tarotScore.rounds!.length;
    return tarotRound;
  }
}
