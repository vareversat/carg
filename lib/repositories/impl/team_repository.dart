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
      super.lastFetchGameDocument})
      : super(
            database: database ?? Const.teamDB,
            environment: environment ??
                const String.fromEnvironment(Const.dartVarEnv,
                    defaultValue: Const.defaultEnv),
            provider: provider ?? FirebaseFirestore.instance);

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
  Future<List<Team>> getAllTeamOfPlayer(String playerId, int pageSize) async {
    try {
      var teams = <Team>[];
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      if (lastFetchGameDocument != null) {
        querySnapshot = await provider
            .collection(connectionString)
            .where('players', arrayContains: playerId)
            .startAfterDocument(lastFetchGameDocument!)
            .limit(pageSize)
            .get();
      } else {
        querySnapshot = await provider
            .collection(connectionString)
            .where('players', arrayContains: playerId)
            .limit(pageSize)
            .get();
      }
      if (querySnapshot.docs.isEmpty) {
        return teams;
      }
      lastFetchGameDocument = querySnapshot.docs.last;
      for (var doc in querySnapshot.docs) {
        teams.add(Team.fromJSON(doc.data(), doc.id));
      }
      return teams;
    } on FirebaseException catch (e) {
      throw RepositoryException(e.message!);
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
