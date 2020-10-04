import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/score/score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class TarotScoreService extends ScoreService<TarotScore, TarotRound> {
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  @override
  Future<TarotScore> getScoreByGame(String gameId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('tarot-score-' + flavor)
          .where('game', isEqualTo: gameId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return TarotScore.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Stream<TarotScore> getScoreByGameStream(String gameId) {
    try {
      return FirebaseFirestore.instance
          .collection('tarot-score-' + flavor)
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
        if (event.docs[0] == null) return null;
        final Map<dynamic, dynamic> value = event.docs[0].data();
        return TarotScore.fromJSON(value, event.docs[0].id);
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
          tarotScore.scores.forEach((e) => e.player == playerId
              ? e.score += tarotRound.defenseScore
              : e.score += 0);
        }
        tarotScore.scores.forEach((e) => e.player == tarotRound.attackPlayer
            ? e.score += tarotRound.attackScore
            : e.score += 0);
        tarotRound.index = tarotScore.rounds.length;
        tarotScore.rounds.add(tarotRound);
        // await FirebaseFirestore.instance
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
      await FirebaseFirestore.instance
          .collection('tarot-score-' + flavor)
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
  Future<String> saveScore(TarotScore beloteScore) async {
    try {
      var documentReference = await FirebaseFirestore.instance
          .collection('tarot-score-' + flavor)
          .add(beloteScore.toJSON());
      return documentReference.id;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }
}
