import 'package:carg/models/game/french_belote.dart';
import 'package:carg/repositories/game/abstract_belote_game_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractFrenchBeloteGameRepository
    extends AbstractBeloteGameRepository<FrenchBelote> {
  AbstractFrenchBeloteGameRepository(
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
