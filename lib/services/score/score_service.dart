import 'package:carg/models/score/round/round.dart';
import 'package:carg/models/score/score.dart';

abstract class ScoreService<T extends Score, P extends Round> {
  Future<T> getScoreByGame(String gameId);

  Stream<T> getScoreByGameStream(String gameId);

  Future addRoundToGame(String gameId, P round);

  Future deleteScoreByGame(String gameId);

  Future<String> saveScore(T coincheScore);
}
