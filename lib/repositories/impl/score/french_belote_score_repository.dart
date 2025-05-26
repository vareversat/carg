import 'package:carg/const.dart';
import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/repositories/score/abstract_french_belote_score_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FrenchBeloteScoreRepository extends AbstractFrenchBeloteScoreRepository {
  FrenchBeloteScoreRepository({
    String? database,
    String? environment,
    FirebaseFirestore? provider,
  }) : super(
         database: database ?? Const.frenchBeloteScoreDB,
         environment:
             environment ??
             const String.fromEnvironment(
               Const.dartVarEnv,
               defaultValue: Const.defaultEnv,
             ),
         provider: provider ?? FirebaseFirestore.instance,
       );

  @override
  Future<FrenchBeloteScore?> get(String id) async {
    var querySnapshot = await provider
        .collection(connectionString)
        .doc(id)
        .get();
    if (querySnapshot.data() != null) {
      return FrenchBeloteScore.fromJSON(querySnapshot.data(), querySnapshot.id);
    } else {
      return null;
    }
  }

  @override
  Future<FrenchBeloteScore?> getScoreByGame(String? gameId) async {
    try {
      var querySnapshot = await provider
          .collection(connectionString)
          .where('game', isEqualTo: gameId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return FrenchBeloteScore.fromJSON(
          querySnapshot.docs.first.data(),
          querySnapshot.docs.first.id,
        );
      }
      return null;
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  @override
  Stream<FrenchBeloteScore?> getScoreByGameStream(String gameId) {
    try {
      return provider
          .collection(connectionString)
          .where('game', isEqualTo: gameId)
          .snapshots()
          .map((event) {
            final Map<dynamic, dynamic> value = event.docs[0].data();
            return FrenchBeloteScore.fromJSON(
              value as Map<String, dynamic>?,
              event.docs[0].id,
            );
          });
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }
}
