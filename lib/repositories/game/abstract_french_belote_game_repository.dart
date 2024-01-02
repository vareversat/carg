import 'package:carg/models/game/french_belote.dart';
import 'package:carg/repositories/game/abstract_belote_game_repository.dart';

abstract class AbstractFrenchBeloteGameRepository
    extends AbstractBeloteGameRepository<FrenchBelote> {
  AbstractFrenchBeloteGameRepository(
      {required super.database,
      required super.environment,
      required super.provider,
      super.lastFetchGameDocument});
}
