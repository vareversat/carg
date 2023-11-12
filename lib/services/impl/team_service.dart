import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/impl/team_repository.dart';
import 'package:carg/repositories/team/abstract_team_repository.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';

class TeamService extends AbstractTeamService {
  TeamService({
    AbstractTeamRepository? teamRepository,
    AbstractPlayerService? playerService,
  }) : super(
          teamRepository: teamRepository ?? TeamRepository(),
          playerService: playerService ?? PlayerService(),
        );

  @override
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

  @override
  Future<Team> incrementPlayedGamesByOne(String? id, Game? game) async {
    if (id == null || game == null) {
      throw ServiceException('Please use a non null team id and game object');
    }
    try {
      var team = await teamRepository.get(id);
      if (team != null) {
        team.incrementPlayedGamesByOne(game);
        await teamRepository.update(team);
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

  @override
  Future<Team> incrementWonGamesByOne(String? id, Game? game) async {
    if (id == null || game == null) {
      throw ServiceException('Please use a non null team id and game object');
    }
    try {
      var team = await teamRepository.get(id);
      if (team != null) {
        team.incrementWonGamesByOne(game);
        await teamRepository.update(team);
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

  @override
  Future<List<Team>> getAllTeamOfPlayer(String? playerId, int? pageSize) async {
    if (playerId == null || pageSize == null) {
      throw ServiceException('Please use a non null player id and page size');
    }
    try {
      var teams = await teamRepository.getAllTeamOfPlayer(playerId, pageSize);

      return teams;
    } on RepositoryException catch (e) {
      throw ServiceException(
        'Error during the team fetching : ${e.toString()}',
      );
    }
  }
}
