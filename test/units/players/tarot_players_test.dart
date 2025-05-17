import 'package:carg/models/player.dart';
import 'package:carg/models/players/tarot_players.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carg/l10n/app_localizations.dart';

// testWidgets is used instead on test because we need a valid context to test these widgets
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
    testWidgets('(2/5)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: Container()),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr', ''),
          ],
        ),
      );
      final context = tester.element(find.byType(Container));
      final tarotPlayers = TarotPlayers(playerList: ['player_1', 'player_4']);
      expect(tarotPlayers.getSelectedPlayersStatus(context),
          'Joueurs.euses : 2/5');
    });

    testWidgets('(5/5)', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: Container()),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr', ''),
          ],
        ),
      );
      final context = tester.element(find.byType(Container));
      final tarotPlayers = TarotPlayers(playerList: [
        'player_1',
        'player_2',
        'player_3',
        'player_4',
        'player_5'
      ]);
      expect(tarotPlayers.getSelectedPlayersStatus(context),
          'Joueurs.euses : 5/5');
    });
  });

  group('Add player', () {
    test('true (not full)', () {
      final tarotPlayers = TarotPlayers(
          playerList: ['player_1', 'player_2', 'player_3', 'player_4']);
      final player = Player(id: 'player_5', owned: true);
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
      final player = Player(id: 'player_6', owned: true);
      tarotPlayers.onSelectedPlayer(player);
      expect(tarotPlayers.playerList,
          ['player_1', 'player_2', 'player_3', 'player_4', 'player_5']);
      expect(player.selected, false);
    });
  });
}
