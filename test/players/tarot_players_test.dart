import 'package:carg/models/player.dart';
import 'package:carg/models/players/tarot_players.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TarotPlayers', () {
    test('Empty initialization ', () {
      final tarotPlayers = TarotPlayers();
      expect(tarotPlayers.playerList, []);
    });
  });

  group('Players are full', () {
    test('false', () {
      final tarotPlayers = TarotPlayers(
          playerList: ['player_1', 'player_2', 'player_3', 'player_4']);
      expect(tarotPlayers.isFull(), true);
    });

    test('true', () {
      final tarotPlayers = TarotPlayers(playerList: [
        'player_1',
        'player_2',
        'player_3',
        'player_4',
        'player_5'
      ]);
      expect(tarotPlayers.isFull(), true);
    });
  });

  group('Get Selected Players Status', () {
    test('(2/5)', () {
      final tarotPlayers = TarotPlayers(playerList: ['player_1', 'player_4']);
      expect(tarotPlayers.getSelectedPlayersStatus(), 'Joueurs : 2/5');
    });

    test('(5/5)', () {
      final tarotPlayers = TarotPlayers(playerList: [
        'player_1',
        'player_2',
        'player_3',
        'player_4',
        'player_5'
      ]);
      expect(tarotPlayers.getSelectedPlayersStatus(), 'Joueurs : 5/5');
    });
  });

  group('Add player', () {
    test('true (not full)', () {
      final tarotPlayers = TarotPlayers(
          playerList: ['player_1', 'player_2', 'player_3', 'player_4']);
      final player = Player(id: 'player_5');
      tarotPlayers.onSelectedPlayer(player);
      expect(tarotPlayers.playerList,
          ['player_1', 'player_2', 'player_3', 'player_4', 'player_5']);
      expect(player.selected, true);
    });

    test('false (full)', () {
      final tarotPlayers = TarotPlayers(playerList: [
        'player_1',
        'player_2',
        'player_3',
        'player_4',
        'player_5'
      ]);
      final player = Player(id: 'player_6');
      tarotPlayers.onSelectedPlayer(player);
      expect(tarotPlayers.playerList,
          ['player_1', 'player_2', 'player_3', 'player_4', 'player_5']);
      expect(player.selected, false);
    });
  });
}
