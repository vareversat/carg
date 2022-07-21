import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/views/screens/add_round/widget/team_game/taker_team_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../units/mocks/fake_belote_round.dart';

Widget testableWidget(FakeBeloteRound beloteRound) => MaterialApp(
    home: Scaffold(body: TakerTeamWidget(beloteRound: beloteRound)));

void main() {
  late FakeBeloteRound beloteRound;
  setUp(() {
    beloteRound = FakeBeloteRound();
  });

  testWidgets("Pick 'US'", (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(beloteRound));
    await tester.tap(find.byKey(const ValueKey('takerTeamWidget-usPicker')));
    expect(beloteRound.taker, BeloteTeamEnum.US);
    expect(beloteRound.defender, BeloteTeamEnum.THEM);
  });

  testWidgets("Pick 'THEM'", (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(beloteRound));
    await tester.tap(find.byKey(const ValueKey('takerTeamWidget-themPicker')));
    expect(beloteRound.taker, BeloteTeamEnum.THEM);
    expect(beloteRound.defender, BeloteTeamEnum.US);
  });
}