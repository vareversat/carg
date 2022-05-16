import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/repositories/game/abstract_belote_game_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractCoincheBeloteGameRepository
    extends AbstractBeloteGameRepository<CoincheBelote> {
  AbstractCoincheBeloteGameRepository(
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
