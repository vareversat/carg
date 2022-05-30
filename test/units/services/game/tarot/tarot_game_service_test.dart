import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/players/tarot_players.dart';
import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/repositories/impl/game/tarot_game_repository.dart';
import 'package:carg/services/impl/game/tarot_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/score/tarot_score_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tarot_game_service_test.mocks.dart';

@GenerateMocks(
    [TarotScoreService, TarotGameRepository, PlayerService, TeamService])
void main() {
  final mockTarotScoreService = MockTarotScoreService();
  final mockTarotGameRepository = MockTarotGameRepository();
  final mockPlayerService = MockPlayerService();

  const uid = '123';

  final date = DateTime.parse('2022-04-10 00:00:00.000');
  final tarotPlayerScore = TarotPlayerScore(score: 1000, player: 'p1');
  final tarotPlayerScore2 = TarotPlayerScore(score: 800, player: 'p2');
  const players = ['p1', 'p2'];

  final score = TarotScore(
      game: uid,
      totalPoints: [tarotPlayerScore, tarotPlayerScore2],
      rounds: [TarotRound(attackScore: 100.0, defenseScore: 12.0)],
      players: players);

  final game = Tarot(
      id: uid,
      startingDate: date,
      players: TarotPlayers(playerList: ['p1', 'p2']));
  final gameNoId = Tarot(
      startingDate: date, players: TarotPlayers(playerList: ['p1', 'p2']));

  group('TarotGameService', () {
    group('End a game', () {
      test('OK', () async {
        when(mockTarotScoreService.getScoreByGame(uid))
            .thenAnswer((_) => Future(() => score));
        final tarotGameService = TarotGameService(
            tarotScoreService: mockTarotScoreService,
            tarotGameRepository: mockTarotGameRepository,
            playerService: mockPlayerService);
        await tarotGameService.endAGame(game, date);
        verify(mockPlayerService.incrementPlayedGamesByOne('p1', game))
            .called(1);
        verify(mockPlayerService.incrementPlayedGamesByOne('p2', game))
            .called(1);
        verify(mockPlayerService.incrementWonGamesByOne('p1', game)).called(1);
      });

      test('Throw exception', () async {
        final tarotGameService = TarotGameService(
            tarotScoreService: mockTarotScoreService,
            tarotGameRepository: mockTarotGameRepository,
            playerService: mockPlayerService);
        expect(tarotGameService.endAGame(null, null),
            throwsA(isA<ServiceException>()));
      });

      test('Throw exception 2', () async {
        when(mockTarotScoreService.getScoreByGame(uid))
            .thenAnswer((_) => Future(() => null));
        final tarotGameService = TarotGameService(
            tarotScoreService: mockTarotScoreService,
            tarotGameRepository: mockTarotGameRepository,
            playerService: mockPlayerService);
        expect(tarotGameService.endAGame(game, date),
            throwsA(isA<ServiceException>()));
      });
    });

    group('Create game with players', () {
      test('OK', () async {
        when(mockTarotGameRepository.create(gameNoId))
            .thenAnswer((_) => Future(() => uid));
        when(mockTarotScoreService.create(score))
            .thenAnswer((_) => Future(() => 'scoreId'));
        final tarotGameService = TarotGameService(
            tarotScoreService: mockTarotScoreService,
            tarotGameRepository: mockTarotGameRepository,
            playerService: mockPlayerService);

        await tarotGameService.createGameWithPlayerList(players, players, date);
        verify(mockTarotGameRepository.create(game)).called(1);
        verify(mockTarotScoreService.create(score)).called(1);
      });
    });
  });
}
