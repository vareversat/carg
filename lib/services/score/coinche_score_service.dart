import 'package:carg/models/score/coinche_score.dart';
import 'package:carg/models/score/misc/team_game_enum.dart';
import 'package:carg/models/score/round/coinche_round.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/score/team_game_score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CoincheScoreService
    extends TeamGameScoreService<CoincheScore, CoincheRound> {
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  @override
  Future<CoincheScore> getScoreByGame(String gameId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('coinche-score-' + flavor)
          .where('game', isEqualTo: gameId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return CoincheScore.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Stream<CoincheScore> getScoreByGameStream(String gameId) {
    try {
      return FirebaseFirestore.instance
          .collection('coinche-score-' + flavor)
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
        if (event.docs[0] == null) {
          throw CustomException('no_score');
        };
        final Map<dynamic, dynamic> value = event.docs[0].data();
        return CoincheScore.fromJSON(value, event.docs[0].id);
      });
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future addRoundToGame(String gameId, CoincheRound coincheRound) async {
    try {
      //var coincheGame = await _coi
      var coincheScore = await getScoreByGame(gameId);
      if (coincheScore != null) {
        coincheScore.usTotalPoints +=
            getPointsOfRound(TeamGameEnum.US, coincheRound);
        coincheScore.themTotalPoints +=
            getPointsOfRound(TeamGameEnum.THEM, coincheRound);
        coincheRound.index = coincheScore.rounds.length;
        coincheScore.rounds.add(coincheRound);
        await FirebaseFirestore.instance
            .collection('coinche-score-' + flavor)
            .doc(coincheScore.id)
            .update(coincheScore.toJSON());
      }
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future deleteScoreByGame(String gameId) async {
    try {
      await FirebaseFirestore.instance
          .collection('coinche-score-' + flavor)
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
  Future<String> saveScore(CoincheScore coincheScore) async {
    try {
      var documentReference = await FirebaseFirestore.instance
          .collection('coinche-score-' + flavor)
          .add(coincheScore.toJSON());
      return documentReference.id;
    } on PlatformException catch (e) {
      throw Exception('[' + e.code + '] Firebase error ' + e.message);
    }
  }

  @override
  Future editLastRoundOfGame(String gameId, CoincheRound round) async {
    var coincheScore = await getScoreByGame(gameId);
    coincheScore.replaceLastRound(round);
    await updateScore(coincheScore);
  }

  @override
  Future updateScore(CoincheScore score) async {
    try {
      await FirebaseFirestore.instance
          .collection('coinche-score-' + flavor)
          .doc(score.id)
          .update(score.toJSON());
    } on PlatformException catch (e) {
      throw CustomException(e.message);
    }
  }

  @override
  Future deleteLastRoundOfGame(String gameId) async {
    var coincheScore = await getScoreByGame(gameId);
    coincheScore.deleteLastRound();
    await updateScore(coincheScore);
  }

  @override
  CoincheRound getNewRound() {
    return CoincheRound();
  }
}
