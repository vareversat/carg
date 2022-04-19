import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/repositories/game/abstract_game_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractTarotGameRepository
    extends AbstractGameRepository<Tarot> {
  AbstractTarotGameRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider,
        DocumentSnapshot? lastFetchGameDocument})
      : super(database: database, environment: environment, provider: provider, lastFetchGameDocument: lastFetchGameDocument);

  /// End a [game] by closing it and fill winners field with the winners' player score with the current [now] date
  Future<void> endAGame(Tarot game, TarotPlayerScore winners, DateTime now);
}
