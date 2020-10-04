import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/services/score/team_game_score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class BeloteScoreService
    extends TeamGameScoreService<BeloteScore, BeloteRound> {
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  @override
  Future<BeloteScore> getScoreByGame(String gameId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('belote-score-' + flavor)
          .where('game', isEqualTo: gameId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return BeloteScore.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Stream<BeloteScore> getScoreByGameStream(String gameId) {
    try {
      return FirebaseFirestore.instance
          .collection('belote-score-' + flavor)
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
        if (event.docs[0] == null) return null;
        final Map<dynamic, dynamic> value = event.docs[0].data();
        return BeloteScore.fromJSON(value, event.docs[0].id);
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future addRoundToGame(String gameId, BeloteRound beloteRound) async {
    try {
      var beloteScore = await getScoreByGame(gameId);
      if (beloteScore != null) {
        beloteScore.usTotalPoints +=
            getTotalPoints(TeamGameEnum.US, beloteRound);
        beloteScore.themTotalPoints +=
            getTotalPoints(TeamGameEnum.THEM, beloteRound);
        beloteRound.index = beloteScore.rounds.length;
        beloteScore.rounds.add(beloteRound);
        await FirebaseFirestore.instance
            .collection('belote-score-' + flavor)
            .doc(beloteScore.id)
            .update(beloteScore.toJSON());
      }
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future deleteScoreByGame(String gameId) async {
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
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future<String> saveScore(BeloteScore beloteScore) async {
    try {
      var documentReference = await FirebaseFirestore.instance
          .collection('belote-score-' + flavor)
          .add(beloteScore.toJSON());
      return documentReference.id;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }
}
