import 'package:carg/models/team.dart';
import 'package:carg/services/team_service.dart';
import 'package:carg/views/widgets/team_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'team_widget_test.mocks.dart';

Widget testableWidget(MockTeamService mockTeamService) => MaterialApp(
      home: TeamWidget(
          title: 'Nous', teamService: mockTeamService, teamId: 'TEAM_ID'),
    );

@GenerateMocks([TeamService])
void main() {
  late MockTeamService mockTeamService;

  setUp(() {
    mockTeamService = MockTeamService();
    when(mockTeamService.getTeam('TEAM_ID')).thenAnswer(
        (_) => Future<Team>(() => Team(id: 'TEAM_ID', players: ['P1', 'P2'])));
  });

  testWidgets('Title', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(mockTeamService));
    await tester.pump(const Duration(milliseconds: 100));

    expect(
        tester.widget<Text>(find.byKey(const ValueKey('textTitleWidget'))).data,
        'Nous');
  });

  testWidgets('Players', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(mockTeamService));
    await tester.pump(const Duration(milliseconds: 100));

    expect(
        find.byKey(const ValueKey('apiminiplayerwidget-P1')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('apiminiplayerwidget-P2')), findsOneWidget);
  });
}
