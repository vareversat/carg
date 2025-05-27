import 'package:carg/models/players/tarot_round_players.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TarotScore', () {
    final players = ['player_1', 'player_2', 'player_3', 'player_4'];
    final game = 'game_id';
    final round = TarotRound(
        attackTrickPoints: 51.0,
        defenseTrickPoints: 40.0,
        attackScore: 75.0,
        defenseScore: -25.0,
        players:
            TarotRoundPlayers(attackPlayer: players[0], playerList: players));
    final round2 = TarotRound(
        attackTrickPoints: 51.0,
        defenseTrickPoints: 40.0,
        attackScore: 75.0,
        defenseScore: -25.0,
        players:
            TarotRoundPlayers(attackPlayer: players[0], playerList: players));

    test('Create score', () {
      final tarotScore = TarotScore(game: game, players: players);
      expect(tarotScore.totalPoints.length, 4);
      expect(tarotScore.rounds, []);
    });

    test('Add round', () {
      final tarotScore = TarotScore(game: game, players: players);
      tarotScore.addRound(round);
      expect(tarotScore.totalPoints.length, 4);
      expect(tarotScore.rounds.length, 1);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_1')
              .score,
          75.0);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_2')
              .score,
          -25);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_3')
              .score,
          -25);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_4')
              .score,
          -25);
      expect(
          tarotScore.rounds[0].playerPoints
              ?.firstWhere((element) => element.player == 'player_1')
              .score,
          75.0);
      expect(
          tarotScore.rounds[0].playerPoints
              ?.firstWhere((element) => element.player == 'player_2')
              .score,
          -25);
      expect(
          tarotScore.rounds[0].playerPoints
              ?.firstWhere((element) => element.player == 'player_2')
              .score,
          -25);
      expect(
          tarotScore.rounds[0].playerPoints
              ?.firstWhere((element) => element.player == 'player_2')
              .score,
          -25);
    });

    test('Delete round', () {
      final tarotScore = TarotScore(game: game, players: players);
      tarotScore.addRound(round);
      tarotScore.addRound(round2);
      expect(tarotScore.totalPoints.length, 4);
      expect(tarotScore.rounds.length, 2);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_1')
              .score,
          150);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_2')
              .score,
          -50);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_3')
              .score,
          -50);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_4')
              .score,
          -50);
      tarotScore.deleteRound(1);
      expect(tarotScore.totalPoints.length, 4);
      expect(tarotScore.rounds.length, 1);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_1')
              .score,
          75);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_2')
              .score,
          -25);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_3')
              .score,
          -25);
      expect(
          tarotScore.totalPoints
              .firstWhere((element) => element.player == 'player_4')
              .score,
          -25);
    });
  });
}
