import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/player.dart';
import 'package:carg/models/players/tarot_players.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Game game1;
  late Game game2;
  late Game game3;

  GameStats gameStat1;
  GameStats gameStat2;
  GameStats gameStat3;

  late Player player1;
  late Player player2;

  group('Player', () {
    setUp(() {
      game1 = CoincheBelote();
      game2 = FrenchBelote();
      game3 = Tarot(
          players: TarotPlayers(playerList: ['player1', 'player2', 'player3']));
      gameStat1 =
          GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 2);
      gameStat2 =
          GameStats(gameType: GameType.COINCHE, wonGames: 10, playedGames: 20);
      gameStat3 =
          GameStats(gameType: GameType.TAROT, wonGames: 3, playedGames: 5);
      player1 = Player(gameStatsList: [gameStat1], owned: true);
      player2 = Player(gameStatsList: [gameStat2, gameStat3], owned: true);
    });

    test('Default username', () {
      final player = Player(owned: false);
      expect(player.userName, '');
    });

    test('Use Gravatar', () {
      final player = Player(owned: false);
      const email = "test@test.fr";
      player.gravatarProfilePicture = email;
      player.useGravatarProfilePicture = true;
      expect(player.profilePicture,
          'https://gravatar.com/avatar/1d2ab164559aaf8a30eebf516d2f63ad?s=200');
    });

    test('Use normal profile picture', () {
      final player = Player(owned: false);
      expect(player.profilePicture,
          'https://firebasestorage.googleapis.com/v0/b/carg-d3732.appspot.com/o/carg_logo.png?alt=media&token=861511da-db26-4216-8ee6-29b20c0a6852');
    });

    test('Hash email for Gravatar', () {
      final player = Player(owned: false);
      const email = "test@test.fr";
      player.gravatarProfilePicture = email;
      expect(player.gravatarProfilePicture,
          'https://gravatar.com/avatar/1d2ab164559aaf8a30eebf516d2f63ad?s=200');
    });

    test('Get total played games', () {
      final player = Player(owned: false);
      final gameStat1 =
          GameStats(gameType: GameType.COINCHE, wonGames: 3, playedGames: 10);
      final gameStat2 =
          GameStats(gameType: GameType.BELOTE, wonGames: 15, playedGames: 20);
      player.gameStatsList = [gameStat1, gameStat2];
      expect(player.totalPlayedGames(), 30);
    });

    test('Get total won games', () {
      final player = Player(owned: false);
      final gameStat1 =
          GameStats(gameType: GameType.COINCHE, wonGames: 3, playedGames: 10);
      final gameStat2 =
          GameStats(gameType: GameType.BELOTE, wonGames: 15, playedGames: 20);
      player.gameStatsList = [gameStat1, gameStat2];
      expect(player.totalWonGames(), 18);
    });

    test('Get win percentage', () {
      final player = Player(owned: false);
      final gameStat1 =
          GameStats(gameType: GameType.COINCHE, wonGames: 3, playedGames: 10);
      final gameStat2 =
          GameStats(gameType: GameType.BELOTE, wonGames: 15, playedGames: 20);
      player.gameStatsList = [gameStat1, gameStat2];
      expect(player.totalWinPercentage(), 60.0);
    });

    test('Player1 - Won Belote game', () {
      player1.incrementWonGamesByOne(game2);
      expect(player1.gameStatsList,
          [GameStats(gameType: GameType.BELOTE, wonGames: 1, playedGames: 2)]);
    });

    test('Player1 - Played Belote game', () {
      player1.incrementPlayedGamesByOne(game2);
      expect(player1.gameStatsList,
          [GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 3)]);
    });

    test('Player1 - Played Tarot game', () {
      player1.incrementPlayedGamesByOne(game3);
      expect(player1.gameStatsList, [
        GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 2),
        GameStats(gameType: GameType.TAROT, wonGames: 0, playedGames: 1)
      ]);
    });

    test('Player1 - Won Coinche game', () {
      player1.incrementWonGamesByOne(game1);
      expect(player1.gameStatsList, [
        GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 2),
        GameStats(gameType: GameType.COINCHE, wonGames: 1, playedGames: 0)
      ]);
    });

    test('Player2 - Played Belote game', () {
      player2.incrementPlayedGamesByOne(game2);
      expect(player2.gameStatsList, [
        GameStats(gameType: GameType.COINCHE, wonGames: 10, playedGames: 20),
        GameStats(gameType: GameType.TAROT, wonGames: 3, playedGames: 5),
        GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 1)
      ]);
    });

    test('Player2 - Played Tarot game', () {
      player2.incrementPlayedGamesByOne(game3);
      expect(player2.gameStatsList, [
        GameStats(gameType: GameType.COINCHE, wonGames: 10, playedGames: 20),
        GameStats(gameType: GameType.TAROT, wonGames: 3, playedGames: 6)
      ]);
    });

    test('Player2 - Won Coinche game', () {
      player2.incrementWonGamesByOne(game1);
      expect(player2.gameStatsList, [
        GameStats(gameType: GameType.TAROT, wonGames: 3, playedGames: 5),
        GameStats(gameType: GameType.COINCHE, wonGames: 11, playedGames: 20)
      ]);
    });
  });
}
