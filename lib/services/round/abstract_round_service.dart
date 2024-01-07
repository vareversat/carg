import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/setting/game_setting.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:carg/models/score/score.dart';
import 'package:carg/services/score/abstract_score_service.dart';

abstract class AbstractRoundService<T extends Round, S extends Score,
    G extends GameSetting> {
  final AbstractScoreService<S> abstractScoreService;

  AbstractRoundService({required this.abstractScoreService});

  /// Return a new Round of the correct type
  T getNewRound(G settings);

  /// Add a new round to a game
  Future<void> addRoundToGame(String? gameId, T? round);

  /// Replace the last round of a game
  Future<void> editLastRoundOfScoreByGameId(String? gameId, T? round) async {
    if (round == null) {
      throw ServiceException('Please provide a non null round object');
    }
    try {
      var score = await abstractScoreService.getScoreByGame(gameId);
      if (score != null) {
        score.replaceLastRound(round);
        await abstractScoreService.update(score);
      }
    } on ServiceException {
      rethrow;
    }
  }

  /// Delete the last round of a game
  Future<void> deleteLastRoundOfScoreByGameId(String? gameId) async {
    try {
      var score = await abstractScoreService.getScoreByGame(gameId);
      if (score != null) {
        score.deleteLastRound();
        abstractScoreService.update(score);
      }
    } on ServiceException {
      rethrow;
    }
  }
}
