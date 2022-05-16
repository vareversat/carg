import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/repositories/score/abstract_belote_score_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractFrenchBeloteScoreRepository
    extends AbstractBeloteScoreRepository<FrenchBeloteScore> {
  AbstractFrenchBeloteScoreRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider})
      : super(database: database, environment: environment, provider: provider);
}
