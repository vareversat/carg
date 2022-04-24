import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/team.dart';
import 'package:carg/repositories/game/abstract_belote_game_repository.dart';
import 'package:carg/services/game/abstract_belote_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/score/abstract_belote_score_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'abstract_belote_game_service_test.mocks.dart';

class FakeBeloteGame extends Belote {
  FakeBeloteGame(String? id, DateTime startingDate, BelotePlayers players)
      : super(players: players, id: id, startingDate: startingDate);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is FakeBeloteGame &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => super.hashCode;
}

class FakeBeloteScore extends BeloteScore {
  FakeBeloteScore({required int usTotalPoints, required int themTotalPoints})
      : super(usTotalPoints: usTotalPoints, themTotalPoints: themTotalPoints);
}

class FakeBeloteGameService extends AbstractBeloteGameService {
  FakeBeloteGameService(
      {required AbstractBeloteScoreService<BeloteScore<BeloteRound>>
          beloteScoreService,
      required AbstractBeloteGameRepository<Belote<BelotePlayers>>
          beloteGameRepository,
      required AbstractPlayerService playerService,
      required AbstractTeamService teamService})
      : super(
            beloteScoreService: beloteScoreService,
            beloteGameRepository: beloteGameRepository,
            playerService: playerService,
            teamService: teamService);

  @override
  Future<Belote<BelotePlayers>> generateNewGame(Team us, Team them,
      List<String?>? playerListForOrder, DateTime? startingDate) async {
    try {
      var belote = FakeBeloteGame(
          null,
          startingDate!,
          BelotePlayers(
              us: us.id, them: them.id, playerList: playerListForOrder));
      belote.id = await beloteGameRepository.create(belote);
      return belote;
    } on Exception catch (e) {
      throw ServiceException(
          'Error while generating a new game : ${e.toString()}');
    }
  }
}

@GenerateMocks([
  AbstractBeloteScoreService,
  AbstractBeloteGameRepository,
  PlayerService,
  TeamService
])
void main() {
  final mockBeloteScoreService =
      MockAbstractBeloteScoreService<FakeBeloteScore>();
  final mockBeloteGameRepository = MockAbstractBeloteGameRepository();
  final mockPlayerService = MockPlayerService();
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

  final game = FakeBeloteGame(uid, date, players);
  final gameNoId = FakeBeloteGame(null, date, players);

  group('FrenchBeloteGameService', () {
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
            playerService: mockPlayerService,
            teamService: mockTeamService);
        await beloteGameService.endAGame(game, date);
        verify(mockTeamService.incrementPlayedGamesByOne('usTeamId', game))
            .called(1);
        verify(mockTeamService.incrementPlayedGamesByOne('themTeamId', game))
            .called(1);
        verify(mockPlayerService.incrementPlayedGamesByOne('p1', game))
            .called(1);
        verify(mockPlayerService.incrementPlayedGamesByOne('p2', game))
            .called(1);
        verify(mockPlayerService.incrementPlayedGamesByOne('p3', game))
            .called(1);
        verify(mockPlayerService.incrementPlayedGamesByOne('p4', game))
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
            playerService: mockPlayerService,
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
            playerService: mockPlayerService,
            teamService: mockTeamService);
        final finalGame = await beloteGameService.createGameWithPlayerList(
            playerIdsOrder, playerIdsTeam, date);
        expect(finalGame, game);
      });
    });

    group('Get All Games Of Player Paginated', () {
      test('OK', () async {
        const userID = 'user_123';
        const pageSize = 10;
        when(mockBeloteGameRepository.getAllGamesOfPlayer(userID, pageSize))
            .thenAnswer((_) => Future(() => [game]));
        final beloteGameService = FakeBeloteGameService(
            beloteScoreService: mockBeloteScoreService,
            beloteGameRepository: mockBeloteGameRepository,
            playerService: mockPlayerService,
            teamService: mockTeamService);
        final finalGames = await beloteGameService.getAllGamesOfPlayerPaginated(
            userID, pageSize);
        expect(finalGames, [game]);
      });
    });

    group('Get All Games Of Player Paginated', () {
      test('NOK - No userID', () async {
        const pageSize = 10;
        final beloteGameService = FakeBeloteGameService(
            beloteScoreService: mockBeloteScoreService,
            beloteGameRepository: mockBeloteGameRepository,
            playerService: mockPlayerService,
            teamService: mockTeamService);
        expect(beloteGameService.getAllGamesOfPlayerPaginated(null, pageSize),
            throwsA(isA<ServiceException>()));
      });

      test('NOK - No page size', () async {
        const userID = 'user_123';
        final beloteGameService = FakeBeloteGameService(
            beloteScoreService: mockBeloteScoreService,
            beloteGameRepository: mockBeloteGameRepository,
            playerService: mockPlayerService,
            teamService: mockTeamService);
        expect(beloteGameService.getAllGamesOfPlayerPaginated(userID, null),
            throwsA(isA<ServiceException>()));
      });
    });
  });
}
