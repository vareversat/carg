import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/repositories/score/abstract_tarot_score_repository.dart';
import 'package:carg/services/score/abstract_score_service.dart';

abstract class AbstractTarotScoreService
    extends AbstractScoreService<TarotScore> {
  final AbstractTarotScoreRepository tarotScoreRepository;

  AbstractTarotScoreService({required this.tarotScoreRepository})
      : super(scoreRepository: tarotScoreRepository);
}
