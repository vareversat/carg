import 'package:carg/models/score/coinche_belote_score.dart';
import 'package:carg/repositories/score/abstract_coinche_belote_score_repository.dart';
import 'package:carg/services/score/abstract_belote_score_service.dart';

abstract class AbstractCoincheBeloteScoreService
    extends AbstractBeloteScoreService<CoincheBeloteScore> {
  AbstractCoincheBeloteScoreService(
      {required AbstractCoincheBeloteScoreRepository
          coincheBeloteScoreRepository})
      : super(beloteScoreRepository: coincheBeloteScoreRepository);
}
