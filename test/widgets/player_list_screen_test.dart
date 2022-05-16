import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/views/screens/player_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'belote_widget_test.mocks.dart';
import 'settings_screen_test.mocks.dart';

Widget testableWidget() => MaterialApp(
    home: ChangeNotifierProvider<AuthService>.value(
        value: mockAuthService,
        builder: (context, _) => PlayerListScreen(
            playerService: mockAbstractPlayerService,
            textEditingController: TextEditingController())));

final mockAbstractPlayerService = MockAbstractPlayerService();
final mockAuthService = MockAuthService();

@GenerateMocks([AbstractPlayerService, AuthService])
void main() {
  late List<Player> mockPlayerList;
  late Player currentPlayer;

  setUp(() {
    mockPlayerList = [
      Player(userName: 'Player1', owned: false),
      Player(userName: 'Player2', owned: false),
      Player(userName: 'Player3', owned: false)
    ];
    currentPlayer = Player(id: 'player-id', userName: 'Player', owned: false);

    when(mockAbstractPlayerService.searchPlayers(
            query: '', currentPlayer: currentPlayer))
        .thenAnswer((_) => Future<List<Player>>(() => (mockPlayerList)));
    when(mockAuthService.getPlayerIdOfUser()).thenReturn('player-id');
    when(mockAuthService.getPlayer()).thenReturn(currentPlayer);
    when(mockAuthService.getAdmin()).thenReturn(false);
  });

  testWidgets('Display 3 users', (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
    expect(find.byKey(const ValueKey('playerWidget-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('playerWidget-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('playerWidget-2')), findsOneWidget);
  });

  testWidgets('Display popup menu items', (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
    await mockNetworkImagesFor(() =>
        tester.tap(find.byKey(const ValueKey('playerListPopupMenuButton'))));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
    expect(
        find.byKey(const ValueKey('addPlayerPopupMenuItem')), findsOneWidget);
    expect(find.byKey(const ValueKey('showInformationPopupMenuItem')),
        findsOneWidget);
  });

  testWidgets('Display information dialog', (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
    await mockNetworkImagesFor(() =>
        tester.tap(find.byKey(const ValueKey('playerListPopupMenuButton'))));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
    await mockNetworkImagesFor(() =>
        tester.tap(find.byKey(const ValueKey('showInformationPopupMenuItem'))));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
    expect(find.byKey(const ValueKey('playerColorExplanationDialog')),
        findsOneWidget);
  });

  testWidgets('Display add player dialog', (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
    await mockNetworkImagesFor(() =>
        tester.tap(find.byKey(const ValueKey('playerListPopupMenuButton'))));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
    await mockNetworkImagesFor(
        () => tester.tap(find.byKey(const ValueKey('addPlayerPopupMenuItem'))));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
    expect(find.byKey(const ValueKey('addPlayerDialog')), findsOneWidget);
  });
}
