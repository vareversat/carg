import 'package:carg/models/team.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/views/dialogs/team_stat_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'team_stat_dialog_test.mocks.dart';

Widget testableWidget(Team team) =>
    MaterialApp(
      home: TeamStatDialog(
        playerService: mockPlayerService,
        teamService: mockTeamService,
        team: team,
      ),
    );

final mockPlayerService = MockAbstractPlayerService();
final mockTeamService = MockAbstractTeamService();

@GenerateMocks([AbstractPlayerService, AbstractTeamService, AuthService])
void main() {
  late Team team;

  setUp(() {
    team = Team(players: ['p1', 'p2'], name: 'My name');
  });

  group('TeamStatDialog', () {
    testWidgets('existing team name', (WidgetTester tester) async {
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(testableWidget(team)));
      expect(
          tester
              .widget<TextFormField>(find.byKey(const ValueKey('nameTextField')))
              .controller?.text,
          'My name');
    });

    testWidgets('enter new name', (WidgetTester tester) async {
      await mockNetworkImagesFor(() =>
          tester.pumpWidget(testableWidget(team)));
      await tester.enterText(find.byKey(const ValueKey('nameTextField')), 'Ny new name');
      await mockNetworkImagesFor(() =>tester.testTextInput.receiveAction(TextInputAction.done));
      await mockNetworkImagesFor(() =>tester.pumpAndSettle());

      verify(mockTeamService.update(team)).called(1);
    });
  });
}
