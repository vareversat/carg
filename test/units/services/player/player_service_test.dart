import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/player.dart';
import 'package:carg/repositories/impl/player_repository.dart';
import 'package:carg/services/impl/game/french_belote_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/round/french_belote_round_service.dart';
import 'package:carg/services/impl/score/french_belote_score_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'player_service_test.mocks.dart';

const uid = '123';
const userId = '123_user';

@GenerateMocks([
  PlayerRepository,
  FrenchBeloteGameService,
  FrenchBeloteScoreService,
  FrenchBeloteRoundService
])
void main() {
  final mockPlayerRepository = MockPlayerRepository();
  final mockFrenchBeloteGameService = MockFrenchBeloteGameService();
  final mockFrenchBeloteScoreService = MockFrenchBeloteScoreService();
  final mockFrenchBeloteRoundService = MockFrenchBeloteRoundService();
  final game = FrenchBelote(
      gameService: mockFrenchBeloteGameService,
      scoreService: mockFrenchBeloteScoreService,
      roundService: mockFrenchBeloteRoundService);

  setUp(() {
    reset(mockPlayerRepository);
  });

  group('PlayerService - ', () {
    group('Create', () {
      test('OK', () async {
        final player = Player(owned: true, userName: 'test');
        when(mockPlayerRepository.create(player))
            .thenAnswer((_) async => Future<String>(() => uid));
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        expect(await playerService.create(player), uid);
        verify(mockPlayerRepository.create(player)).called(1);
      });

      test('Throw exception', () {
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        expect(playerService.create(null), throwsA(isA<ServiceException>()));
        verifyNever(mockPlayerRepository.create(null));
      });
    });

    group('Increment played games', () {
      test('Player exists', () async {
        final player = Player(owned: true, id: uid);
        when(mockPlayerRepository.get(uid))
            .thenAnswer((_) async => Future<Player?>(() => player));
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        await playerService.incrementPlayedGamesByOne(uid, game);
        verify(mockPlayerRepository.update(player)).called(1);
      });

      test('Player does not exist', () async {
        final player = Player(owned: true, id: uid);
        when(mockPlayerRepository.get(uid))
            .thenAnswer((_) async => Future<Player?>(() => null));
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        expect(playerService.incrementPlayedGamesByOne(uid, game),
            throwsA(isA<ServiceException>()));
        verify(mockPlayerRepository.get(uid)).called(1);
        verifyNever(mockPlayerRepository.update(player));
      });

      test('Throw exception Id null', () async {
        final player = Player(owned: true, id: uid);
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        expect(playerService.incrementPlayedGamesByOne(null, game),
            throwsA(isA<ServiceException>()));
        verifyNever(mockPlayerRepository.get(uid));
        verifyNever(mockPlayerRepository.update(player));
      });

      test('Throw exception Game null', () async {
        final player = Player(owned: true, id: uid);
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        expect(playerService.incrementPlayedGamesByOne(uid, null),
            throwsA(isA<ServiceException>()));
        verifyNever(mockPlayerRepository.get(uid));
        verifyNever(mockPlayerRepository.update(player));
      });
    });

    group('Increment won games', () {
      test('Player exists', () async {
        final player = Player(owned: true, id: uid);
        when(mockPlayerRepository.get(uid))
            .thenAnswer((_) async => Future<Player?>(() => player));
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        await playerService.incrementWonGamesByOne(uid, game);
        verify(mockPlayerRepository.update(player)).called(1);
      });

      test('Player does not exist', () async {
        final player = Player(owned: true, id: uid);
        when(mockPlayerRepository.get(uid))
            .thenAnswer((_) async => Future<Player?>(() => null));
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        expect(playerService.incrementWonGamesByOne(uid, game),
            throwsA(isA<ServiceException>()));
        verify(mockPlayerRepository.get(uid)).called(1);
        verifyNever(mockPlayerRepository.update(player));
      });

      test('Throw exception Id null', () async {
        final player = Player(owned: true, id: uid);
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        expect(playerService.incrementWonGamesByOne(null, game),
            throwsA(isA<ServiceException>()));
        verifyNever(mockPlayerRepository.get(uid));
        verifyNever(mockPlayerRepository.update(player));
      });

      test('Throw exception Game null', () async {
        final player = Player(owned: true, id: uid);
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        expect(playerService.incrementWonGamesByOne(uid, null),
            throwsA(isA<ServiceException>()));
        verifyNever(mockPlayerRepository.get(uid));
        verifyNever(mockPlayerRepository.update(player));
      });
    });

    group('Get player of user', () {
      test('OK', () async {
        final player = Player(owned: true, linkedUserId: userId);
        when(mockPlayerRepository.getPlayerOfUser(userId))
            .thenAnswer((_) async => Future<Player?>(() => player));
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        expect(await playerService.getPlayerOfUser(userId), player);
        verify(mockPlayerRepository.getPlayerOfUser(userId)).called(1);
      });

      test('Throw exception', () async {
        final playerService =
            PlayerService(playerRepository: mockPlayerRepository);
        expect(playerService.getPlayerOfUser(null),
            throwsA(isA<ServiceException>()));
        verifyNever(mockPlayerRepository.getPlayerOfUser(null));
      });
    });
  });
}
