import 'package:carg/models/score/misc/belote_contract_type.dart';
import 'package:carg/models/score/misc/contree_belote_contract_name.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/views/screens/add_round/widget/team_game/contract_contree_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'localized_testable_widget.dart';

Widget testableWidget(ContreeBeloteRound contreeRound) =>
    localizedTestableWidget(
      Scaffold(
        body: ContractContreeWidget(
          contreeRound: contreeRound,
        ),
      ),
    );

void main() {
  late ContreeBeloteRound contreeRound;
  setUp(() {
    contreeRound = ContreeBeloteRound();
  });

  testWidgets('All sub widget are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(contreeRound));
    expect(find.byKey(const ValueKey('contractValueTextFieldWidget')),
        findsOneWidget);
    expect(find.byKey(const ValueKey('contractTypeWidget')), findsOneWidget);
    expect(find.byKey(const ValueKey('contractNameWidget')), findsOneWidget);
    expect(find.byKey(const ValueKey('cardColorPickerWidget')), findsOneWidget);
  });

  testWidgets("Select 'Capot'", (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(contreeRound));
    await tester.tap(find.byKey(const ValueKey('contractTypeWidget-Capot')));
    await tester.pumpAndSettle();
    var textField = tester.widget<TextField>(
        find.byKey(const ValueKey('contractValueTextFieldValue')));
    expect(textField.enabled, false);
    expect(textField.controller!.text, '162');
    expect(find.byKey(const ValueKey('lockWidget')), findsOneWidget);
    expect(contreeRound.contractType, BeloteContractType.CAPOT);
  });

  testWidgets("Select 'Générale'", (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(contreeRound));
    await tester.tap(find.byKey(const ValueKey('contractTypeWidget-Générale')));
    await tester.pumpAndSettle();
    var textField = tester.widget<TextField>(
        find.byKey(const ValueKey('contractValueTextFieldValue')));
    expect(textField.enabled, false);
    expect(textField.controller!.text, '162');
    expect(find.byKey(const ValueKey('lockWidget')), findsOneWidget);
    expect(contreeRound.contractType, BeloteContractType.GENERALE);
  });

  testWidgets("Select 'Normal' for Type", (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(contreeRound));
    await tester.tap(find.byKey(const ValueKey('contractTypeWidget-Normal')));
    await tester.pumpAndSettle();
    var textField = tester.widget<TextField>(
        find.byKey(const ValueKey('contractValueTextFieldValue')));
    expect(textField.enabled, true);
    expect(find.byKey(const ValueKey('noLockWidget')), findsOneWidget);
    expect(find.byKey(const ValueKey('lockWidget')), findsNothing);
    expect(contreeRound.contractType, BeloteContractType.NORMAL);
  });

  testWidgets("Select 'Normal' for Mise", (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(contreeRound));
    await tester.tap(find.byKey(const ValueKey('contractNameWidget-Normal')));
    await tester.pumpAndSettle();
    expect(find.text('Mise (x1)'), findsOneWidget);
    expect(contreeRound.contractName, ContreeBeloteContractName.NORMAL);
  });
}
