import 'package:carg/models/score/coinche_belote_score.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/score/belote_score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CoincheScoreService
    extends BeloteScoreService<CoincheBeloteScore?, CoincheBeloteRound> {
  static const String dataBase = 'coinche-score';
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  @override
  Future<CoincheBeloteScore?> getScoreByGame(String? gameId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .where('game', isEqualTo: gameId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return CoincheBeloteScore.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Stream<CoincheBeloteScore> getScoreByGameStream(String? gameId) {
    try {
      return FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
        final Map<dynamic, dynamic>? value = event.docs[0].data();
        return CoincheBeloteScore.fromJSON(
            value as Map<String, dynamic>?, event.docs[0].id);
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future addRoundToGame(String? gameId, CoincheBeloteRound coincheRound) async {
    try {
      var coincheScore = await getScoreByGame(gameId);
      if (coincheScore != null) {
        coincheScore.usTotalPoints +=
            getPointsOfRound(BeloteTeamEnum.US, coincheRound)!;
        coincheScore.themTotalPoints +=
            getPointsOfRound(BeloteTeamEnum.THEM, coincheRound)!;
        coincheRound.index = coincheScore.rounds!.length;
        coincheScore.rounds!.add(coincheRound);
        await FirebaseFirestore.instance
            .collection(dataBase + '-' + flavor)
            .doc(coincheScore.id)
            .update(coincheScore.toJSON());
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
  Future<String> saveScore(CoincheBeloteScore? coincheScore) async {
    try {
      var documentReference = await FirebaseFirestore.instance
          .collection(dataBase + '-' + flavor)
          .add(coincheScore!.toJSON());
      return documentReference.id;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future editLastRoundOfGame(String? gameId, CoincheBeloteRound round) async {
    var coincheScore = await getScoreByGame(gameId);
    coincheScore?.replaceLastRound(round);
    await updateScore(coincheScore);
  }

  @override
  Future updateScore(CoincheBeloteScore? score) async {
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
    var coincheScore = await getScoreByGame(gameId);
    coincheScore?.deleteLastRound();
    await updateScore(coincheScore);
  }

  @override
  CoincheBeloteRound getNewRound() {
    return CoincheBeloteRound();
  }
}
