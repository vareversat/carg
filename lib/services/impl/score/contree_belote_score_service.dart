import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/score/contree_belote_score.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/repositories/impl/score/contree_belote_score_repository.dart';
import 'package:carg/repositories/score/abstract_contree_belote_score_repository.dart';
import 'package:carg/services/score/abstract_contree_belote_score_service.dart';

class ContreeBeloteScoreService extends AbstractContreeBeloteScoreService {
  ContreeBeloteScoreService(
      {AbstractContreeBeloteScoreRepository? contreeBeloteScoreRepository})
      : super(
            contreeBeloteScoreRepository:
                contreeBeloteScoreRepository ?? ContreeBeloteScoreRepository());

  @override
  Future<ContreeBeloteScore?> generateNewScore(String gameId) async {
    var coincheScore = ContreeBeloteScore(
        usTotalPoints: 0,
        themTotalPoints: 0,
        game: gameId,
        rounds: <ContreeBeloteRound>[]);
    try {
      await beloteScoreRepository.create(coincheScore);
    } on RepositoryException catch (e) {
      throw ServiceException('Cannot generate score : ${e.message}');
    }
    return coincheScore;
  }
}
