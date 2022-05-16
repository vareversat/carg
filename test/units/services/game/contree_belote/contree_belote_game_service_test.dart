import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/impl/game/contree_belote_game_repository.dart';
import 'package:carg/services/impl/game/contree_belote_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/score/contree_belote_score_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contree_belote_game_service_test.mocks.dart';

@GenerateMocks([
  ContreeBeloteScoreService,
  ContreeBeloteGameRepository,
  PlayerService,
  TeamService
])
void main() {
  final mockContreeBeloteScoreService = MockContreeBeloteScoreService();
  final mockContreeBeloteGameRepository = MockContreeBeloteGameRepository();
  final mockPlayerService = MockPlayerService();
  final mockTeamService = MockTeamService();

  const uid = '123';

  final date = DateTime.parse('2022-04-10 00:00:00.000');
  final playerIds = ['p1', 'p2', 'p3', 'p4'];
  final teamUs = Team(id: 'usTeamId', players: ['p1', 'p2']);
  final teamThem = Team(id: 'themTeamId', players: ['p3', 'p4']);
  final players =
  BelotePlayers(us: teamUs.id, them: teamThem.id, playerList: playerIds);

  final expectedGame =
  ContreeBelote(id: uid, players: players, startingDate: date);
  final expectedGameNoId = ContreeBelote(players: players, startingDate: date);

  group('ContreeBeloteGameService', () {
    group('Generate a new game', () {
      test('OK', () async {
        when(mockContreeBeloteGameRepository.create(expectedGameNoId))
            .thenAnswer((_) => Future(() => uid));
        final contreeBeloteGameService = ContreeBeloteGameService(
            contreeBeloteScoreService: mockContreeBeloteScoreService,
            contreeBeloteGameRepository: mockContreeBeloteGameRepository,
            playerService: mockPlayerService,
            teamService: mockTeamService);
        final game = await contreeBeloteGameService.generateNewGame(
            teamUs, teamThem, playerIds, date);
        expect(game, expectedGame);
      });
    });
  });
}
