import 'package:carg/models/game/belote.dart';
import 'package:carg/repositories/game/abstract_game_repository.dart';

abstract class AbstractBeloteGameRepository<T extends Belote>
    extends AbstractGameRepository<T> {
  AbstractBeloteGameRepository({
    required super.database,
    required super.environment,
    required super.provider,
    super.lastFetchGameDocument,
  });
}
