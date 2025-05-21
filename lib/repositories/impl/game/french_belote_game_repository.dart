import 'package:carg/const.dart';
import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/repositories/game/abstract_french_belote_game_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FrenchBeloteGameRepository extends AbstractFrenchBeloteGameRepository {
  FrenchBeloteGameRepository({
    String? database,
    String? environment,
    FirebaseFirestore? provider,
    super.lastFetchGameDocument,
  }) : super(
         database: database ?? Const.frenchBeloteGameDB,
         environment:
             environment ??
             const String.fromEnvironment(
               Const.dartVarEnv,
               defaultValue: Const.defaultEnv,
             ),
         provider: provider ?? FirebaseFirestore.instance,
       );

  @override
  Future<FrenchBelote?> get(String id) async {
    try {
      var querySnapshot =
          await provider.collection(connectionString).doc(id).get();
      if (querySnapshot.data() != null) {
        return FrenchBelote.fromJSON(querySnapshot.data(), querySnapshot.id);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  @override
  Future<List<FrenchBelote>> getAllGamesOfPlayer(
    String playerId,
    int pageSize,
  ) async {
    try {
      var games = <FrenchBelote>[];
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      if (lastFetchGameDocument != null) {
        querySnapshot =
            await provider
                .collection(connectionString)
                .where('players.player_list', arrayContains: playerId)
                .orderBy('starting_date', descending: true)
                .startAfterDocument(lastFetchGameDocument!)
                .limit(pageSize)
                .get();
      } else {
        querySnapshot =
            await provider
                .collection(connectionString)
                .where('players.player_list', arrayContains: playerId)
                .orderBy('starting_date', descending: true)
                .limit(pageSize)
                .get();
      }
      if (querySnapshot.docs.isEmpty) {
        return games;
      }
      lastFetchGameDocument = querySnapshot.docs.last;
      for (var doc in querySnapshot.docs) {
        games.add(FrenchBelote.fromJSON(doc.data(), doc.id));
      }
      return games;
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }
}
