import 'package:carg/models/player.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'player_info_dialog_test.mocks.dart';

Widget testableWidget(bool mockIsNewPlayer, PlayerService playerService,
        Player mockPlayer) =>
    MaterialApp(
      home: PlayerInfoDialog(
          player: mockPlayer,
          playerService: playerService,
          isNewPlayer: mockIsNewPlayer),
    );

@GenerateMocks([PlayerService])
void main() {
  late MockPlayerService mockPlayerService;
  late Player mockPlayer;

  setUp(() {
    mockPlayerService = MockPlayerService();
    mockPlayer = Player(owned: true, userName: 'toto');
  });

  group('Title', () {
    testWidgets('EDITING', (WidgetTester tester) async {
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(false, mockPlayerService, mockPlayer)));

      expect(
          tester
              .widget<Text>(find.byKey(ValueKey('titleText')))
              .data,
          'Edition');
    });

    testWidgets('CREATING', (WidgetTester tester) async {
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(true, mockPlayerService, mockPlayer)));

      expect(
          tester
              .widget<Text>(find.byKey(ValueKey('titleText')))
              .data,
          'Nouveau joueur');
    });

    testWidgets('INFORMATIONS', (WidgetTester tester) async {
      var mockPlayer = Player(owned: false, userName: 'toto');
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(false, mockPlayerService, mockPlayer)));

      expect(
          tester
              .widget<Text>(find.byKey(ValueKey('titleText')))
              .data,
          'Informations');
    });
  });


  group('Copy ID button', () {
    testWidgets('is displayed (editing)', (WidgetTester tester) async {
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(false, mockPlayerService, mockPlayer)));

      expect(find.byKey(ValueKey('copyIDButton')), findsOneWidget);
    });

    testWidgets('is hidden (creating)', (WidgetTester tester) async {
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(true, mockPlayerService, mockPlayer)));

      expect(find.byKey(ValueKey('copyIDButton')), findsNothing);
    });

    testWidgets('is hidden (information)', (WidgetTester tester) async {
      var mockPlayer = Player(owned: false, userName: 'toto');
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(true, mockPlayerService, mockPlayer)));

      expect(find.byKey(ValueKey('copyIDButton')), findsNothing);
    });

  });

  group('Username TextField', () {
    testWidgets('is enabled (editing)', (WidgetTester tester) async {
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(false, mockPlayerService, mockPlayer)));

      expect(
          tester
              .widget<TextFormField>(find.byKey(ValueKey('usernameTextField')))
              .enabled,
          true);
    });

    testWidgets('is enabled (creating)', (WidgetTester tester) async {
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(true, mockPlayerService, mockPlayer)));

      expect(
          tester
              .widget<TextFormField>(find.byKey(ValueKey('usernameTextField')))
              .enabled,
          true);
    });

    testWidgets('is disabled (information)', (WidgetTester tester) async {
      var mockPlayer = Player(owned: false, userName: 'toto');
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(true, mockPlayerService, mockPlayer)));

      expect(
          tester
              .widget<TextFormField>(find.byKey(ValueKey('usernameTextField')))
              .enabled,
          false);
    });

  });

  testWidgets('Display the username', (WidgetTester tester) async {
    await mockNetworkImagesFor(() =>
        tester.pumpWidget(
            testableWidget(false, mockPlayerService, mockPlayer)));

    expect(
        tester
            .widget<TextFormField>(find.byKey(ValueKey('usernameTextField')))
            .initialValue,
        'toto');
  });

  group('Buttons', () {
    testWidgets('save (editing)', (WidgetTester tester) async {
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(false, mockPlayerService, mockPlayer)));

      expect(find.byKey(ValueKey('editButton')), findsOneWidget);
      expect(find.byKey(ValueKey('closeButton')), findsNothing);
    });

    testWidgets('save (creation)', (WidgetTester tester) async {
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(true, mockPlayerService, mockPlayer)));

      expect(find.byKey(ValueKey('editButton')), findsOneWidget);
      expect(find.byKey(ValueKey('closeButton')), findsNothing);
    });

    testWidgets('close (informations)', (WidgetTester tester) async {
      var mockPlayer = Player(owned: false, userName: 'toto');
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(
              testableWidget(true, mockPlayerService, mockPlayer)));

      expect(find.byKey(ValueKey('editButton')), findsNothing);
      expect(find.byKey(ValueKey('closeButton')), findsOneWidget);
    });

  });


}
