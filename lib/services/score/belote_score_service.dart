import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/services/score/team_game_score_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

class BeloteScoreService
    extends TeamGameScoreService<BeloteScore, BeloteRound> {
  @override
  Future<BeloteScore> getScoreByGame(String gameId) async {
    print(gameId);
    try {
      var querySnapshot = await FirebaseDatabase.instance
          .reference()
          .child('belote-score')
          .orderByChild('game')
          .equalTo(gameId)
          .once();
      if (querySnapshot.value != null) {
        var map = querySnapshot.value as Map;
        return BeloteScore.fromJSON(map.values.first, map.keys.first);
      }
      return null;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Stream<BeloteScore> getScoreByGameStream(String gameId) {
    try {
      var dbRef = FirebaseDatabase.instance.reference().child('belote-score');
      return dbRef.orderByChild('game').equalTo(gameId).onValue.map((event) {
        if (event.snapshot == null) return null;
        final Map<dynamic, dynamic> value = event.snapshot.value;
        return BeloteScore.fromJSON(value, event.snapshot.key);
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future addRoundToGame(String gameId, BeloteRound beloteRound) async {
    try {
      var dbRef = FirebaseDatabase.instance.reference().child('belote-score');
      var beloteScore = await getScoreByGame(gameId);
      if (beloteScore != null) {
        beloteScore.usTotalPoints +=
            getTotalPoints(TeamGameEnum.US, beloteRound);
        beloteScore.themTotalPoints +=
            getTotalPoints(TeamGameEnum.THEM, beloteRound);
        beloteRound.index = beloteScore.rounds.length;
        beloteScore.rounds.add(beloteRound);
        await dbRef.child(beloteScore.id).update(beloteScore.toJSON());
      }
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future deleteScoreByGame(String gameId) async {
    try {
      var dbRef = FirebaseDatabase.instance.reference().child('belote-score');
      await dbRef.orderByChild('game').equalTo(gameId).once().then((snapshot) {
        var map = snapshot.value as Map;
        dbRef.child(map.keys.first).remove();
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future<String> saveScore(BeloteScore beloteScore) async {
    try {
      var dbRef = FirebaseDatabase.instance.reference().child('belote-score');
      var documentReference = await dbRef.push();
      await dbRef.child(documentReference.key).set(beloteScore.toJSON());
      return documentReference.key;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }
}
