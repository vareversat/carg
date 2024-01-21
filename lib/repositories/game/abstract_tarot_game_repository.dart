import 'package:carg/models/game/tarot.dart';
import 'package:carg/repositories/game/abstract_game_repository.dart';

abstract class AbstractTarotGameRepository
    extends AbstractGameRepository<Tarot> {
  AbstractTarotGameRepository(
      {required super.database,
      required super.environment,
      required super.provider,
      super.lastFetchGameDocument});
}
