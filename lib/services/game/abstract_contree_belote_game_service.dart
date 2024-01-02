import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/models/score/contree_belote_score.dart';
import 'package:carg/repositories/game/abstract_contree_belote_game_repository.dart';
import 'package:carg/services/game/abstract_belote_game_service.dart';
import 'package:carg/services/score/abstract_contree_belote_score_service.dart';

abstract class AbstractContreeBeloteGameService
    extends AbstractBeloteGameService<ContreeBelote, ContreeBeloteScore> {
  AbstractContreeBeloteGameService(
      {required AbstractContreeBeloteGameRepository contreeBeloteGameRepository,
      required AbstractContreeBeloteScoreService contreeBeloteScoreService,
      required super.teamService})
      : super(
            beloteGameRepository: contreeBeloteGameRepository,
            beloteScoreService: contreeBeloteScoreService);
}
