import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/services/score/french_belote_score_service.dart';
import 'package:carg/views/widgets/belote_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'belote_widget_test.mocks.dart';

Widget testableWidget(Belote beloteGame) =>
    MaterialApp(home: BeloteWidget(beloteGame: beloteGame));

@GenerateMocks([FrenchBeloteScoreService])
void main() {
  late FrenchBelote frenchBelote;
  late CoincheBelote coincheBelote;
  late ContreeBelote contreeBelote;
  late MockFrenchBeloteScoreService mockFrenchBeloteScoreService;

  setUp(() {
    mockFrenchBeloteScoreService = MockFrenchBeloteScoreService();
    frenchBelote = FrenchBelote(
        id: 'ID2',
        isEnded: true,
        startingDate: DateTime(2020, 9, 7, 17, 30),
        scoreService: mockFrenchBeloteScoreService);
    coincheBelote = CoincheBelote(
        id: 'ID3', isEnded: false, startingDate: DateTime(2017, 9, 7, 17, 30));
    contreeBelote = ContreeBelote(
        id: 'ID4', isEnded: true, startingDate: DateTime(2017, 9, 7, 17, 30));
    when(mockFrenchBeloteScoreService.getScoreByGame('ID2')).thenAnswer((_) =>
        Future<FrenchBeloteScore?>(() => FrenchBeloteScore(
            usTotalPoints: 100, themTotalPoints: 90, game: 'ID2')));
  });

  testWidgets('French belote - Must find two Team widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(frenchBelote));
    await tester.tap(find.byKey(const ValueKey('expansionTileTitle')));
    await tester.pumpAndSettle(const Duration(milliseconds: 1000));

    expect(find.byKey(const ValueKey('teamWidget-US')), findsOneWidget);
    expect(find.byKey(const ValueKey('teamWidget-THEM')), findsOneWidget);
  });

  testWidgets('Coinche belote - Must show three buttons : STOP, CONTINUE',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget(coincheBelote));
    await tester.tap(find.byKey(const ValueKey('expansionTileTitle')));
    await tester.pumpAndSettle(const Duration(milliseconds: 1000));

    expect(find.byKey(const ValueKey('stopButton')), findsOneWidget);
    expect(find.byKey(const ValueKey('continueButton')), findsOneWidget);
  });

  testWidgets('Contree belote - Must show three buttons : DELETE, SHOW_SCORE',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget(contreeBelote));
    await tester.tap(find.byKey(const ValueKey('expansionTileTitle')));
    await tester.pumpAndSettle(const Duration(milliseconds: 1000));

    expect(find.byKey(const ValueKey('deleteButton')), findsOneWidget);
    expect(find.byKey(const ValueKey('showScoreButton')), findsOneWidget);
  });

  testWidgets('French belote - Must find total scores (US: 100 and THEM: 90)',
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget(frenchBelote));
    await tester.tap(find.byKey(const ValueKey('expansionTileTitle')));
    await tester.pumpAndSettle(const Duration(milliseconds: 1000));

    expect(
        tester
            .widget<Text>(find.byKey(const ValueKey('usTotalPointsText')))
            .data,
        '100');
    expect(
        tester
            .widget<Text>(find.byKey(const ValueKey('themTotalPointsText')))
            .data,
        '90');
  });

  testWidgets("Contree belote - Must find 'Partie terminée'",
      (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget(frenchBelote));
    await tester.tap(find.byKey(const ValueKey('expansionTileTitle')));
    await tester.pumpAndSettle(const Duration(milliseconds: 1000));

    expect(find.text('Partie terminée'), findsOneWidget);
  });
}
