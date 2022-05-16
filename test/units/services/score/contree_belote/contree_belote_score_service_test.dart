import 'package:carg/models/score/contree_belote_score.dart';
import 'package:carg/repositories/impl/score/contree_belote_score_repository.dart';
import 'package:carg/services/impl/score/contree_belote_score_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contree_belote_score_service_test.mocks.dart';

@GenerateMocks([
  ContreeBeloteScoreRepository,
])
void main() {
  final mockContreeBeloteScoreRepository = MockContreeBeloteScoreRepository();
  const uid = '123';
  const scoreId = 'score_123';
  final contreeBeloteScore = ContreeBeloteScore(game: uid);

  setUp(() {
    reset(mockContreeBeloteScoreRepository);
  });

  group('ContreeBeloteScoreService', () {
    group('Generate New Score', () {
      test('OK', () async {
        when(mockContreeBeloteScoreRepository.create(contreeBeloteScore))
            .thenAnswer((_) async => Future<String>(() => scoreId));
        final contreeBeloteScoreService = ContreeBeloteScoreService(
            contreeBeloteScoreRepository: mockContreeBeloteScoreRepository);
        expect(await contreeBeloteScoreService.generateNewScore(uid),
            contreeBeloteScore);
        verify(mockContreeBeloteScoreRepository.create(contreeBeloteScore)).called(1);
      });
    });
  });
}
