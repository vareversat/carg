import 'package:carg/models/players/tarot_round_players.dart';
import 'package:carg/models/score/misc/tarot_contract.dart';
import 'package:carg/models/score/misc/tarot_oudler.dart';
import 'package:carg/models/score/misc/tarot_perk.dart';
import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/impl/round/tarot_round_service.dart';
import 'package:carg/services/impl/score/tarot_score_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tarot_round_service_test.mocks.dart';

@GenerateMocks([
  TarotScoreService,
])
void main() {
  final mockTarotScoreService = MockTarotScoreService();
  const uid = '123';
  final score = TarotScore(totalPoints: [
    TarotPlayerScore(player: 'p1', score: 0),
    TarotPlayerScore(player: 'p2', score: 0),
    TarotPlayerScore(player: 'p3', score: 0),
    TarotPlayerScore(player: 'p4', score: 0)
  ]);
  final totalPoints = [
    TarotPlayerScore(player: 'p1', score: 300),
    TarotPlayerScore(player: 'p2', score: 300 / 3),
    TarotPlayerScore(player: 'p3', score: 200),
    TarotPlayerScore(player: 'p4', score: 200)
  ];
  final roundPlayers = TarotRoundPlayers(
      attackPlayer: 'p1',
      calledPlayer: 'p2',
      playerList: ['p1', 'p2', 'p3', 'p4']);
  final round = TarotRound(
      index: 0,
      attackScore: 300,
      defenseScore: 200,
      attackTrickPoints: 100,
      defenseTrickPoints: 200,
      oudler: TarotOudler.ONE,
      contract: TarotContract.GARDE_CONTRE,
      bonus: TarotBonus.CHELEM,
      players: roundPlayers);

  group('TarotRoundService', () {
    group('Add round to game', () {
      test('OK', () async {
        when(mockTarotScoreService.getScoreByGame(uid))
            .thenAnswer((_) async => Future(() => score));
        final tarotRoundService =
            TarotRoundService(tarotScoreService: mockTarotScoreService);
        await tarotRoundService.addRoundToGame(uid, round);
        verify(mockTarotScoreService.update(score)).called(1);
        expect(score.totalPoints, totalPoints);
      });
    });
  });
}
