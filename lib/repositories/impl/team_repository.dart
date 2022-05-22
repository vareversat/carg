import 'package:carg/const.dart';
import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/team/abstract_team_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamRepository extends AbstractTeamRepository {
  TeamRepository(
      {String? database,
      String? environment,
      FirebaseFirestore? provider,
      DocumentSnapshot? lastFetchGameDocument})
      : super(
            database: database ?? Const.teamDB,
            environment: environment ??
                const String.fromEnvironment(Const.dartVarEnv,
                    defaultValue: Const.defaultEnv),
            provider: provider ?? FirebaseFirestore.instance,
            lastFetchGameDocument: lastFetchGameDocument);

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

  @override
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

  @override
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
