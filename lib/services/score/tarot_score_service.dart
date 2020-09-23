import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/score/score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class TarotScoreService extends ScoreService<TarotScore, TarotRound> {
  final String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  @override
  Future<TarotScore> getScoreByGame(String gameId) async {
    try {
      var querySnapshot = await Firestore.instance
          .collection('tarot-score-' + flavor)
          .reference()
          .where('game', isEqualTo: gameId)
          .getDocuments();
      if (querySnapshot.documents.isNotEmpty) {
        return TarotScore.fromJSON(querySnapshot.documents.first.data,
            querySnapshot.documents.first.documentID);
      }
      return null;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Stream<TarotScore> getScoreByGameStream(String gameId) {
    try {
      return Firestore.instance
          .collection('tarot-score-' + flavor)
          .reference()
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
        if (event.documents[0] == null) return null;
        final Map<dynamic, dynamic> value = event.documents[0].data;
        return TarotScore.fromJSON(value, event.documents[0].documentID);
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future addRoundToGame(String gameId, TarotRound tarotRound) async {
    try {
      var tarotScore = await getScoreByGame(gameId);
      if (tarotScore != null) {
        for (var playerId in tarotRound.defensePlayers) {
          tarotScore.scores.forEach((e) => e.player == playerId ? e.score += tarotRound.defenseScore : e.score += 0);
        }
        tarotScore.scores.forEach((e) => e.player == tarotRound.attackPlayer ? e.score += tarotRound.attackScore : e.score += 0);
        tarotRound.index = tarotScore.rounds.length;
        tarotScore.rounds.add(tarotRound);
        // await Firestore.instance
        //     .collection('tarot-score-' + flavor)
        //     .document(tarotScore.id)
        //     .updateData(tarotScore.toJSON());
      }
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future deleteScoreByGame(String gameId) async {
    try {
      await Firestore.instance
          .collection('tarot-score-' + flavor)
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
  Future<String> saveScore(TarotScore beloteScore) async {
    try {
      var documentReference = await Firestore.instance
          .collection('tarot-score-' + flavor)
          .add(beloteScore.toJSON());
      return documentReference.documentID;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }
}
