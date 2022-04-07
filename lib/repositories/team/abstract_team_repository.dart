import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractTeamRepository extends BaseRepository<Team> {
  AbstractTeamRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider})
      : super(database: database, environment: environment, provider: provider);

  @override
  Future<Team?> get(String id) async {
    var querySnapshot =
        await provider.collection(connectionString).doc(id).get();
    if (querySnapshot.data() != null) {
      return Team.fromJSON(querySnapshot.data(), querySnapshot.id);
    } else {
      return null;
    }
  }

  /// Get a team by a list of [playerIds]
  /// If no team exists, return null
  Future<Team?> getTeamByPlayers(List<String?> playerIds) async {
    playerIds.sort();
    var querySnapshot = await provider
        .collection(connectionString)
        .where('players', isEqualTo: playerIds)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return Team.fromJSON(
          querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
    } else {
      return null;
    }
  }

  /// Create a team by a list of [playerIds]
  /// Return the new team
  Future<Team> createTeamWithPlayers(List<String?> playerIds) async {
    playerIds.sort();
    var team = await getTeamByPlayers(playerIds);
    if (team != null) {
      throw RepositoryException(
          'Error, the team composed of [${playerIds.toString()}] already exists');
    } else {
      var team = Team(players: playerIds);
      var documentReference =
          await provider.collection(connectionString).add(team.toJSON());
      team.id = documentReference.id;
      return team;
    }
  }
}
