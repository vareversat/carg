import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/services/impl/score/french_belote_score_service.dart';
import 'package:carg/services/round/abstract_belote_round_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'abstract_belote_round_service_test.mocks.dart';

class FakeBeloteRoundService extends AbstractBeloteRoundService {
  FakeBeloteRoundService(
      {required super.scoreService});

  @override
  BeloteRound getNewRound() {
    throw UnimplementedError();
  }
}

@GenerateMocks([
  FrenchBeloteScoreService,
])
void main() {
  final mockFrenchBeloteScoreService = MockFrenchBeloteScoreService();
  const uid = '123';
  final score = FrenchBeloteScore();
  final round = FrenchBeloteRound(
      index: 0,
      takerScore: 300,
      defenderScore: 200,
      taker: BeloteTeamEnum.US,
      defender: BeloteTeamEnum.THEM);

  group('TarotRoundService', () {
    group('Add round to game', () {
      test('OK', () async {
        when(mockFrenchBeloteScoreService.getScoreByGame(uid))
            .thenAnswer((_) async => Future(() => score));
        final roundService =
            FakeBeloteRoundService(scoreService: mockFrenchBeloteScoreService);
        await roundService.addRoundToGame(uid, round);
        verify(mockFrenchBeloteScoreService.update(score)).called(1);
        expect(score.themTotalPoints, 200);
        expect(score.usTotalPoints, 300);
      });
    });
  });
}
