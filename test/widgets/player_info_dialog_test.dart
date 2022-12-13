import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'localized_testable_widget.dart';
import 'player_info_dialog_test.mocks.dart';

Widget testableWidget(bool mockIsNewPlayer, PlayerService playerService,
        Player mockPlayer, AuthService mockAuthService) =>
    localizedTestableWidget(
      ChangeNotifierProvider<AuthService>.value(
        value: mockAuthService,
        builder: (context, _) => PlayerInfoDialog(
          player: mockPlayer,
          playerService: playerService,
          isNewPlayer: mockIsNewPlayer,
        ),
      ),
    );

@GenerateMocks([PlayerService, AuthService])
void main() {
  late MockPlayerService mockPlayerService;
  late MockAuthService mockAuthService;
  late Player mockPlayer;

  setUp(() {
    mockPlayerService = MockPlayerService();
    mockAuthService = MockAuthService();
    mockPlayer = Player(owned: true, userName: 'toto');
  });

  group('PlayerInfoDialog', () {
    group('Title', () {
      testWidgets('EDITING', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            false, mockPlayerService, mockPlayer, mockAuthService)));

        expect(
            tester.widget<Text>(find.byKey(const ValueKey('titleText'))).data,
            'Édition');
      });

      testWidgets('CREATING', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(
            tester.widget<Text>(find.byKey(const ValueKey('titleText'))).data,
            'Nouveau/nouvelle joueur/joueuse');
      });

      testWidgets('INFORMATIONS', (WidgetTester tester) async {
        var mockPlayer = Player(owned: false, userName: 'toto');
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            false, mockPlayerService, mockPlayer, mockAuthService)));

        expect(
            tester.widget<Text>(find.byKey(const ValueKey('titleText'))).data,
            'Informations');
      });
    });

    group('Copy ID button', () {
      testWidgets('is displayed (editing)', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            false, mockPlayerService, mockPlayer, mockAuthService)));

        expect(find.byKey(const ValueKey('copyIDButton')), findsOneWidget);
      });

      testWidgets('is hidden (creating)', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(find.byKey(const ValueKey('copyIDButton')), findsNothing);
      });

      testWidgets('is hidden (information)', (WidgetTester tester) async {
        var mockPlayer = Player(owned: false, userName: 'toto');
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(find.byKey(const ValueKey('copyIDButton')), findsNothing);
      });

      testWidgets('click on it', (WidgetTester tester) async {
        var mockPlayer = Player(owned: true, userName: 'toto', id: 'test');
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            false, mockPlayerService, mockPlayer, mockAuthService)));
        await mockNetworkImagesFor(
            () => tester.tap(find.byKey(const ValueKey('copyIDButton'))));
        await mockNetworkImagesFor(() => tester.pump());
      });
    });

    group('Username TextField', () {
      testWidgets('is enabled (editing)', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            false, mockPlayerService, mockPlayer, mockAuthService)));

        expect(
            tester
                .widget<TextFormField>(
                    find.byKey(const ValueKey('usernameTextField')))
                .enabled,
            true);
      });

      testWidgets('is enabled (creating)', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(
            tester
                .widget<TextFormField>(
                    find.byKey(const ValueKey('usernameTextField')))
                .enabled,
            true);
      });

      testWidgets('is disabled (information)', (WidgetTester tester) async {
        var mockPlayer = Player(owned: false, userName: 'toto');
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(
            tester
                .widget<TextFormField>(
                    find.byKey(const ValueKey('usernameTextField')))
                .enabled,
            false);
      });
    });

    testWidgets('Display the username', (WidgetTester tester) async {
      await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
          false, mockPlayerService, mockPlayer, mockAuthService)));

      expect(
          tester
              .widget<TextFormField>(
                  find.byKey(const ValueKey('usernameTextField')))
              .initialValue,
          'toto');
    });

    group('Buttons', () {
      testWidgets('save (editing)', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            false, mockPlayerService, mockPlayer, mockAuthService)));

        expect(find.byKey(const ValueKey('saveButton')), findsOneWidget);
        expect(find.byKey(const ValueKey('closeButton')), findsNothing);
      });

      testWidgets('save (creation)', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(find.byKey(const ValueKey('saveButton')), findsOneWidget);
        expect(find.byKey(const ValueKey('closeButton')), findsNothing);
      });

      testWidgets('close (informations)', (WidgetTester tester) async {
        var mockPlayer = Player(owned: false, userName: 'toto');
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(find.byKey(const ValueKey('saveButton')), findsNothing);
        expect(find.byKey(const ValueKey('closeButton')), findsOneWidget);
      });
    });

    group('Profile picture text field', () {
      testWidgets('display', (WidgetTester tester) async {
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(find.byKey(const ValueKey('profilePictureTextField')),
            findsOneWidget);
      });
    });

    group('Stats', () {
      testWidgets('display', (WidgetTester tester) async {
        var gameStats = [
          GameStats(gameType: GameType.CONTREE, wonGames: 0, playedGames: 1),
          GameStats(gameType: GameType.COINCHE, wonGames: 0, playedGames: 10)
        ];
        var mockPlayer = Player(owned: false, gameStatsList: gameStats);
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(find.byKey(const ValueKey('stat-0-Contrée')), findsOneWidget);
        expect(find.byKey(const ValueKey('stat-1-Coinche')), findsOneWidget);
      });

      testWidgets('no display (no stats)', (WidgetTester tester) async {
        var mockPlayer = Player(owned: false);
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(find.byKey(const ValueKey('noStatsText')), findsNothing);
      });

      testWidgets('no display (new player)', (WidgetTester tester) async {
        var mockPlayer = Player(owned: false);
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));

        expect(find.byKey(const ValueKey('noStatsText')), findsNothing);
      });
    });

    group('Save player', () {
      testWidgets('tap (edit)', (WidgetTester tester) async {
        var mockPlayer = Player(owned: true, userName: 'toto', id: 'test');
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            false, mockPlayerService, mockPlayer, mockAuthService)));
        await mockNetworkImagesFor(
            () => tester.tap(find.byKey(const ValueKey('saveButton'))));
        await mockNetworkImagesFor(() => tester.pump());
        verify(mockPlayerService.update(mockPlayer)).called(1);
      });

      testWidgets('tap (create)', (WidgetTester tester) async {
        var mockPlayer = Player(owned: true, userName: 'toto', id: 'test');
        var editedMockPlayer = Player(
            owned: true, userName: 'toto', id: 'test', ownedBy: 'user_toto');
        when(mockAuthService.getPlayerIdOfUser()).thenReturn('user_toto');
        when(mockPlayerService.create(mockPlayer))
            .thenAnswer((_) async => Future<String>(() => 'playerId'));
        await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget(
            true, mockPlayerService, mockPlayer, mockAuthService)));
        await mockNetworkImagesFor(
            () => tester.tap(find.byKey(const ValueKey('saveButton'))));
        await mockNetworkImagesFor(() => tester.pumpAndSettle());

        expect(mockPlayer.ownedBy, 'user_toto');
        verify(mockPlayerService.create(editedMockPlayer)).called(1);
      });
    });
  });
}
