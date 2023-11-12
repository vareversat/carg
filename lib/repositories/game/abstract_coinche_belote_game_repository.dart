import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/repositories/game/abstract_belote_game_repository.dart';

abstract class AbstractCoincheBeloteGameRepository
    extends AbstractBeloteGameRepository<CoincheBelote> {
  AbstractCoincheBeloteGameRepository({
    required super.database,
    required super.environment,
    required super.provider,
    super.lastFetchGameDocument,
  });
}
