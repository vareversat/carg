import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:carg/models/score/score.dart';
import 'package:carg/repositories/score/abstract_score_repository.dart';
import 'package:carg/services/score/abstract_score_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'abstract_score_service_test.mocks.dart';

class FakeScoreService extends AbstractScoreService {
  FakeScoreService(
      {required AbstractScoreRepository<Score<Round>> scoreRepository})
      : super(scoreRepository: scoreRepository);
}

class FakeScore extends Score {
  FakeScore(String? id) : super(id: id);

  @override
  Score<Round> deleteLastRound() {
    throw UnimplementedError();
  }

  @override
  Round getLastRound() {
    throw UnimplementedError();
  }

  @override
  Score<Round> replaceLastRound(Round round) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJSON() {
    throw UnimplementedError();
  }
}

@GenerateMocks([
  AbstractScoreRepository,
])
void main() {
  final mockAbstractScoreRepository = MockAbstractScoreRepository();
  const uid = '123';
  const scoreId = 'score_123';
  final score = FakeScore(scoreId);

  setUp(() {
    reset(mockAbstractScoreRepository);
  });

  group('AbstractScoreService', () {
    group('Get score by game', () {
      test('OK', () async {
        when(mockAbstractScoreRepository.getScoreByGame(uid))
            .thenAnswer((_) async => Future(() => score));
        final scoreService =
            FakeScoreService(scoreRepository: mockAbstractScoreRepository);
        expect(await scoreService.getScoreByGame(uid), score);
      });

      test('NOK - Exception', () {
        final scoreService =
            FakeScoreService(scoreRepository: mockAbstractScoreRepository);
        expect(scoreService.getScoreByGame(null),
            throwsA(isA<ServiceException>()));
      });
    });

    group('Get score by game STREAM', () {
      test('OK', () {
        when(mockAbstractScoreRepository.getScoreByGameStream(uid))
            .thenAnswer((_) => Stream.value(score));
        final scoreService =
            FakeScoreService(scoreRepository: mockAbstractScoreRepository);
        scoreService.getScoreByGameStream(uid);
      });

      test('NOK - Exception', () async* {
        final scoreService =
            FakeScoreService(scoreRepository: mockAbstractScoreRepository);
        expect(scoreService.getScoreByGameStream(null),
            throwsA(isA<ServiceException>()));
      });
    });

    group('Delete score by game', () {
      test('OK', () async {
        final scoreService =
            FakeScoreService(scoreRepository: mockAbstractScoreRepository);
        await scoreService.deleteScoreByGame(uid);
        verify(mockAbstractScoreRepository.deleteScoreByGame(uid)).called(1);
      });

      test('NOK - Exception', () {
        final scoreService =
            FakeScoreService(scoreRepository: mockAbstractScoreRepository);
        expect(scoreService.deleteScoreByGame(null),
            throwsA(isA<ServiceException>()));
      });
    });
  });
}
