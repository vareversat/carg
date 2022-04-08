import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/exceptions/service_exception.dart';
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

  /// Get a team by a list of [playerIds]
  /// If no team exists, return a new one
  Future<Team> getTeamByPlayers(List<String?>? playerIds) async {
    if (playerIds == null) {
      throw ServiceException('Please use a non null player Ids array');
    }
    try {
      var team = await teamRepository.getTeamByPlayers(playerIds);
      team ??= await teamRepository.createTeamWithPlayers(playerIds);
      return team;
    } on RepositoryException catch (e) {
      throw ServiceException(e.message);
    }
  }

  /// Increment the played games of a team by one
  /// Return the edited team
  Future<Team> incrementPlayedGamesByOne(String? id, Game? game) async {
    if (id == null || game == null) {
      throw ServiceException('Please use a non null team id and game object');
    }
    try {
      var team = await teamRepository.get(id);
      if (team != null) {
        team.playedGames += 1;
        await teamRepository.updateField(
            team.id!, 'played_games', team.playedGames);
        for (var player in team.players!) {
          await playerService.incrementPlayedGamesByOne(player, game);
        }
        return team;
      } else {
        throw ServiceException('No team associated to $id exists');
      }
    } on RepositoryException catch (e) {
      throw ServiceException(e.message);
    }
  }

  /// Increment the won games of a team by one
  /// Return the edited team
  Future<Team> incrementWonGamesByOne(String? id, Game? game) async {
    if (id == null || game == null) {
      throw ServiceException('Please use a non null team id and game object');
    }
    try {
      var team = await teamRepository.get(id);
      if (team != null) {
        team.wonGames += 1;
        await teamRepository.updateField(
            team.id!, 'won_games', team.playedGames);
        for (var player in team.players!) {
          await playerService.incrementWonGamesByOne(player, game);
        }
        return team;
      } else {
        throw ServiceException('No team associated to $id exists');
      }
    } on RepositoryException catch (e) {
      throw ServiceException(e.message);
    }
  }
}
