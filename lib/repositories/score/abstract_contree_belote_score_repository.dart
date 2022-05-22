import 'package:carg/models/score/contree_belote_score.dart';
import 'package:carg/repositories/score/abstract_belote_score_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractContreeBeloteScoreRepository
    extends AbstractBeloteScoreRepository<ContreeBeloteScore> {
  AbstractContreeBeloteScoreRepository(
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
