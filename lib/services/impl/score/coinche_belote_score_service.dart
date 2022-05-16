import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/score/coinche_belote_score.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/repositories/impl/score/coinche_belote_score_repository.dart';
import 'package:carg/repositories/score/abstract_coinche_belote_score_repository.dart';
import 'package:carg/services/score/abstract_coinche_belote_score_service.dart';

class CoincheBeloteScoreService extends AbstractCoincheBeloteScoreService {
  CoincheBeloteScoreService(
      {AbstractCoincheBeloteScoreRepository? coincheBeloteScoreRepository})
      : super(
            coincheBeloteScoreRepository:
                coincheBeloteScoreRepository ?? CoincheBeloteScoreRepository());

  @override
  Future<CoincheBeloteScore?> generateNewScore(String gameId) async {
    var coincheScore = CoincheBeloteScore(
        usTotalPoints: 0,
        themTotalPoints: 0,
        game: gameId,
        rounds: <CoincheBeloteRound>[]);
    try {
      await beloteScoreRepository.create(coincheScore);
    } on RepositoryException catch (e) {
      throw ServiceException('Cannot generate score : ${e.message}');
    }
    return coincheScore;
  }
}
