import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/players/tarot_players.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/game/tarot_game_service.dart';
import 'package:carg/services/score/tarot_score_service.dart';
import 'package:carg/views/widgets/tarot_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tarot_widget_test.mocks.dart';

Widget testableWidget(Tarot tarotGame) =>
    MaterialApp(home: TarotWidget(tarotGame: tarotGame));

@GenerateMocks([TarotScoreService, TarotGameService])
void main() {
  late Tarot tarotGame;
  late MockTarotGameService mockTarotGameService;
  late MockTarotScoreService mockTarotScoreService;

  setUp(() {
    mockTarotGameService = MockTarotGameService();
    mockTarotScoreService = MockTarotScoreService();
    tarotGame = Tarot(
      id: 'ID',
      players: TarotPlayers(playerList: ['player1', 'player2', 'player3']),
      isEnded: false,
      startingDate: DateTime(2017, 9, 7, 17, 30),
      gameService: mockTarotGameService,
      gameType: GameType.TAROT,
      scoreService: mockTarotScoreService,
    );
    when(mockTarotScoreService.getScoreByGame('ID')).thenAnswer((_) =>
        Future<TarotScore?>(
            () => TarotScore(players: ['player1', 'player2', 'player3'])));
  });

  testWidgets('Players - must display 3 players widget when tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget(tarotGame));
    await tester.tap(find.byKey(ValueKey('expansionTileTitle')));
    await tester.pumpAndSettle(Duration(milliseconds: 1000));

    expect(find.byKey(ValueKey('apiminiplayerwidget-player1')), findsOneWidget);
    expect(find.byKey(ValueKey('apiminiplayerwidget-player2')), findsOneWidget);
    expect(find.byKey(ValueKey('apiminiplayerwidget-player3')), findsOneWidget);
  });
}
