import 'package:carg/models/score/contree_belote_score.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/score/belote_score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ContreeScoreService
    extends BeloteScoreService<ContreeBeloteScore?, ContreeBeloteRound> {
  static const String dataBase = 'contree-score';
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  @override
  Future<ContreeBeloteScore?> getScoreByGame(String? gameId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .where('game', isEqualTo: gameId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return ContreeBeloteScore.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Stream<ContreeBeloteScore> getScoreByGameStream(String? gameId) {
    try {
      return FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
        final Map<dynamic, dynamic>? value = event.docs[0].data();
        return ContreeBeloteScore.fromJSON(
            value as Map<String, dynamic>?, event.docs[0].id);
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future addRoundToGame(String? gameId, ContreeBeloteRound contreeRound) async {
    try {
      var contreeScore = await getScoreByGame(gameId);
      if (contreeScore != null) {
        contreeScore.usTotalPoints +=
            getPointsOfRound(BeloteTeamEnum.US, contreeRound)!;
        contreeScore.themTotalPoints +=
            getPointsOfRound(BeloteTeamEnum.THEM, contreeRound)!;
        contreeRound.index = contreeScore.rounds!.length;
        contreeScore.rounds!.add(contreeRound);
        await FirebaseFirestore.instance
            .collection(dataBase + '-' + flavor)
            .doc(contreeScore.id)
            .update(contreeScore.toJSON());
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
  Future<String> saveScore(ContreeBeloteScore? contreeScore) async {
    try {
      var documentReference = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .add(contreeScore!.toJSON());
      return documentReference.id;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future editLastRoundOfGame(String? gameId, ContreeBeloteRound round) async {
    var contreeScore = await getScoreByGame(gameId);
    contreeScore?.replaceLastRound(round);
    await updateScore(contreeScore);
  }

  @override
  Future updateScore(ContreeBeloteScore? score) async {
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
    var contreeScore = await getScoreByGame(gameId);
    contreeScore?.deleteLastRound();
    await updateScore(contreeScore);
  }

  @override
  ContreeBeloteRound getNewRound() {
    return ContreeBeloteRound();
  }
}
