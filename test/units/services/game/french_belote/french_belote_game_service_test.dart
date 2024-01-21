import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/setting/french_belote_game_setting.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/impl/game/french_belote_game_repository.dart';
import 'package:carg/services/impl/game/french_belote_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/score/french_belote_score_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'french_belote_game_service_test.mocks.dart';

@GenerateMocks([
  FrenchBeloteScoreService,
  FrenchBeloteGameRepository,
  PlayerService,
  TeamService
])
void main() {
  final mockFrenchBeloteScoreService = MockFrenchBeloteScoreService();
  final mockFrenchBeloteGameRepository = MockFrenchBeloteGameRepository();
  final mockTeamService = MockTeamService();

  const uid = '123';

  final date = DateTime.parse('2022-04-10 00:00:00.000');
  final playerIds = ['p1', 'p2', 'p3', 'p4'];
  final teamUs = Team(id: 'usTeamId', players: ['p1', 'p2']);
  final teamThem = Team(id: 'themTeamId', players: ['p3', 'p4']);
  final players =
      BelotePlayers(us: teamUs.id, them: teamThem.id, playerList: playerIds);

  final expectedGame =
      FrenchBelote(id: uid, players: players, startingDate: date);
  final expectedGameNoId = FrenchBelote(players: players, startingDate: date);
  final settings = FrenchBeloteGameSetting(
      maxPoint: 1000, isInfinite: false, sumTrickPointsAndContract: true);

  group('FrenchBeloteGameService', () {
    group('Generate a new game', () {
      test('OK', () async {
        when(mockFrenchBeloteGameRepository.create(expectedGameNoId))
            .thenAnswer((_) => Future(() => uid));
        final frenchBeloteGameService = FrenchBeloteGameService(
            frenchBeloteScoreService: mockFrenchBeloteScoreService,
            frenchBeloteGameRepository: mockFrenchBeloteGameRepository,
            teamService: mockTeamService);
        final game = await frenchBeloteGameService.generateNewGame(
            teamUs, teamThem, playerIds, date, settings);
        expect(game, expectedGame);
      });
    });
  });
}
