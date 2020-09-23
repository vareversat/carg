import 'package:carg/environment_config.dart';
import 'package:carg/models/score/coinche_score.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/coinche_round.dart';
import 'package:carg/services/score/team_game_score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CoincheScoreService
    extends TeamGameScoreService<CoincheScore, CoincheRound> {
  final String flavor = EnvironmentConfig.flavor;

  @override
  Future<CoincheScore> getScoreByGame(String gameId) async {
    try {
      var querySnapshot = await Firestore.instance
          .collection('coinche-score-' + flavor)
          .reference()
          .where('game', isEqualTo: gameId)
          .getDocuments();
      if (querySnapshot.documents.isNotEmpty) {
        return CoincheScore.fromJSON(querySnapshot.documents.first.data,
            querySnapshot.documents.first.documentID);
      }
      return null;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Stream<CoincheScore> getScoreByGameStream(String gameId) {
    try {
      return Firestore.instance
          .collection('coinche-score-' + flavor)
          .reference()
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
        if (event.documents[0] == null) return null;
        final Map<dynamic, dynamic> value = event.documents[0].data;
        return CoincheScore.fromJSON(value, event.documents[0].documentID);
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future addRoundToGame(String gameId, CoincheRound coincheRound) async {
    try {
      var coincheScore = await getScoreByGame(gameId);
      if (coincheScore != null) {
        coincheScore.usTotalPoints += getTotalPoints(TeamGameEnum.US, coincheRound);
        coincheScore.themTotalPoints += getTotalPoints(TeamGameEnum.THEM, coincheRound);
        coincheRound.index = coincheScore.rounds.length;
        coincheScore.rounds.add(coincheRound);
        await Firestore.instance
            .collection('coinche-score-' + flavor)
            .document(coincheScore.id)
            .updateData(coincheScore.toJSON());
      }
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future deleteScoreByGame(String gameId) async {
    try {
      await Firestore.instance
          .collection('coinche-score-' + flavor)
          .where('game', isEqualTo: gameId)
          .getDocuments()
          .then((snapshot) {
        for (var ds in snapshot.documents) {
          ds.reference.delete();
        }
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future<String> saveScore(CoincheScore coincheScore) async {
    try {
      var documentReference = await Firestore.instance
          .collection('coinche-score-' + flavor)
          .add(coincheScore.toJSON());
      return documentReference.documentID;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }
}
