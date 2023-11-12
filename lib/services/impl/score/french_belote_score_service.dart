import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/repositories/impl/score/french_belote_score_repository.dart';
import 'package:carg/repositories/score/abstract_french_belote_score_repository.dart';
import 'package:carg/services/score/abstract_french_belote_score_service.dart';

class FrenchBeloteScoreService extends AbstractFrenchBeloteScoreService {
  FrenchBeloteScoreService({
    AbstractFrenchBeloteScoreRepository? frenchBeloteScoreRepository,
  }) : super(
          frenchBeloteScoreRepository:
              frenchBeloteScoreRepository ?? FrenchBeloteScoreRepository(),
        );

  @override
  Future<FrenchBeloteScore?> generateNewScore(String gameId) async {
    var coincheScore = FrenchBeloteScore(
      usTotalPoints: 0,
      themTotalPoints: 0,
      game: gameId,
      rounds: <FrenchBeloteRound>[],
    );
    try {
      await beloteScoreRepository.create(coincheScore);
    } on RepositoryException catch (e) {
      throw ServiceException('Cannot generate score : ${e.message}');
    }

    return coincheScore;
  }
}
