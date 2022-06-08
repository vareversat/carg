import 'package:carg/models/game/game.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/team/abstract_team_repository.dart';
import 'package:carg/services/base_abstract_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';

abstract class AbstractTeamService extends BaseAbstractService<Team> {
  final AbstractTeamRepository teamRepository;
  final AbstractPlayerService playerService;

  AbstractTeamService(
      {required this.teamRepository, required this.playerService})
      : super(repository: teamRepository);

  /// Get all the paginated teams of a player via his/her/them [playerId]
  /// Return the list of Games
  Future<List<Team>> getAllTeamOfPlayer(String? playerId, int? pageSize);

  /// Get a team by a list of [playerIds]
  /// If no team exists, return a new one
  Future<Team> getTeamByPlayers(List<String?>? playerIds);

  /// Increment the played games of a team by one
  /// Return the edited team
  Future<Team> incrementPlayedGamesByOne(String? id, Game? game);

  /// Increment the won games of a team by one
  /// Return the edited team
  Future<Team> incrementWonGamesByOne(String? id, Game? game);
}
