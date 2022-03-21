import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/player.dart';
import 'package:carg/repositories/abstract_player_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerRepository extends AbstractPlayerRepository {

  @override
  Future<Player?> get(String id) async {
    var querySnapshot =
        await provider.collection(database + '-' + environment).doc(id).get();
    if (querySnapshot.data() != null) {
      return Player.fromJSON(querySnapshot.data(), querySnapshot.id);
    } else {
      return null;
    }
  }

  @override
  Future<Player?> getPlayerOfUser(String userId) async {
    try {
      var querySnapshot = await provider
          .collection(database + '-' + environment)
          .where('linked_user_id', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return Player.fromJSON(
            querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      }
      return null;
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
    }
  }
}
