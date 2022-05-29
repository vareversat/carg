import 'package:carg/models/player.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/views/screens/player_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'player_list_screen_test.mocks.dart';

Widget testableWidget() => MaterialApp(
    home: ChangeNotifierProvider<AuthService>.value(
        value: mockAuthService,
        builder: (context, _) => PlayerListScreen(
            teamService: mockAbstractTeamService,
            playerService: mockAbstractPlayerService)));

final mockAbstractPlayerService = MockAbstractPlayerService();
final mockAbstractTeamService = MockAbstractTeamService();
final mockAuthService = MockAuthService();

@GenerateMocks([
  AbstractPlayerService,
  AbstractTeamService,
  TextEditingController,
  AuthService
])
void main() {
  late List<Player> mockPlayerList;
  late List<Team> mockTeamList;
  late Player currentPlayer;

  setUp(() {
    mockPlayerList = [
      Player(userName: 'Player1', owned: false),
      Player(userName: 'Player2', owned: false),
      Player(userName: 'Player3', owned: false),
    ];
    mockTeamList = [
      Team(id: 't1', players: ['p1', 'p2']),
      Team(id: 't2', players: ['p3', 'p4'])
    ];
    currentPlayer = Player(id: 'player-id', userName: 'Player', owned: false);

    when(mockAbstractPlayerService.searchPlayers(
            query: '', currentPlayer: currentPlayer))
        .thenAnswer((_) => Future<List<Player>>(() => (mockPlayerList)));
    when(mockAbstractTeamService.getAllTeamOfPlayer(
        'player-id', 10))
        .thenAnswer((_) => Future<List<Team>>(() => (mockTeamList)));
    when(mockAuthService.getPlayerIdOfUser()).thenReturn('player-id');
    when(mockAuthService.getPlayer()).thenReturn(currentPlayer);
    when(mockAuthService.getAdmin()).thenReturn(false);
    when(mockAbstractPlayerService.get('p1')).thenAnswer((_) => Future<Player>(() => (mockPlayerList[0])));
    when(mockAbstractPlayerService.get('p2')).thenAnswer((_) => Future<Player>(() => (mockPlayerList[0])));
    when(mockAbstractPlayerService.get('p3')).thenAnswer((_) => Future<Player>(() => (mockPlayerList[0])));
    when(mockAbstractPlayerService.get('p4')).thenAnswer((_) => Future<Player>(() => (mockPlayerList[0])));
  });

  group('PlayerListScreen ', () {
    group('TeamListTab', () {
      testWidgets('display 2 teams', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
        await mockNetworkImagesFor(
            () => tester.tap(find.byKey(const ValueKey('playerListTeam'))));
        await mockNetworkImagesFor(() => tester.pumpAndSettle());
      });
    });

    group('PlayerListTab', () {
      testWidgets('display 3 users', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
        await mockNetworkImagesFor(() => tester.pumpAndSettle());
        expect(find.byKey(const ValueKey('playerWidget-0')), findsOneWidget);
        expect(find.byKey(const ValueKey('playerWidget-1')), findsOneWidget);
        expect(find.byKey(const ValueKey('playerWidget-2')), findsOneWidget);
      });

      testWidgets('no players', (WidgetTester tester) async {
        when(mockAbstractPlayerService.searchPlayers(
                query: '', currentPlayer: currentPlayer))
            .thenAnswer((_) => Future<List<Player>>(() => []));
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
        await mockNetworkImagesFor(() => tester.pumpAndSettle());
        expect(find.byKey(const ValueKey('noPlayersMessage')), findsOneWidget);
      });

      testWidgets('reset search', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
        await mockNetworkImagesFor(
            () => tester.tap(find.byKey(const ValueKey('resetSearchButton'))));
        await mockNetworkImagesFor(() => tester.pumpAndSettle());
      });
    });

    group('display popups', () {
      testWidgets('popup menu items', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
        await mockNetworkImagesFor(() => tester
            .tap(find.byKey(const ValueKey('playerListPopupMenuButton'))));
        await mockNetworkImagesFor(
            () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
        expect(find.byKey(const ValueKey('addPlayerPopupMenuItem')),
            findsOneWidget);
        expect(find.byKey(const ValueKey('showInformationPopupMenuItem')),
            findsOneWidget);
      });

      testWidgets('information dialog', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
        await mockNetworkImagesFor(() => tester
            .tap(find.byKey(const ValueKey('playerListPopupMenuButton'))));
        await mockNetworkImagesFor(
            () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
        await mockNetworkImagesFor(() => tester
            .tap(find.byKey(const ValueKey('showInformationPopupMenuItem'))));
        await mockNetworkImagesFor(
            () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
        expect(find.byKey(const ValueKey('playerColorExplanationDialog')),
            findsOneWidget);
      });

      testWidgets('add player dialog', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
        await mockNetworkImagesFor(() => tester
            .tap(find.byKey(const ValueKey('playerListPopupMenuButton'))));
        await mockNetworkImagesFor(
            () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
        await mockNetworkImagesFor(() =>
            tester.tap(find.byKey(const ValueKey('addPlayerPopupMenuItem'))));
        await mockNetworkImagesFor(
            () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));
        expect(find.byKey(const ValueKey('addPlayerDialog')), findsOneWidget);
      });
    });
  });
}
