import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/score/belote_score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FrenchBeloteScoreService
    extends BeloteScoreService<FrenchBeloteScore?, FrenchBeloteRound> {
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  @override
  Future<FrenchBeloteScore?> getScoreByGame(String? gameId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('belote-score-' + flavor)
          .where('game', isEqualTo: gameId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return FrenchBeloteScore.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Stream<FrenchBeloteScore> getScoreByGameStream(String? gameId) {
    try {
      return FirebaseFirestore.instance
          .collection('belote-score-' + flavor)
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
        final Map<dynamic, dynamic>? value = event.docs[0].data();
        return FrenchBeloteScore.fromJSON(
            value as Map<String, dynamic>?, event.docs[0].id);
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future addRoundToGame(String? gameId, FrenchBeloteRound beloteRound) async {
    try {
      var beloteScore = await getScoreByGame(gameId);
      if (beloteScore != null) {
        beloteScore.usTotalPoints +=
            getPointsOfRound(BeloteTeamEnum.US, beloteRound)!;
        beloteScore.themTotalPoints +=
            getPointsOfRound(BeloteTeamEnum.THEM, beloteRound)!;
        beloteRound.index = beloteScore.rounds!.length;
        beloteScore.rounds!.add(beloteRound);
        await FirebaseFirestore.instance
            .collection('belote-score-' + flavor)
            .doc(beloteScore.id)
            .update(beloteScore.toJSON());
      }
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future deleteScoreByGame(String? gameId) async {
    try {
      await FirebaseFirestore.instance
          .collection('belote-score-' + flavor)
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
  Future<String> saveScore(FrenchBeloteScore? beloteScore) async {
    try {
      var documentReference = await FirebaseFirestore.instance
          .collection('belote-score-' + flavor)
          .add(beloteScore!.toJSON());
      return documentReference.id;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message!);
    }
  }

  @override
  Future editLastRoundOfGame(String? gameId, FrenchBeloteRound round) async {
    var beloteScore = await getScoreByGame(gameId);
    beloteScore?.replaceLastRound(round);
    await updateScore(beloteScore);
  }

  @override
  Future updateScore(FrenchBeloteScore? score) async {
    try {
      await FirebaseFirestore.instance
          .collection('belote-score-' + flavor)
          .doc(score!.id)
          .update(score.toJSON());
    } on PlatformException catch (e) {
      throw CustomException(e.message!);
    }
  }

  @override
  Future deleteLastRoundOfGame(String? gameId) async {
    var beloteScore = await getScoreByGame(gameId);
    beloteScore?.deleteLastRound();
    await updateScore(beloteScore);
  }

  @override
  FrenchBeloteRound getNewRound() {
    return FrenchBeloteRound();
  }
}
