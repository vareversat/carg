import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/player.dart';
import 'package:carg/repositories/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractPlayerRepository extends BaseRepository<Player> {
  AbstractPlayerRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider})
      : super(database: database, environment: environment, provider: provider);

  @override
  Future<Player?> get(String id) async {
    var querySnapshot =
        await provider.collection(connectionString).doc(id).get();
    if (querySnapshot.data() != null) {
      return Player.fromJSON(querySnapshot.data(), querySnapshot.id);
    } else {
      return null;
    }
  }

  /// Get the player of a particular user via hist/her/them [userId]
  /// Return the player or null if not found
  Future<Player?> getPlayerOfUser(String userId) async {
    try {
      var querySnapshot = await provider
          .collection(connectionString)
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
