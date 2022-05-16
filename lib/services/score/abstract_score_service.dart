import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/score/score.dart';
import 'package:carg/repositories/score/abstract_score_repository.dart';
import 'package:carg/services/base_abstract_service.dart';

abstract class AbstractScoreService<T extends Score>
    extends BaseAbstractService<Score> {
  final AbstractScoreRepository<T> scoreRepository;

  AbstractScoreService({required this.scoreRepository})
      : super(repository: scoreRepository);

  /// Get a score by a [gameId]
  /// Return a score or null if not found
  Future<T?> getScoreByGame(String? gameId) async {
    if (gameId == null) {
      throw ServiceException('Please use a non null game id');
    }
    try {
      var score = await scoreRepository.getScoreByGame(gameId);
      return score;
    } on RepositoryException catch (e) {
      throw ServiceException(
          'Error on getting the score by game ID [$gameId] : ${e.message}');
    }
  }

  /// Get a score by a [gameId]
  /// Return a stream of score or null if not found
  Stream<T?> getScoreByGameStream(String? gameId) {
    if (gameId == null) {
      throw ServiceException('Please use a non null game id');
    }
    try {
      var scoreStream = scoreRepository.getScoreByGameStream(gameId);
      return scoreStream;
    } on RepositoryException catch (e) {
      throw ServiceException(
          'Error on streaming the score by game ID [$gameId] : ${e.message}');
    }
  }

  /// Delete a score by [gameId]
  Future<void> deleteScoreByGame(String? gameId) async {
    if (gameId == null) {
      throw ServiceException('Please use a non null game id');
    }
    try {
      await scoreRepository.deleteScoreByGame(gameId);
    } on RepositoryException catch (e) {
      throw ServiceException(
          'Error on deleting a score by game ID [$gameId] : ${e.message}');
    }
  }
}
