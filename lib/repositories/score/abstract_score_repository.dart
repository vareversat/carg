import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/score/score.dart';
import 'package:carg/repositories/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractScoreRepository<T extends Score>
    extends BaseRepository<T> {
  AbstractScoreRepository({
    required super.database,
    required super.environment,
    required super.provider,
    super.lastFetchGameDocument,
  });

  /// Get a score by a [gameId]
  /// Return a score or null if not found
  Future<T?> getScoreByGame(String gameId);

  /// Get a score by a [gameId] via a Stream
  /// Return a score or null if not found
  Stream<T?> getScoreByGameStream(String gameId);

  /// Delete a score by a [gameId]
  Future<void> deleteScoreByGame(String gameId) async {
    try {
      await provider
          .collection(connectionString)
          .where('game', isEqualTo: gameId)
          .get()
          .then((snapshot) {
            for (var ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
    } on FirebaseException catch (e) {
      throw RepositoryException(
        'Error during delete of the score linked to the game $gameId : ${e.message!}',
      );
    }
  }
}
