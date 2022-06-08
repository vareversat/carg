import 'package:carg/models/game/game.dart';
import 'package:carg/models/players/players.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:carg/models/score/score.dart';
import 'package:carg/repositories/game/abstract_game_repository.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/score/abstract_score_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';

class FakeGameService extends AbstractGameService {
  FakeGameService(
      {required AbstractScoreService<Score<Round>> scoreService,
      required AbstractGameRepository<Game<Players>> gameRepository,
      required AbstractPlayerService playerService,
      required AbstractTeamService teamService})
      : super(
          scoreService: scoreService,
          gameRepository: gameRepository,
        );

  @override
  Future<Game<Players>> createGameWithPlayerList(
      List<String?> playerListForOrder,
      List<String?> playerListForTeam,
      DateTime? startingDate) {
    throw UnimplementedError();
  }

  @override
  Future<void> endAGame(Game<Players> game, DateTime? endingDate) {
    throw UnimplementedError();
  }
}
