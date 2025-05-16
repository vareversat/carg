import 'package:carg/models/score/belote_score.dart';
import 'package:carg/repositories/score/abstract_belote_score_repository.dart';
import 'package:carg/services/score/abstract_score_service.dart';

abstract class AbstractBeloteScoreService<T extends BeloteScore>
    extends AbstractScoreService<T> {
  final AbstractBeloteScoreRepository<T> beloteScoreRepository;

  AbstractBeloteScoreService({required this.beloteScoreRepository})
    : super(scoreRepository: beloteScoreRepository);

  Future<T?> generateNewScore(String gameId);
}
