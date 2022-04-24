import 'package:carg/models/score/coinche_belote_score.dart';
import 'package:carg/repositories/impl/score/coinche_belote_score_repository.dart';
import 'package:carg/services/impl/score/coinche_belote_score_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'coinche_belote_score_service_test.mocks.dart';

@GenerateMocks([
  CoincheBeloteScoreRepository,
])
void main() {
  final mockCoincheBeloteScoreRepository = MockCoincheBeloteScoreRepository();
  const uid = '123';
  const scoreId = 'score_123';
  final coincheBeloteScore = CoincheBeloteScore(game: uid);

  setUp(() {
    reset(mockCoincheBeloteScoreRepository);
  });

  group('CoincheBeloteScoreService', () {
    group('Generate New Score', () {
      test('OK', () async {
        when(mockCoincheBeloteScoreRepository.create(coincheBeloteScore))
            .thenAnswer((_) async => Future<String>(() => scoreId));
        final coincheBeloteScoreService = CoincheBeloteScoreService(
            coincheBeloteScoreRepository: mockCoincheBeloteScoreRepository);
        expect(await coincheBeloteScoreService.generateNewScore(uid),
            coincheBeloteScore);
        verify(mockCoincheBeloteScoreRepository.create(coincheBeloteScore)).called(1);
      });
    });
  });
}
