import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/repositories/score/abstract_belote_score_repository.dart';

abstract class AbstractFrenchBeloteScoreRepository
    extends AbstractBeloteScoreRepository<FrenchBeloteScore> {
  AbstractFrenchBeloteScoreRepository({
    required super.database,
    required super.environment,
    required super.provider,
    super.lastFetchGameDocument,
  });
}
