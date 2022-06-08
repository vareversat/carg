import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/repositories/impl/score/french_belote_score_repository.dart';
import 'package:carg/services/impl/score/french_belote_score_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'french_belote_score_service_test.mocks.dart';

@GenerateMocks([
  FrenchBeloteScoreRepository,
])
void main() {
  final mockFrenchBeloteScoreRepository = MockFrenchBeloteScoreRepository();
  const uid = '123';
  const scoreId = 'score_123';
  final frenchBeloteScore = FrenchBeloteScore(game: uid);

  setUp(() {
    reset(mockFrenchBeloteScoreRepository);
  });

  group('FrenchBeloteScoreService', () {
    group('Generate New Score', () {
      test('OK', () async {
        when(mockFrenchBeloteScoreRepository.create(frenchBeloteScore))
            .thenAnswer((_) async => Future<String>(() => scoreId));
        final frenchBeloteScoreService = FrenchBeloteScoreService(
            frenchBeloteScoreRepository: mockFrenchBeloteScoreRepository);
        expect(await frenchBeloteScoreService.generateNewScore(uid),
            frenchBeloteScore);
        verify(mockFrenchBeloteScoreRepository.create(frenchBeloteScore))
            .called(1);
      });
    });
  });
}
