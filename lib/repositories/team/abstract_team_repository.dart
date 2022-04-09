import 'package:carg/models/team.dart';
import 'package:carg/repositories/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractTeamRepository extends BaseRepository<Team> {
  AbstractTeamRepository(
      {required String database,
      required String environment,
      required FirebaseFirestore provider})
      : super(database: database, environment: environment, provider: provider);

  /// Get a team by a list of [playerIds]
  /// If no team exists, return null
  Future<Team?> getTeamByPlayers(List<String?> playerIds);

  /// Create a team by a list of [playerIds]
  /// Return the new team
  Future<Team> createTeamWithPlayers(List<String?> playerIds);
}
