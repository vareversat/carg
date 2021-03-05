import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Game - Assign win and defeat ', () {
    late Game game1;
    late Game game2;
    late Game game3;
    GameStats gameStat1;
    GameStats? gameStat2;
    GameStats? gameStat3;
    late Player player1;
    late Player player2;
    setUp(() {
      game1 = CoincheBelote();
      game2 = FrenchBelote();
      game3 = Tarot();
      gameStat1 =
          GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 2);
      gameStat2 =
          GameStats(gameType: GameType.COINCHE, wonGames: 10, playedGames: 20);
      gameStat3 =
          GameStats(gameType: GameType.TAROT, wonGames: 3, playedGames: 5);
      player1 = Player(gameStatsList: [gameStat1]);
      player2 = Player(gameStatsList: [gameStat2, gameStat3]);
    });

    test('Player1 - Won Belote game', () {
      game2.incrementPlayerWonGamesByOne(player1);
      expect(player1.gameStatsList,
          [GameStats(gameType: GameType.BELOTE, wonGames: 1, playedGames: 2)]);
    });

    test('Player1 - Played Belote game', () {
      game2.incrementPlayerPlayedGamesByOne(player1);
      expect(player1.gameStatsList,
          [GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 3)]);
    });

    test('Player1 - Played Tarot game', () {
      game3.incrementPlayerPlayedGamesByOne(player1);
      expect(player1.gameStatsList, [
        GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 2),
        GameStats(gameType: GameType.TAROT, wonGames: 0, playedGames: 1)
      ]);
    });

    test('Player1 - Won Coinche game', () {
      game1.incrementPlayerWonGamesByOne(player1);
      expect(player1.gameStatsList, [
        GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 2),
        GameStats(gameType: GameType.COINCHE, wonGames: 1, playedGames: 1)
      ]);
    });

    test('Player2 - Played Belote game', () {
      game2.incrementPlayerPlayedGamesByOne(player2);
      expect(player2.gameStatsList, [
        gameStat2,
        gameStat3,
        GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 1)
      ]);
    });

    test('Player2 - Played Tarot game', () {
      game3.incrementPlayerPlayedGamesByOne(player2);
      expect(player2.gameStatsList, [
        gameStat2,
        GameStats(gameType: GameType.TAROT, wonGames: 3, playedGames: 6)
      ]);
    });

    test('Player2 - Won Coinche game', () {
      game1.incrementPlayerWonGamesByOne(player2);
      expect(player2.gameStatsList, [
        gameStat3,
        GameStats(gameType: GameType.COINCHE, wonGames: 11, playedGames: 20)
      ]);
    });
  });
}
