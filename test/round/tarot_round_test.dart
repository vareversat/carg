import 'package:carg/models/players/tarot_round_players.dart';
import 'package:carg/models/score/misc/tarot_chelem.dart';
import 'package:carg/models/score/misc/tarot_contract.dart';
import 'package:carg/models/score/misc/tarot_handful.dart';
import 'package:carg/models/score/misc/tarot_oudler.dart';
import 'package:carg/models/score/misc/tarot_team.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TarotRound', () {
    final players = TarotRoundPlayers(
        attackPlayer: 'player_1',
        playerList: ['player_1', 'player_2', 'player_3', 'player_4']);

    final tarotRound = TarotRound(
        attackTrickPoints: 51.0, defenseTrickPoints: 40.0, players: players);

    test('Compute score - ONE & PETITE', () {
      tarotRound.oudler = TarotOudler.ONE;
      tarotRound.contract = TarotContract.PETITE;
      tarotRound.smallToTheEndTeam = null;
      tarotRound.handful = null;
      tarotRound.handfulTeam = null;
      expect(tarotRound.attackScore, 75.0);
      expect(tarotRound.defenseScore, -25.0);
    });

    test('Compute score - TWO & GARDE', () {
      tarotRound.oudler = TarotOudler.TWO;
      tarotRound.contract = TarotContract.GARDE_AVEC_CHIEN;
      tarotRound.smallToTheEndTeam = null;
      tarotRound.handful = null;
      tarotRound.handfulTeam = null;
      expect(tarotRound.attackScore, 210.0);
      expect(tarotRound.defenseScore, -70.0);
    });

    test('Compute score - THREE & GARDE', () {
      tarotRound.oudler = TarotOudler.ONE;
      tarotRound.contract = TarotContract.GARDE_AVEC_CHIEN;
      tarotRound.smallToTheEndTeam = null;
      tarotRound.handful = null;
      tarotRound.handfulTeam = null;
      expect(tarotRound.attackScore, 150.0);
      expect(tarotRound.defenseScore, -50.0);
    });

    test('Compute score - Small at the end - Attack', () {
      tarotRound.oudler = TarotOudler.ONE;
      tarotRound.contract = TarotContract.GARDE_AVEC_CHIEN;
      tarotRound.smallToTheEndTeam = TarotTeam.ATTACK;
      tarotRound.handful = null;
      tarotRound.handfulTeam = null;
      expect(tarotRound.attackScore, 210.0);
      expect(tarotRound.defenseScore, -70.0);
    });

    test('Compute score - Small at the end - Defense', () {
      tarotRound.oudler = TarotOudler.ONE;
      tarotRound.contract = TarotContract.GARDE_AVEC_CHIEN;
      tarotRound.smallToTheEndTeam = TarotTeam.DEFENSE;
      tarotRound.handful = null;
      tarotRound.handfulTeam = null;
      expect(tarotRound.attackScore, 90.0);
      expect(tarotRound.defenseScore, -30.0);
    });

    test('Compute score - Handful won', () {
      tarotRound.oudler = TarotOudler.ONE;
      tarotRound.contract = TarotContract.GARDE_AVEC_CHIEN;
      tarotRound.smallToTheEndTeam = null;
      tarotRound.handful = TarotHandful.SIMPLE;
      tarotRound.handfulTeam = TarotTeam.ATTACK;
      expect(tarotRound.attackScore, 210.0);
      expect(tarotRound.defenseScore, -70.0);
    });

    test('Compute score - Handful lost', () {
      tarotRound.oudler = TarotOudler.ONE;
      tarotRound.contract = TarotContract.GARDE_AVEC_CHIEN;
      tarotRound.smallToTheEndTeam = null;
      tarotRound.handful = TarotHandful.SIMPLE;
      tarotRound.handfulTeam = TarotTeam.DEFENSE;
      expect(tarotRound.attackScore, 90.0);
      expect(tarotRound.defenseScore, -30.0);
    });

    test('Compute score - Chelem', () {
      tarotRound.oudler = TarotOudler.ONE;
      tarotRound.contract = TarotContract.GARDE_AVEC_CHIEN;
      tarotRound.smallToTheEndTeam = null;
      tarotRound.handful = null;
      tarotRound.handfulTeam = null;
      tarotRound.chelem = TarotChelem.PASSED;
      expect(tarotRound.attackScore, 750.0);
      expect(tarotRound.defenseScore, -250.0);
    });

  });
}
