import 'package:carg/repositories/impl/team_repository.dart';
import 'package:carg/repositories/team/abstract_team_repository.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';

class TeamService extends AbstractTeamService {
  TeamService(
      {AbstractTeamRepository? teamRepository,
      AbstractPlayerService? playerService})
      : super(
            teamRepository: teamRepository ?? TeamRepository(),
            playerService: playerService ?? PlayerService());
}
