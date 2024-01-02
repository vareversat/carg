import 'package:carg/models/score/belote_score.dart';
import 'package:carg/repositories/score/abstract_score_repository.dart';

abstract class AbstractBeloteScoreRepository<T extends BeloteScore>
    extends AbstractScoreRepository<T> {
  AbstractBeloteScoreRepository(
      {required super.database,
      required super.environment,
      required super.provider,
      super.lastFetchGameDocument});
}
