import 'package:carg/models/game/setting/coinche_belote_game_setting.dart';
import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/misc/coinche_belote_contract_name.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final gameSettingAddToContract = CoincheBeloteGameSetting(
      maxPoint: 1000, isInfinite: false, addContractToScore: true);
  final gameSettingNoAddToContract = CoincheBeloteGameSetting(
      maxPoint: 1000, isInfinite: false, addContractToScore: false);

  group('CoincheRound', () {
    test('Is contract fulfilled', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      expect(coincheRound.contractFulfilled, true);
    });

    test('Compute score - Set contract', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = null;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 90;
      expect(coincheRound.takerScore, 210);
      expect(coincheRound.defenderScore, 50);
    });

    test('Compute score - Set contract (contract only)', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingNoAddToContract,
      );
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = null;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 90;
      expect(coincheRound.takerScore, 100);
      expect(coincheRound.defenderScore, 0);
    });

    test('Compute score - fulfilled', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = null;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 220);
      expect(coincheRound.defenderScore, 50);
    });

    test('Compute score - fulfilled (contract only)', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingNoAddToContract,
      );
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = null;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 110);
      expect(coincheRound.defenderScore, 0);
    });

    test('Compute score - fulfilled - BeloteRebelote - US', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.dixDeDer = BeloteTeamEnum.THEM;
      coincheRound.beloteRebelote = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 120;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 250);
      expect(coincheRound.defenderScore, 60);
    });

    test('Compute score - fulfilled - BeloteRebelote - THEM', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = BeloteTeamEnum.THEM;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 220);
      expect(coincheRound.defenderScore, 70);
    });

    test('Compute score - fulfilled - Dix de Der - US', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 220);
      expect(coincheRound.defenderScore, 50);
    });

    test('Compute score - fulfilled - Dix de Der - THEM', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.THEM;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.takerScore, 210);
      expect(coincheRound.defenderScore, 60);
    });

    test('Compute score - Contract - Coinche', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.COINCHE;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 440);
      expect(coincheRound.defenderScore, 50);
    });

    test('Compute score - Contract - Sur Coinche', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.SURCOINCHE;
      coincheRound.contract = 100;
      expect(coincheRound.takerScore, 880);
      expect(coincheRound.defenderScore, 50);
    });

    test('Compute score - failed', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.taker = BeloteTeamEnum.THEM;
      coincheRound.defender = BeloteTeamEnum.US;
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contract = 100;
      expect(coincheRound.contractFulfilled, false);
      expect(coincheRound.takerScore, 0);
      expect(coincheRound.defenderScore, 270);
    });

    test('Compute score - fulfilled - Dix de Der - US - Capot', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.taker = BeloteTeamEnum.US;
      coincheRound.defender = BeloteTeamEnum.THEM;
      coincheRound.usTrickScore = 152;
      coincheRound.themTrickScore = 0;
      coincheRound.beloteRebelote = BeloteTeamEnum.THEM;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contractType = BeloteContractType.CAPOT;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.contract, 162);
      expect(coincheRound.takerScore, 250);
      expect(coincheRound.defenderScore, 20);
    });

    test('Compute score - fulfilled - Dix de Der - US - Capot failed', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.taker = BeloteTeamEnum.US;
      coincheRound.defender = BeloteTeamEnum.THEM;
      coincheRound.usTrickScore = 140;
      coincheRound.themTrickScore = 12;
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contractType = BeloteContractType.CAPOT;
      expect(coincheRound.contractFulfilled, false);
      expect(coincheRound.contract, 162);
      expect(coincheRound.takerScore, 10);
      expect(coincheRound.defenderScore, 410);
    });

    test('Compute score - fulfilled - Dix de Der - US - Generale', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.taker = BeloteTeamEnum.US;
      coincheRound.defender = BeloteTeamEnum.THEM;
      coincheRound.usTrickScore = 152;
      coincheRound.themTrickScore = 0;
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contractType = BeloteContractType.GENERALE;
      expect(coincheRound.contractFulfilled, true);
      expect(coincheRound.contract, 162);
      expect(coincheRound.takerScore, 500);
      expect(coincheRound.defenderScore, 0);
    });

    test('Compute score - fulfilled - Dix de Der - US - Failed generale', () {
      final coincheRound = CoincheBeloteRound(
        taker: BeloteTeamEnum.US,
        defender: BeloteTeamEnum.THEM,
        usTrickScore: 110,
        themTrickScore: 50,
        settings: gameSettingAddToContract,
      );
      coincheRound.taker = BeloteTeamEnum.US;
      coincheRound.defender = BeloteTeamEnum.THEM;
      coincheRound.usTrickScore = 152;
      coincheRound.themTrickScore = 0;
      coincheRound.beloteRebelote = null;
      coincheRound.dixDeDer = BeloteTeamEnum.US;
      coincheRound.contractName = CoincheBeloteContractName.NORMAL;
      coincheRound.contractType = BeloteContractType.FAILED_GENERALE;
      expect(coincheRound.contractFulfilled, false);
      expect(coincheRound.contract, 162);
      expect(coincheRound.takerScore, 10);
      expect(coincheRound.defenderScore, 660);
    });
  });
}
