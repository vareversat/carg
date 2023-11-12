import 'package:carg/repositories/impl/score/tarot_score_repository.dart';
import 'package:carg/repositories/score/abstract_tarot_score_repository.dart';
import 'package:carg/services/score/abstract_tarot_score_service.dart';

class TarotScoreService extends AbstractTarotScoreService {
  TarotScoreService({AbstractTarotScoreRepository? tarotScoreRepository})
      : super(
          tarotScoreRepository: tarotScoreRepository ?? TarotScoreRepository(),
        );
}
