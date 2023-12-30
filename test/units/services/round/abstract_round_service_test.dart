import 'package:carg/models/game/setting/game_setting.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:carg/services/round/abstract_round_service.dart';
import 'package:carg/services/score/abstract_score_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/fake_round.dart';
import '../../mocks/fake_score.dart';
import 'abstract_round_service_test.mocks.dart';

class FakeRoundService extends AbstractRoundService {
  FakeRoundService(abstractScoreService)
      : super(abstractScoreService: abstractScoreService);

  @override
  BeloteRound getNewRound(GameSetting? settings) {
    throw UnimplementedError();
  }

  @override
  Future<void> addRoundToGame(String? gameId, Round? round) {
    throw UnimplementedError();
  }
}

@GenerateMocks([AbstractScoreService])
void main() {
  final mockAbstractScoreService = MockAbstractScoreService();
  final round = FakeRound();
  final score = FakeScore('scoreId');
  const uid = '123';

  group('AbstractRoundService', () {
    test('edit the last round of a game', () async {
      when(mockAbstractScoreService.getScoreByGame(uid))
          .thenAnswer((_) async => Future(() => score));
      final roundService = FakeRoundService(mockAbstractScoreService);
      await roundService.editLastRoundOfScoreByGameId(uid, round);
      verify(mockAbstractScoreService.update(score)).called(1);
    });

    test('delete the last round of a game', () async {
      when(mockAbstractScoreService.getScoreByGame(uid))
          .thenAnswer((_) async => Future(() => score));
      final roundService = FakeRoundService(mockAbstractScoreService);
      await roundService.deleteLastRoundOfScoreByGameId(uid);
      verify(mockAbstractScoreService.update(score)).called(1);
    });
  });
}
