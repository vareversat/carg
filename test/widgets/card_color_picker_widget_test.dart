import 'package:carg/models/score/misc/card_color.dart';
import 'package:carg/views/screens/add_round/widget/team_game/card_color_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../units/mocks/fake_belote_round.dart';
import 'localized_testable_widget.dart';

Widget testableWidget(FakeBeloteRound beloteRound) => localizedTestableWidget(
      Scaffold(
        body: CardColorPickerWidget(
          beloteRound: beloteRound,
        ),
      ),
    );

void main() {
  late FakeBeloteRound beloteRound;
  setUp(() {
    beloteRound = FakeBeloteRound();
  });

  testWidgets("Display at least 'Coeur'", (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(beloteRound));
    expect(
      find.byKey(const ValueKey('cardColorInputChip-Cœur')),
      findsOneWidget,
    );
    expect(find.text('Couleur (Cœur)'), findsOneWidget);
  });

  testWidgets("Select 'Trèfle'", (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(beloteRound));
    await tester.tap(
      find.byKey(
        const ValueKey(
          'cardColorInputChip-Trèfle',
        ),
      ),
    );
    expect(beloteRound.cardColor, CardColor.CLUB);
  });
}
