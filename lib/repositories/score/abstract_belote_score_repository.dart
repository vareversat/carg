import 'package:carg/models/score/belote_score.dart';
import 'package:carg/repositories/score/abstract_score_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractBeloteScoreRepository<T extends BeloteScore>
    extends AbstractScoreRepository<T> {
  AbstractBeloteScoreRepository(
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
