import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/game/abstract_belote_game_repository.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:carg/services/score/abstract_belote_score_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/fake_belote_game.dart';
import '../../mocks/fake_belote_game_setting.dart';
import '../../mocks/fake_belote_score.dart';
import '../../mocks/fake_belote_score_service.dart';
import 'abstract_belote_game_service_test.mocks.dart';

@GenerateMocks(
    [AbstractBeloteScoreService, AbstractBeloteGameRepository, TeamService])
void main() {
  final mockBeloteScoreService = MockAbstractBeloteScoreService();
  final mockBeloteGameRepository = MockAbstractBeloteGameRepository();
  final mockTeamService = MockTeamService();

  const uid = '123';

  final date = DateTime.parse('2022-04-10 00:00:00.000');
  final playerIds = ['p1', 'p2', 'p3', 'p4'];
  final teamUs = Team(id: 'usTeamId', players: ['p2', 'p3']);
  final teamThem = Team(id: 'themTeamId', players: ['p1', 'p4']);
  final beloteScore = FakeBeloteScore(usTotalPoints: 200, themTotalPoints: 100);
  final beloteTIEScore =
      FakeBeloteScore(usTotalPoints: 200, themTotalPoints: 200);
  final players =
      BelotePlayers(us: teamUs.id, them: teamThem.id, playerList: playerIds);

  final game = FakeBeloteGame(
    uid,
    date,
    players,
    FakeBeloteGameSetting(
      maxPoint: 1000,
      isInfinite: false,
      addContractToScore: true,
    ),
  );
  final gameNoId = FakeBeloteGame(
    null,
    date,
    players,
    FakeBeloteGameSetting(
      maxPoint: 1000,
      isInfinite: false,
      addContractToScore: true,
    ),
  );

  group('AbstractBeloteGameService', () {
    group('End a game', () {
      test('OK', () async {
        when(mockBeloteScoreService.getScoreByGame(uid))
            .thenAnswer((_) => Future(() => beloteScore));
        when(mockTeamService.incrementPlayedGamesByOne('themTeamId', game))
            .thenAnswer((_) => Future(() => Team()));
        when(mockTeamService.incrementPlayedGamesByOne('usTeamId', game))
            .thenAnswer((_) => Future(() => Team()));
        when(mockTeamService.incrementWonGamesByOne('usTeamId', game))
            .thenAnswer((_) => Future(() => Team()));
        final beloteGameService = FakeBeloteGameService(
            beloteScoreService: mockBeloteScoreService,
            beloteGameRepository: mockBeloteGameRepository,
            teamService: mockTeamService);
        await beloteGameService.endAGame(game, date);
        verify(mockTeamService.incrementPlayedGamesByOne('usTeamId', game))
            .called(1);
        verify(mockTeamService.incrementPlayedGamesByOne('themTeamId', game))
            .called(1);
        verify(mockTeamService.incrementWonGamesByOne('usTeamId', game))
            .called(1);
      });

      test('NOK - TIE', () async {
        when(mockBeloteScoreService.getScoreByGame(uid))
            .thenAnswer((_) => Future(() => beloteTIEScore));
        final beloteGameService = FakeBeloteGameService(
            beloteScoreService: mockBeloteScoreService,
            beloteGameRepository: mockBeloteGameRepository,
            teamService: mockTeamService);
        expect(beloteGameService.endAGame(game, date),
            throwsA(isA<ServiceException>()));
      });
    });

    group('Create Game With Player List', () {
      test('OK', () async {
        final playerIdsOrder = ['p1', 'p2', 'p3', 'p4'];
        final playerIdsTeam = ['p2', 'p3', 'p1', 'p4'];
        when(mockTeamService.getTeamByPlayers(['p2', 'p3']))
            .thenAnswer((_) => Future(() => teamUs));
        when(mockTeamService.getTeamByPlayers(['p1', 'p4']))
            .thenAnswer((_) => Future(() => teamThem));
        when(mockBeloteGameRepository.create(gameNoId))
            .thenAnswer((_) => Future(() => uid));
        when(mockBeloteScoreService.generateNewScore(uid))
            .thenAnswer((_) => Future(() => beloteScore));
        final beloteGameService = FakeBeloteGameService(
            beloteScoreService: mockBeloteScoreService,
            beloteGameRepository: mockBeloteGameRepository,
            teamService: mockTeamService);
        final finalGame = await beloteGameService.createGameWithPlayerList(
            playerIdsOrder, playerIdsTeam, date);
        expect(finalGame, game);
      });
    });
  });
}
