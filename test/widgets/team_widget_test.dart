import 'package:carg/models/player.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/views/widgets/team_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'team_widget_test.mocks.dart';

Widget testableWidget() => MaterialApp(
    home: TeamWidget(
        title: 'Nous',
        teamService: mockAbstractTeamService,
        playerService: mockAbstractPlayerService,
        teamId: 'TEAM_ID'),);

final mockAbstractTeamService = MockAbstractTeamService();
final mockAbstractPlayerService = MockAbstractPlayerService();

@GenerateMocks([AbstractPlayerService, AbstractTeamService])
void main() {
  setUp(() {
    final Player player1 = Player(owned: false, id: 'p1', userName: 'player 1');
    final Player player2 = Player(owned: false, id: 'p2', userName: 'player 2');

    when(mockAbstractTeamService.get('TEAM_ID')).thenAnswer(
        (_) => Future<Team>(() => Team(id: 'TEAM_ID', players: ['p1', 'p2'])));
    when(mockAbstractPlayerService.get('p1'))
        .thenAnswer((_) => Future(() => player1));
    when(mockAbstractPlayerService.get('p2'))
        .thenAnswer((_) => Future(() => player2));
  });

  testWidgets('Title', (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));

    expect(
        tester.widget<Text>(find.byKey(const ValueKey('textTitleWidget'))).data,
        'Nous');
  });

  testWidgets('Players', (WidgetTester tester) async {
    await mockNetworkImagesFor(() => tester.pumpWidget(testableWidget()));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 100)));

    expect(
        find.byKey(const ValueKey('apiminiplayerwidget-p1')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('apiminiplayerwidget-p2')), findsOneWidget);
  });
}
