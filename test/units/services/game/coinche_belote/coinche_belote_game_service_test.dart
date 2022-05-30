import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/impl/game/coinche_belote_game_repository.dart';
import 'package:carg/services/impl/game/coinche_belote_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/score/coinche_belote_score_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'coinche_belote_game_service_test.mocks.dart';

@GenerateMocks([
  CoincheBeloteScoreService,
  CoincheBeloteGameRepository,
  PlayerService,
  TeamService
])
void main() {
  final mockCoincheBeloteScoreService = MockCoincheBeloteScoreService();
  final mockCoincheBeloteGameRepository = MockCoincheBeloteGameRepository();
  final mockTeamService = MockTeamService();

  const uid = '123';

  final date = DateTime.parse('2022-04-10 00:00:00.000');
  final playerIds = ['p1', 'p2', 'p3', 'p4'];
  final teamUs = Team(id: 'usTeamId', players: ['p1', 'p2']);
  final teamThem = Team(id: 'themTeamId', players: ['p3', 'p4']);
  final players =
      BelotePlayers(us: teamUs.id, them: teamThem.id, playerList: playerIds);

  final expectedGame =
      CoincheBelote(id: uid, players: players, startingDate: date);
  final expectedGameNoId = CoincheBelote(players: players, startingDate: date);

  group('CoincheBeloteGameService', () {
    group('Generate a new game', () {
      test('OK', () async {
        when(mockCoincheBeloteGameRepository.create(expectedGameNoId))
            .thenAnswer((_) => Future(() => uid));
        final coincheBeloteGameService = CoincheBeloteGameService(
            coincheBeloteScoreService: mockCoincheBeloteScoreService,
            coincheBeloteGameRepository: mockCoincheBeloteGameRepository,
            teamService: mockTeamService);
        final game = await coincheBeloteGameService.generateNewGame(
            teamUs, teamThem, playerIds, date);
        expect(game, expectedGame);
      });
    });
  });
}
