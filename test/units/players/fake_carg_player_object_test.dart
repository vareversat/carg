import 'package:carg/models/carg_player_object.dart';
import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/players/tarot_players.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCargPlayerObjectTest extends CargPlayerObject {
  @override
  Map<String, dynamic> toJSON() {
    return {'im a': 'fake'};
  }
}

void main() {
  final Game game1 = CoincheBelote();
  final Game game2 = FrenchBelote();
  final Game game3 = Tarot(
    players: TarotPlayers(
      playerList: [
        'player1',
        'player2',
        'player3',
      ],
    ),
  );

  late FakeCargPlayerObjectTest cargPlayerObject1;

  group('CargPlayerObject', () {
    setUp(() {
      cargPlayerObject1 = FakeCargPlayerObjectTest();
    });

    test('Get total played games', () {
      final gameStat1 =
          GameStats(gameType: GameType.COINCHE, wonGames: 3, playedGames: 10);
      final gameStat2 =
          GameStats(gameType: GameType.BELOTE, wonGames: 15, playedGames: 20);
      cargPlayerObject1.gameStatsList = [gameStat1, gameStat2];
      expect(cargPlayerObject1.totalPlayedGames(), 30);
    });

    test('Get total won games', () {
      final gameStat1 =
          GameStats(gameType: GameType.COINCHE, wonGames: 3, playedGames: 10);
      final gameStat2 =
          GameStats(gameType: GameType.BELOTE, wonGames: 15, playedGames: 20);
      cargPlayerObject1.gameStatsList = [gameStat1, gameStat2];
      expect(cargPlayerObject1.totalWonGames(), 18);
    });

    test('Get win percentage', () {
      final gameStat1 =
          GameStats(gameType: GameType.COINCHE, wonGames: 3, playedGames: 10);
      final gameStat2 =
          GameStats(gameType: GameType.BELOTE, wonGames: 15, playedGames: 20);
      cargPlayerObject1.gameStatsList = [gameStat1, gameStat2];
      expect(cargPlayerObject1.totalWinPercentage(), 60.0);
    });

    test('CargPlayerObject - test 1', () {
      cargPlayerObject1.incrementWonGamesByOne(game2);
      expect(
        cargPlayerObject1.gameStatsList,
        [
          GameStats(
            gameType: GameType.BELOTE,
            wonGames: 1,
            playedGames: 0,
          ),
        ],
      );
    });

    test('CargPlayerObject - test 2', () {
      cargPlayerObject1.incrementPlayedGamesByOne(game2);
      expect(
        cargPlayerObject1.gameStatsList,
        [
          GameStats(
            gameType: GameType.BELOTE,
            wonGames: 0,
            playedGames: 1,
          ),
        ],
      );
    });

    test('CargPlayerObject - test 3', () {
      cargPlayerObject1.incrementPlayedGamesByOne(game2);
      cargPlayerObject1.incrementPlayedGamesByOne(game3);
      cargPlayerObject1.incrementWonGamesByOne(game3);
      expect(cargPlayerObject1.gameStatsList, [
        GameStats(
          gameType: GameType.BELOTE,
          wonGames: 0,
          playedGames: 1,
        ),
        GameStats(
          gameType: GameType.TAROT,
          wonGames: 1,
          playedGames: 1,
        ),
      ]);
    });

    test('CargPlayerObject - test 4', () {
      cargPlayerObject1.incrementWonGamesByOne(game1);
      cargPlayerObject1.incrementPlayedGamesByOne(game2);
      cargPlayerObject1.incrementPlayedGamesByOne(game3);
      cargPlayerObject1.incrementWonGamesByOne(game3);
      expect(cargPlayerObject1.gameStatsList, [
        GameStats(gameType: GameType.COINCHE, wonGames: 1, playedGames: 0),
        GameStats(gameType: GameType.BELOTE, wonGames: 0, playedGames: 1),
        GameStats(
          gameType: GameType.TAROT,
          wonGames: 1,
          playedGames: 1,
        ),
      ]);
    });
  });
}
