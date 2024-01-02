import 'package:carg/models/score/coinche_belote_score.dart';
import 'package:carg/repositories/score/abstract_belote_score_repository.dart';

abstract class AbstractCoincheBeloteScoreRepository
    extends AbstractBeloteScoreRepository<CoincheBeloteScore> {
  AbstractCoincheBeloteScoreRepository(
      {required super.database,
      required super.environment,
      required super.provider,
      super.lastFetchGameDocument});
}
