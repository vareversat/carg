import 'package:carg/models/score/contree_belote_score.dart';
import 'package:carg/repositories/score/abstract_contree_belote_score_repository.dart';
import 'package:carg/services/score/abstract_belote_score_service.dart';

abstract class AbstractContreeBeloteScoreService
    extends AbstractBeloteScoreService<ContreeBeloteScore> {
  AbstractContreeBeloteScoreService({
    required AbstractContreeBeloteScoreRepository contreeBeloteScoreRepository,
  }) : super(beloteScoreRepository: contreeBeloteScoreRepository);
}
