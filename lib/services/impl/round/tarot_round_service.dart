import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/setting/tarot_game_setting.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/services/impl/score/tarot_score_service.dart';
import 'package:carg/services/round/abstract_tarot_round_service.dart';
import 'package:carg/services/score/abstract_tarot_score_service.dart';

class TarotRoundService extends AbstractTarotRoundService {
  TarotRoundService({AbstractTarotScoreService? tarotScoreService})
      : super(tarotScoreService: tarotScoreService ?? TarotScoreService());

  @override
  TarotRound getNewRound(TarotGameSetting settings) {
    return TarotRound();
  }

  @override
  Future<void> addRoundToGame(String? gameId, TarotRound? round) async {
    if (gameId == null || round == null) {
      throw ServiceException('Please use a non null game id and round object');
    }
    try {
      var tarotScore = await tarotScoreService.getScoreByGame(gameId);
      if (tarotScore != null) {
        tarotScore.addRound(round);
        await tarotScoreService.update(tarotScore);
      }
    } on ServiceException {
      rethrow;
    }
  }
}
