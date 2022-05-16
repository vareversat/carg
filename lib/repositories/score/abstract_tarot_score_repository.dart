import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/repositories/score/abstract_score_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractTarotScoreRepository
    extends AbstractScoreRepository<TarotScore> {
  AbstractTarotScoreRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider})
      : super(database: database, environment: environment, provider: provider);
}
