import 'package:carg/const.dart';
import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/player.dart';
import 'package:carg/repositories/player/abstract_player_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerRepository extends AbstractPlayerRepository {
  PlayerRepository({
    String? database,
    String? environment,
    FirebaseFirestore? provider,
    super.lastFetchGameDocument,
  }) : super(
         database: database ?? Const.playerDB,
         environment:
             environment ??
             const String.fromEnvironment(
               Const.dartVarEnv,
               defaultValue: Const.defaultEnv,
             ),
         provider: provider ?? FirebaseFirestore.instance,
       );

  @override
  Future<Player?> get(String id) async {
    try {
      var querySnapshot =
          await provider.collection(connectionString).doc(id).get();
      if (querySnapshot.data() != null) {
        return Player.fromJSON(querySnapshot.data(), querySnapshot.id);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }

  @override
  Future<Player?> getPlayerOfUser(String userId) async {
    try {
      var querySnapshot =
          await provider
              .collection(connectionString)
              .where('linked_user_id', isEqualTo: userId)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        return Player.fromJSON(
          querySnapshot.docs.first.data(),
          querySnapshot.docs.first.id,
        );
      }
      return null;
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }
}
