import 'package:carg/models/team.dart';
import 'package:carg/repositories/base_repository.dart';

abstract class AbstractTeamRepository extends BaseRepository<Team> {
  AbstractTeamRepository(
      {required super.database,
      required super.environment,
      required super.provider,
      super.lastFetchGameDocument});

  /// Get a team by a list of [playerIds]
  /// If no team exists, return null
  Future<Team?> getTeamByPlayers(List<String?> playerIds);

  /// Create a team by a list of [playerIds]
  /// Return the new team
  Future<Team> createTeamWithPlayers(List<String?> playerIds);

  /// Get all teams of the current player
  /// If no team exists, return an empty array
  Future<List<Team>> getAllTeamOfPlayer(String playerId, int pageSize);
}
