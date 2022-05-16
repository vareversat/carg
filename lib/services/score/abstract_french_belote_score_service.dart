import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/repositories/score/abstract_french_belote_score_repository.dart';
import 'package:carg/services/score/abstract_belote_score_service.dart';

abstract class AbstractFrenchBeloteScoreService
    extends AbstractBeloteScoreService<FrenchBeloteScore> {
  AbstractFrenchBeloteScoreService(
      {required AbstractFrenchBeloteScoreRepository
          frenchBeloteScoreRepository})
      : super(beloteScoreRepository: frenchBeloteScoreRepository);
}
