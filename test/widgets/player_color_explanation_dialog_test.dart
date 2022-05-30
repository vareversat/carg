import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/views/dialogs/player_color_explanation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';

Widget testableWidget(bool isAdmin) =>
    MaterialApp(home: PlayerColorExplanationDialog(isAdmin: isAdmin));

@GenerateMocks([PlayerService, AuthService])
void main() {
  testWidgets('Display the 3 widgets', (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(true)));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
    expect(
        find.byKey(const ValueKey('playerWidgetRealPlayer')), findsOneWidget);
    expect(find.byKey(const ValueKey('realPlayerDescription')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('playerWidgetOwnedPlayer')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('ownedPlayerDescription')), findsOneWidget);
    expect(find.byKey(const ValueKey('playerWidgetTestingPlayer')),
        findsOneWidget);
    expect(
        find.byKey(const ValueKey('testingPlayerDescription')), findsOneWidget);
    expect(find.byKey(const ValueKey('wonGamesDescription')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('playedGamesDescription')), findsOneWidget);
  });

  testWidgets('Display only 2 widgets', (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(true)));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
    expect(
        find.byKey(const ValueKey('playerWidgetRealPlayer')), findsOneWidget);
    expect(find.byKey(const ValueKey('realPlayerDescription')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('playerWidgetOwnedPlayer')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('ownedPlayerDescription')), findsOneWidget);
    expect(find.byKey(const ValueKey('wonGamesDescription')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('playedGamesDescription')), findsOneWidget);
  });
}
