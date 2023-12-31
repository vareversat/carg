import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/setting/game_setting.dart';
import 'package:carg/models/players/players.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';

class FakeGameService extends AbstractGameService {
  FakeGameService(
      {required super.scoreService,
      required super.gameRepository,
      required AbstractPlayerService playerService,
      required AbstractTeamService teamService});

  @override
  Future<Game<Players, GameSetting>> createGameWithPlayerList(
      List<String?> playerListForOrder,
      List<String?> playerListForTeam,
      DateTime? startingDate,
      GameSetting settings) {
    throw UnimplementedError();
  }

  @override
  Future<void> endAGame(Game<Players, GameSetting> game, DateTime? endingDate) {
    throw UnimplementedError();
  }
}
