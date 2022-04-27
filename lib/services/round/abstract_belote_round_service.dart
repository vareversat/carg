import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/services/round/abstract_round_service.dart';
import 'package:carg/services/score/abstract_belote_score_service.dart';

abstract class AbstractBeloteRoundService<T extends BeloteRound,
    S extends BeloteScore> extends AbstractRoundService<T, S> {
  final AbstractBeloteScoreService<S> scoreService;

  AbstractBeloteRoundService({required this.scoreService})
      : super(abstractScoreService: scoreService);

  @override
  Future<void> addRoundToGame(String? gameId, T? round) async {
    if (gameId == null || round == null) {
      throw ServiceException('Please use a non null game Id and round');
    }
    try {
      var score = await scoreService.getScoreByGame(gameId);
      if (score != null) {
        score.addRound(round);
        await scoreService.update(score);
      }
    } on ServiceException {
      rethrow;
    }
  }
}
