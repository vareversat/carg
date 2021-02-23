import 'package:carg/models/player.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BelotePlayers', () {
    test('Empty initialization ', () {
      final belotePlayers = BelotePlayers();
      expect(belotePlayers.playerList, [' ', ' ', ' ', ' ']);
    });
  });

  group('Teams are full', () {
    test('true', () {
      final belotePlayers = BelotePlayers(
          playerList: ['player_1', 'player_2', 'player_3', 'player_4'],
          us: 'team_1',
          them: 'team_2');
      expect(belotePlayers.isFull(), true);
    });

    test('false', () {
      final belotePlayers = BelotePlayers(
          playerList: ['player_1', ' ', 'player_3', 'player_4'],
          us: 'team_1',
          them: 'team_2');
      expect(belotePlayers.isFull(), false);
    });
  });

  group('Get Selected Players Status', () {
    test('Teams are partially full (1/2)', () {
      final belotePlayers = BelotePlayers(
          playerList: ['player_1', ' ', 'player_3', 'player_4'],
          us: 'team_1',
          them: 'team_2');
      expect(belotePlayers.getSelectedPlayersStatus(), 'Nous 1/2 - Eux 2/2');
    });

    test('Teams are partially full (2/1)', () {
      final belotePlayers = BelotePlayers(
          playerList: ['player_1', 'player_2', 'player_3', ' '],
          us: 'team_1',
          them: 'team_2');
      expect(belotePlayers.getSelectedPlayersStatus(), 'Nous 2/2 - Eux 1/2');
    });

    test('Teams are full', () {
      final belotePlayers = BelotePlayers(
          playerList: ['player_1', 'player_2', 'player_3', 'player_4'],
          us: 'team_1',
          them: 'team_2');
      expect(belotePlayers.getSelectedPlayersStatus(), 'Nous 2/2 - Eux 2/2');
    });
  });

  group('On Selected Player', () {
    test('Remove one', () {
      final belotePlayers = BelotePlayers(
          playerList: ['player_1', 'player_2', 'player_3', 'player_4'],
          us: 'team_1',
          them: 'team_2');
      belotePlayers.onSelectedPlayer(Player(id: 'player_1'));
      expect(
          belotePlayers.playerList, [' ', 'player_2', 'player_3', 'player_4']);
    });

    test('Add one', () {
      final belotePlayers = BelotePlayers(
          playerList: [' ', 'player_2', 'player_3', 'player_4'],
          us: 'team_1',
          them: 'team_2');
      belotePlayers.onSelectedPlayer(Player(id: 'player_5'));
      expect(belotePlayers.playerList,
          ['player_5', 'player_2', 'player_3', 'player_4']);
    });
  });
}
