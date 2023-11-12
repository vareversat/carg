import 'package:carg/models/score/contree_belote_score.dart';
import 'package:carg/repositories/score/abstract_belote_score_repository.dart';

abstract class AbstractContreeBeloteScoreRepository
    extends AbstractBeloteScoreRepository<ContreeBeloteScore> {
  AbstractContreeBeloteScoreRepository({
    required super.database,
    required super.environment,
    required super.provider,
    super.lastFetchGameDocument,
  });
}
