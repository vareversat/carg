import 'package:carg/const.dart';
import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/repositories/game/abstract_coinche_belote_game_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoincheBeloteGameRepository extends AbstractCoincheBeloteGameRepository {
  CoincheBeloteGameRepository({
    String? database,
    String? environment,
    FirebaseFirestore? provider,
    super.lastFetchGameDocument,
  }) : super(
         database: database ?? Const.coincheBeloteGameDB,
         environment:
             environment ??
             const String.fromEnvironment(
               Const.dartVarEnv,
               defaultValue: Const.defaultEnv,
             ),
         provider: provider ?? FirebaseFirestore.instance,
       );

  @override
  Future<CoincheBelote?> get(String id) async {
    try {
      var querySnapshot = await provider
          .collection(connectionString)
          .doc(id)
          .get();
      if (querySnapshot.data() != null) {
        return CoincheBelote.fromJSON(querySnapshot.data(), querySnapshot.id);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  @override
  Future<List<CoincheBelote>> getAllGamesOfPlayer(
    String playerId,
    int pageSize,
  ) async {
    try {
      var games = <CoincheBelote>[];
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      if (lastFetchGameDocument != null) {
        querySnapshot = await provider
            .collection(connectionString)
            .where('players.player_list', arrayContains: playerId)
            .orderBy('starting_date', descending: true)
            .startAfterDocument(lastFetchGameDocument!)
            .limit(pageSize)
            .get();
      } else {
        querySnapshot = await provider
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
        games.add(CoincheBelote.fromJSON(doc.data(), doc.id));
      }
      return games;
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }
}
