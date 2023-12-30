import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/contree_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/setting/game_setting.dart';
import 'package:carg/models/player.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/score/coinche_belote_score.dart';
import 'package:carg/models/score/french_belote_score.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/game/abstract_belote_game_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/round/abstract_belote_round_service.dart';
import 'package:carg/services/score/abstract_belote_score_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/views/widgets/belote_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'belote_widget_test.mocks.dart';
import 'localized_testable_widget.dart';

final mockAbstractBeloteGameService = MockAbstractBeloteGameService();
final mockAbstractBeloteScoreService = MockAbstractBeloteScoreService();
final mockAbstractTeamService = MockAbstractTeamService();
final mockAbstractBeloteRoundService = MockAbstractBeloteRoundService();
final mockAbstractPlayerService = MockAbstractPlayerService();

Widget testableWidget(Belote beloteGame) => localizedTestableWidget(
      BeloteWidget(
          beloteGame: beloteGame,
          gameService: mockAbstractBeloteGameService,
          scoreService: mockAbstractBeloteScoreService,
          teamService: mockAbstractTeamService,
          roundService: mockAbstractBeloteRoundService,
          playerService: mockAbstractPlayerService),
    );

Object getNewRound(GameSetting? settings) => {};

@GenerateMocks([
  AbstractBeloteGameService,
  AbstractBeloteScoreService,
  AbstractTeamService,
  AbstractPlayerService
], customMocks: [
  MockSpec<AbstractBeloteRoundService>(
      unsupportedMembers: {#getNewRound},
      fallbackGenerators: {#getNewRound: getNewRound})
])
void main() {
  late FrenchBelote frenchBelote;
  late CoincheBelote coincheBelote;
  late ContreeBelote contreeBelote;

  const String teamId1 = 'teamId1';
  const String teamId2 = 'teamId2';
  const String gameId1 = 'gameId1';
  const String gameId2 = 'gameId2';

  final Team team1 = Team(players: ['p1', 'p2']);
  final Team team2 = Team(players: ['p3', 'p4']);

  final Player player1 = Player(owned: false, id: 'p1', userName: 'player 1');
  final Player player2 = Player(owned: false, id: 'p2', userName: 'player 2');
  final Player player3 = Player(owned: false, id: 'p3', userName: 'player 3');
  final Player player4 = Player(owned: false, id: 'p4', userName: 'player 4');

  final BelotePlayers players = BelotePlayers(
      us: teamId1, them: teamId2, playerList: ['p1', 'p2', 'p3', 'p4']);

  final FrenchBeloteScore frenchBeloteScore = FrenchBeloteScore(rounds: [
    FrenchBeloteRound(
        taker: BeloteTeamEnum.THEM,
        defender: BeloteTeamEnum.US,
        defenderScore: 90,
        takerScore: 110)
  ], themTotalPoints: 110, usTotalPoints: 90);
  final CoincheBeloteScore coincheBeloteScore = CoincheBeloteScore(rounds: [
    CoincheBeloteRound(
        taker: BeloteTeamEnum.THEM,
        defender: BeloteTeamEnum.US,
        defenderScore: 90,
        takerScore: 110)
  ], themTotalPoints: 110, usTotalPoints: 90);

  setUp(() {
    when(mockAbstractTeamService.get(teamId1))
        .thenAnswer((_) => Future(() => team1));
    when(mockAbstractTeamService.get(teamId2))
        .thenAnswer((_) => Future(() => team2));
    when(mockAbstractBeloteScoreService.getScoreByGame(gameId1))
        .thenAnswer((_) => Future(() => frenchBeloteScore));
    when(mockAbstractBeloteScoreService.getScoreByGame(gameId2))
        .thenAnswer((_) => Future(() => coincheBeloteScore));
    when(mockAbstractPlayerService.get('p1'))
        .thenAnswer((_) => Future(() => player1));
    when(mockAbstractPlayerService.get('p2'))
        .thenAnswer((_) => Future(() => player2));
    when(mockAbstractPlayerService.get('p3'))
        .thenAnswer((_) => Future(() => player3));
    when(mockAbstractPlayerService.get('p4'))
        .thenAnswer((_) => Future(() => player4));
    frenchBelote = FrenchBelote(
        id: gameId1,
        isEnded: true,
        startingDate: DateTime(2020, 9, 7, 17, 30),
        players: players);
    coincheBelote = CoincheBelote(
        id: gameId2,
        isEnded: false,
        startingDate: DateTime(2017, 9, 7, 17, 30),
        players: players);
    contreeBelote = ContreeBelote(
        id: gameId2,
        isEnded: true,
        startingDate: DateTime(2017, 9, 7, 17, 30),
        players: players);
  });

  testWidgets('French belote - Must find two Team widget',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(
        () => tester.pumpWidget(testableWidget(frenchBelote)));
    await mockNetworkImagesFor(
        () => tester.tap(find.byKey(const ValueKey('expansionTileTitle'))));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));

    expect(find.byKey(const ValueKey('teamWidget-US')), findsOneWidget);
    expect(find.byKey(const ValueKey('teamWidget-THEM')), findsOneWidget);
  });

  testWidgets('Coinche belote - Must show three buttons : STOP, CONTINUE',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(
        () => tester.pumpWidget(testableWidget(coincheBelote)));
    await mockNetworkImagesFor(
        () => tester.tap(find.byKey(const ValueKey('expansionTileTitle'))));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));

    expect(find.byKey(const ValueKey('stopButton')), findsOneWidget);
    expect(find.byKey(const ValueKey('continueButton')), findsOneWidget);
  });

  testWidgets('Contree belote - Must show three buttons : DELETE, SHOW_SCORE',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(
        () => tester.pumpWidget(testableWidget(contreeBelote)));
    await mockNetworkImagesFor(
        () => tester.tap(find.byKey(const ValueKey('expansionTileTitle'))));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));

    expect(find.byKey(const ValueKey('deleteButton')), findsOneWidget);
    expect(find.byKey(const ValueKey('showScoreButton')), findsOneWidget);
  });

  testWidgets('French belote - Must find total scores (US: 100 and THEM: 90)',
      (WidgetTester tester) async {
    await mockNetworkImagesFor(
        () => tester.pumpWidget(testableWidget(frenchBelote)));
    await mockNetworkImagesFor(
        () => tester.tap(find.byKey(const ValueKey('expansionTileTitle'))));
    await mockNetworkImagesFor(
        () => tester.pumpAndSettle(const Duration(milliseconds: 1000)));

    expect(
        tester
            .widget<Text>(find.byKey(const ValueKey('usTotalPointsText')))
            .data,
        '90');
    expect(
        tester
            .widget<Text>(find.byKey(const ValueKey('themTotalPointsText')))
            .data,
        '110');
  });
}
