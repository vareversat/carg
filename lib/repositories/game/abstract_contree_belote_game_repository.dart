import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/repositories/game/abstract_belote_game_repository.dart';

abstract class AbstractContreeBeloteGameRepository
    extends AbstractBeloteGameRepository<ContreeBelote> {
  AbstractContreeBeloteGameRepository(
      {required super.database,
      required super.environment,
      required super.provider,
      super.lastFetchGameDocument});
}
