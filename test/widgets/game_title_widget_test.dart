import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/views/widgets/register/game_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget testableWidget(Game game) =>
    MaterialApp(home: GameTitleWidget(game: game));

void main() {
  late Tarot tarotGame;
  late FrenchBelote frenchBelote;
  late CoincheBelote coincheBelote;
  late ContreeBelote contreeBelote;
  setUp(() {
    tarotGame = Tarot(
        id: 'ID1', isEnded: false, startingDate: DateTime(2017, 9, 7, 17, 30));
    frenchBelote = FrenchBelote(
        id: 'ID2', isEnded: true, startingDate: DateTime(2020, 9, 7, 17, 30));
    coincheBelote = CoincheBelote(
        id: 'ID3', isEnded: false, startingDate: DateTime(2017, 9, 7, 17, 30));
    contreeBelote = ContreeBelote(
        id: 'ID4', isEnded: true, startingDate: DateTime(2017, 9, 7, 17, 30));
  });

  testWidgets("Tarot - must display 'En cours' and '07/09/2017, 17:30'",
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(tarotGame));

    expect(find.text('En cours'), findsOneWidget);
    expect(find.text('07/09/2017, 17:30'), findsOneWidget);
  });

  testWidgets("French belote - must display 'Terminée' and '07/09/2020, 17:30'",
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(frenchBelote));

    expect(find.text('Terminée'), findsOneWidget);
    expect(find.text('07/09/2020, 17:30'), findsOneWidget);
  });

  testWidgets(
      "Coinche belote - must display 'En cours' and '07/09/2017, 17:30'",
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(coincheBelote));

    expect(find.text('En cours'), findsOneWidget);
    expect(find.text('07/09/2017, 17:30'), findsOneWidget);
  });

  testWidgets("Contre belote - must display 'Terminée' and '07/09/2017, 17:30'",
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(contreeBelote));

    expect(find.text('Terminée'), findsOneWidget);
    expect(find.text('07/09/2017, 17:30'), findsOneWidget);
  });
}
