import 'package:carg/models/game/belote_game.dart';
import 'package:carg/repositories/game/abstract_game_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractBeloteGameRepository<T extends Belote>
    extends AbstractGameRepository<T> {
  AbstractBeloteGameRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider,
      DocumentSnapshot? lastFetchGameDocument})
      : super(
            database: database,
            environment: environment,
            provider: provider,
            lastFetchGameDocument: lastFetchGameDocument);
}
