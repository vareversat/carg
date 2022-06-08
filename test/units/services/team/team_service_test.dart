import 'package:carg/exceptions/repository_exception.dart';
import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/impl/team_repository.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'team_service_test.mocks.dart';

const uid = '123';
var playerIds = ['p1', 'p2'];

@GenerateMocks([
  TeamRepository,
  PlayerService,
])
void main() {
  final mockTeamRepository = MockTeamRepository();
  final mockPlayerService = MockPlayerService();
  final game = FrenchBelote();
  setUp(() {
    reset(mockTeamRepository);
    reset(mockPlayerService);
  });

  group('TeamService - ', () {
    group('Get Team By Players', () {
      test('Team exists', () async {
        final team =
            Team(id: uid, wonGames: 0, playedGames: 1, players: ['p1', 'p2']);
        final expectedTeam =
            Team(id: uid, wonGames: 0, playedGames: 1, players: ['p1', 'p2']);
        when(mockTeamRepository.getTeamByPlayers(playerIds))
            .thenAnswer((_) async => Future<Team?>(() => team));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(await teamService.getTeamByPlayers(playerIds), expectedTeam);
        verify(mockTeamRepository.getTeamByPlayers(playerIds)).called(1);
        verifyNever(mockTeamRepository.createTeamWithPlayers(playerIds));
      });

      test('Team does not exist', () async {
        final team =
            Team(id: uid, wonGames: 0, playedGames: 1, players: ['p1', 'p2']);
        final expectedTeam =
            Team(id: uid, wonGames: 0, playedGames: 1, players: ['p1', 'p2']);
        when(mockTeamRepository.getTeamByPlayers(playerIds))
            .thenAnswer((_) async => Future<Team?>(() => null));
        when(mockTeamRepository.createTeamWithPlayers(playerIds))
            .thenAnswer((_) async => Future<Team>(() => team));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(await teamService.getTeamByPlayers(playerIds), expectedTeam);
        verify(mockTeamRepository.getTeamByPlayers(playerIds)).called(1);
        verify(mockTeamRepository.createTeamWithPlayers(playerIds)).called(1);
      });

      test('Throw exception (from repository)', () async {
        when(mockTeamRepository.getTeamByPlayers(playerIds))
            .thenThrow(RepositoryException('error'));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.getTeamByPlayers(playerIds),
            throwsA(isA<ServiceException>()));
        verify(mockTeamRepository.getTeamByPlayers(playerIds)).called(1);
        verifyNever(mockTeamRepository.createTeamWithPlayers(playerIds));
      });

      test('Throw exception (from service)', () async {
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.getTeamByPlayers(null),
            throwsA(isA<ServiceException>()));
        verifyNever(mockTeamRepository.getTeamByPlayers(playerIds));
        verifyNever(mockTeamRepository.createTeamWithPlayers(playerIds));
      });
    });

    group('Increment played games', () {
      test('Team exists', () async {
        final gameStat =
            GameStats(gameType: GameType.COINCHE, wonGames: 0, playedGames: 1);
        final team =
            Team(id: uid, gameStatsList: [gameStat], players: ['p1', 'p2']);

        when(mockTeamRepository.get(uid))
            .thenAnswer((_) async => Future<Team?>(() => team));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(
            (await teamService.incrementPlayedGamesByOne(uid, game))
                .totalPlayedGames(),
            2);
        verify(mockTeamRepository.update(team));
        verify(mockPlayerService.incrementPlayedGamesByOne('p1', game))
            .called(1);
      });

      test('Team does not exist', () async {
        final team =
            Team(id: uid, wonGames: 0, playedGames: 1, players: ['p1', 'p2']);
        when(mockTeamRepository.get(uid))
            .thenAnswer((_) async => Future<Team?>(() => null));
        when(mockTeamRepository.createTeamWithPlayers(playerIds))
            .thenAnswer((_) async => Future<Team>(() => team));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.incrementPlayedGamesByOne(null, game),
            throwsA(isA<ServiceException>()));
      });

      test('Throw exception (from repository)', () async {
        when(mockTeamRepository.get(uid))
            .thenThrow(RepositoryException('error'));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.incrementPlayedGamesByOne(uid, game),
            throwsA(isA<ServiceException>()));
      });

      test('Throw exception GAME (from service)', () async {
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.incrementPlayedGamesByOne(uid, null),
            throwsA(isA<ServiceException>()));
      });

      test('Throw exception GAME (team = null)', () async {
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        when(mockTeamRepository.get(uid))
            .thenAnswer((_) async => Future<Team?>(() => null));
        expect(teamService.incrementPlayedGamesByOne(uid, game),
            throwsA(isA<ServiceException>()));
      });
    });

    group('Increment won games', () {
      final gameStat =
          GameStats(gameType: GameType.COINCHE, wonGames: 0, playedGames: 0);
      final team =
          Team(id: uid, gameStatsList: [gameStat], players: ['p1', 'p2']);
      test('Team exists', () async {
        when(mockTeamRepository.get(uid))
            .thenAnswer((_) async => Future<Team?>(() => team));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        final editedTeam = await teamService.incrementWonGamesByOne(uid, game);
        expect(editedTeam.totalWonGames(), 1);
        expect(editedTeam.totalPlayedGames(), 0);
        verify(mockTeamRepository.update(team));
        verify(mockPlayerService.incrementWonGamesByOne('p1', game)).called(1);
        verify(mockPlayerService.incrementWonGamesByOne('p2', game)).called(1);
      });

      test('Team does not exist', () async {
        when(mockTeamRepository.get(uid))
            .thenAnswer((_) async => Future<Team?>(() => null));
        when(mockTeamRepository.createTeamWithPlayers(playerIds))
            .thenAnswer((_) async => Future<Team>(() => team));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.incrementWonGamesByOne(null, game),
            throwsA(isA<ServiceException>()));
      });

      test('Throw exception (from repository)', () async {
        when(mockTeamRepository.get(uid))
            .thenThrow(RepositoryException('error'));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.incrementWonGamesByOne(uid, game),
            throwsA(isA<ServiceException>()));
      });
      test('Throw exception GAME (from service)', () async {
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.incrementWonGamesByOne(uid, null),
            throwsA(isA<ServiceException>()));
      });
      test('Throw exception GAME (team = null)', () async {
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        when(mockTeamRepository.get(uid))
            .thenAnswer((_) async => Future<Team?>(() => null));
        expect(teamService.incrementWonGamesByOne(uid, game),
            throwsA(isA<ServiceException>()));
      });
    });
    group('Get all teams of players', () {
      test('Teams exist', () async {
        const playerId = 'p1';
        const pageSize = 10;
        final List<Team> teams = [
          Team(id: uid, players: ['p1', 'p2']),
          Team(id: uid, players: ['p1', 'p2'])
        ];
        when(mockTeamRepository.getAllTeamOfPlayer(playerId, pageSize))
            .thenAnswer((_) async => Future<List<Team>>(() => teams));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);

        expect(await teamService.getAllTeamOfPlayer(playerId, pageSize), teams);
        verify(mockTeamRepository.getAllTeamOfPlayer(playerId, pageSize))
            .called(1);
      });

      test('Throw exception GAME (playerId = null)', () async {
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.getAllTeamOfPlayer(null, 10),
            throwsA(isA<ServiceException>()));
      });

      test('Throw exception GAME (page = null)', () async {
        const playerId = 'p1';
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.getAllTeamOfPlayer(playerId, null),
            throwsA(isA<ServiceException>()));
      });

      test('Throw exception (from repository)', () async {
        const playerId = 'p1';
        when(mockTeamRepository.getAllTeamOfPlayer(playerId, 10))
            .thenThrow(RepositoryException('error'));
        final teamService = TeamService(
            teamRepository: mockTeamRepository,
            playerService: mockPlayerService);
        expect(teamService.getAllTeamOfPlayer(playerId, 10),
            throwsA(isA<ServiceException>()));
      });
    });
  });
}
