import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/views/screens/add_round/widget/team_game/trick_points_belote_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../units/mocks/fake_belote_round.dart';
import 'localized_testable_widget.dart';

Widget testableWidget(FakeBeloteRound beloteRound) => localizedTestableWidget(
      Scaffold(
        body: TrickPointsBeloteWidget(
          round: beloteRound,
        ),
      ),
    );

void main() {
  late FakeBeloteRound beloteRound;
  setUp(() {
    beloteRound = FakeBeloteRound();
  });

  testWidgets('Check default value', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(beloteRound));
    expect(find.text('Nous : 0 | 152 : Eux'), findsOneWidget);
    expect(beloteRound.usTrickScore, 0);
    expect(beloteRound.themTrickScore, 152);
  });

  testWidgets('Add 2 to us score', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(beloteRound));
    await tester
        .tap(find.byKey(const ValueKey('trickPointsBeloteRightButton')));
    await tester
        .tap(find.byKey(const ValueKey('trickPointsBeloteRightButton')));
    expect(beloteRound.usTrickScore, 2);
    expect(beloteRound.themTrickScore, 150);
  });

  testWidgets('Add 2 to us score', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(beloteRound));
    await tester
        .tap(find.byKey(const ValueKey('trickPointsBeloteRightButton')));
    await tester
        .tap(find.byKey(const ValueKey('trickPointsBeloteRightButton')));
    expect(beloteRound.usTrickScore, 2);
    expect(beloteRound.themTrickScore, 150);
  });

  testWidgets('Set Belote / Rebelote to US', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(beloteRound));
    await tester.tap(find.byKey(const ValueKey('beloteRebeloteWidgetUs')));
    expect(beloteRound.usTrickScore, 0);
    expect(beloteRound.themTrickScore, 152);
    expect(beloteRound.beloteRebelote, BeloteTeamEnum.US);
  });

  testWidgets('Set Dix de Der to THEM', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(beloteRound));
    await tester.tap(find.byKey(const ValueKey('dixDeDerWidgetThem')));
    expect(beloteRound.usTrickScore, 0);
    expect(beloteRound.themTrickScore, 152);
    expect(beloteRound.dixDeDer, BeloteTeamEnum.THEM);
  });
}
