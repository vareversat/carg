import 'package:carg/models/player.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

// testWidgets is used instead on test because we need a valid context to test these widgets
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
    testWidgets('Teams are partially full (1/2)', (WidgetTester tester) async {
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
      final belotePlayers = BelotePlayers(
          playerList: ['player_1', ' ', 'player_3', 'player_4'],
          us: 'team_1',
          them: 'team_2');
      expect(belotePlayers.getSelectedPlayersStatus(context),
          'Nous 1/2 - Eux 2/2');
    });

    testWidgets('Teams are partially full (2/1)', (WidgetTester tester) async {
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
      final belotePlayers = BelotePlayers(
          playerList: ['player_1', 'player_2', 'player_3', ' '],
          us: 'team_1',
          them: 'team_2');
      expect(belotePlayers.getSelectedPlayersStatus(context),
          'Nous 2/2 - Eux 1/2');
    });

    testWidgets('Teams are full', (WidgetTester tester) async {
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
      final belotePlayers = BelotePlayers(
          playerList: ['player_1', 'player_2', 'player_3', 'player_4'],
          us: 'team_1',
          them: 'team_2');
      expect(belotePlayers.getSelectedPlayersStatus(context),
          'Nous 2/2 - Eux 2/2');
    });
  });

  group('On Selected Player', () {
    test('Remove one', () {
      final belotePlayers = BelotePlayers(
          playerList: ['player_1', 'player_2', 'player_3', 'player_4'],
          us: 'team_1',
          them: 'team_2');
      belotePlayers.onSelectedPlayer(Player(id: 'player_1', owned: true));
      expect(
          belotePlayers.playerList, [' ', 'player_2', 'player_3', 'player_4']);
    });

    test('Add one', () {
      final belotePlayers = BelotePlayers(
          playerList: [' ', 'player_2', 'player_3', 'player_4'],
          us: 'team_1',
          them: 'team_2');
      belotePlayers.onSelectedPlayer(Player(id: 'player_5', owned: true));
      expect(belotePlayers.playerList,
          ['player_5', 'player_2', 'player_3', 'player_4']);
    });
  });
}
