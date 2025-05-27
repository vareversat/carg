
import 'package:flutter_test/flutter_test.dart';

import '../mocks/fake_belote_round.dart';
import '../mocks/fake_belote_score.dart';

void main() {
  group('BeloteScore', () {
    final round = FakeBeloteRound();

    test('Add round', () {
      final beloteScore =
          FakeBeloteScore(usTotalPoints: 100, themTotalPoints: 100);
      beloteScore.addRound(round);
      expect(beloteScore.rounds.length, 1);
    });
  });
}
