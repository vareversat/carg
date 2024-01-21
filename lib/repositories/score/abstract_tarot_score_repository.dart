import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/repositories/score/abstract_score_repository.dart';

abstract class AbstractTarotScoreRepository
    extends AbstractScoreRepository<TarotScore> {
  AbstractTarotScoreRepository(
      {required super.database,
      required super.environment,
      required super.provider,
      super.lastFetchGameDocument});
}
