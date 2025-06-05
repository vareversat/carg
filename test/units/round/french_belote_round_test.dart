import 'package:carg/models/game/setting/french_belote_game_setting.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final gameSettingAddToContract = FrenchBeloteGameSetting(
      maxPoint: 1000, isInfinite: false, sumTrickPointsAndContract: true);

  group('BeloteRound', () {
    test('Is contract fulfilled', () {
      final beloteRound = FrenchBeloteRound();
      expect(beloteRound.contractFulfilled, false);
    });

    test('Compute score - fulfilled', () {
      final beloteRound = FrenchBeloteRound(
        settings: gameSettingAddToContract,
      );
      beloteRound.taker = BeloteTeamEnum.US;
      beloteRound.defender = BeloteTeamEnum.THEM;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      beloteRound.beloteRebelote = null;
      beloteRound.usTrickScore = 110;
      beloteRound.themTrickScore = 50;
      expect(beloteRound.contractFulfilled, true);
      expect(beloteRound.takerScore, 120);
      expect(beloteRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
      final beloteRound = FrenchBeloteRound(
        settings: gameSettingAddToContract,
      );
      beloteRound.taker = BeloteTeamEnum.US;
      beloteRound.defender = BeloteTeamEnum.THEM;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      beloteRound.beloteRebelote = BeloteTeamEnum.US;
      beloteRound.usTrickScore = 110;
      beloteRound.themTrickScore = 50;
      expect(beloteRound.contractFulfilled, true);
      expect(beloteRound.takerScore, 140);
      expect(beloteRound.defenderScore, 50);
    });

    test('Compute score - not fulfilled - BeloteRebelote - THEM', () {
      final beloteRound = FrenchBeloteRound(
        settings: gameSettingAddToContract,
      );
      beloteRound.taker = BeloteTeamEnum.US;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      beloteRound.defender = BeloteTeamEnum.THEM;
      beloteRound.usTrickScore = 70;
      beloteRound.themTrickScore = 90;
      beloteRound.beloteRebelote = BeloteTeamEnum.US;
      expect(beloteRound.contractFulfilled, true);
      expect(beloteRound.takerScore, 100);
      expect(beloteRound.defenderScore, 90);
    });

    test('Compute score - fulfilled - Dix de Der - US', () {
      final beloteRound = FrenchBeloteRound(
        settings: gameSettingAddToContract,
      );
      beloteRound.taker = BeloteTeamEnum.US;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      beloteRound.defender = BeloteTeamEnum.THEM;
      beloteRound.beloteRebelote = null;
      beloteRound.usTrickScore = 110;
      beloteRound.themTrickScore = 50;
      expect(beloteRound.contractFulfilled, true);
      expect(beloteRound.takerScore, 120);
      expect(beloteRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - Dix de Der - THEM', () {
      final beloteRound = FrenchBeloteRound(
        settings: gameSettingAddToContract,
      );
      beloteRound.taker = BeloteTeamEnum.US;
      beloteRound.defender = BeloteTeamEnum.THEM;
      beloteRound.dixDeDer = BeloteTeamEnum.THEM;
      beloteRound.beloteRebelote = null;
      beloteRound.usTrickScore = 110;
      beloteRound.themTrickScore = 50;
      expect(beloteRound.contractFulfilled, true);
      expect(beloteRound.takerScore, 110);
      expect(beloteRound.defenderScore, 60);
    });

    test('Compute score - failed', () {
      final beloteRound = FrenchBeloteRound(
        settings: gameSettingAddToContract,
      );
      beloteRound.taker = BeloteTeamEnum.THEM;
      beloteRound.defender = BeloteTeamEnum.US;
      beloteRound.dixDeDer = BeloteTeamEnum.US;
      beloteRound.beloteRebelote = null;
      beloteRound.usTrickScore = 110;
      beloteRound.themTrickScore = 50;
      expect(beloteRound.contractFulfilled, false);
      expect(beloteRound.takerScore, 0);
      expect(beloteRound.defenderScore, 160);
    });

    test('Manual mode', () {
      final coincheRound = FrenchBeloteRound(
          taker: BeloteTeamEnum.US,
          defender: BeloteTeamEnum.THEM,
          takerScore: 81,
          defenderScore: 81,
          settings: gameSettingAddToContract,
          isManualMode: true
      );
      expect(coincheRound.takerScore, 81);
      expect(coincheRound.defenderScore, 81);
      expect(coincheRound.contractFulfilled, false);
    });
  });
}
