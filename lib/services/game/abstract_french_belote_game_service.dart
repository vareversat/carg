import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/repositories/game/abstract_french_belote_game_repository.dart';
import 'package:carg/services/game/abstract_belote_game_service.dart';
import 'package:carg/services/score/abstract_french_belote_score_service.dart';

abstract class AbstractFrenchBeloteGameService
    extends AbstractBeloteGameService<FrenchBelote, FrenchBeloteScore> {
  AbstractFrenchBeloteGameService(
      {required AbstractFrenchBeloteScoreService frenchBeloteScoreService,
      required AbstractFrenchBeloteGameRepository frenchBeloteGameRepository,
      required super.teamService})
      : super(
            beloteGameRepository: frenchBeloteGameRepository,
            beloteScoreService: frenchBeloteScoreService);
}
