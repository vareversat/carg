import 'package:carg/const.dart';
import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/repositories/score/abstract_tarot_score_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarotScoreRepository extends AbstractTarotScoreRepository {
  TarotScoreRepository(
      {String? database, String? environment, FirebaseFirestore? provider})
      : super(
            database: database ?? Const.tarotScoreDB,
            environment: environment ??
                const String.fromEnvironment(Const.dartVarEnv,
                    defaultValue: Const.defaultEnv),
            provider: provider ?? FirebaseFirestore.instance);

  @override
  Future<TarotScore?> get(String id) async {
    try {
      var querySnapshot =
          await provider.collection(connectionString).doc(id).get();
      if (querySnapshot.data() != null) {
        return TarotScore.fromJSON(querySnapshot.data(), querySnapshot.id);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  @override
  Future<TarotScore?> getScoreByGame(String? gameId) async {
    try {
      var querySnapshot = await provider
          .collection(connectionString)
          .where('game', isEqualTo: gameId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return TarotScore.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  @override
  Stream<TarotScore?> getScoreByGameStream(String gameId) {
    try {
      return provider
          .collection(connectionString)
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
        return TarotScore.fromJSON(
            event.docs.first.data(), event.docs.first.id);
      });
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }
}
