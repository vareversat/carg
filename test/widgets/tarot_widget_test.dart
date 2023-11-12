import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/player.dart';
import 'package:carg/models/players/tarot_players.dart';
import 'package:carg/models/score/misc/tarot_player_score.dart';
import 'package:carg/models/score/tarot_score.dart';
import 'package:carg/services/game/abstract_tarot_game_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/score/abstract_tarot_score_service.dart';
import 'package:carg/views/widgets/tarot_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'localized_testable_widget.dart';
import 'tarot_widget_test.mocks.dart';

Widget testableWidget(Tarot tarotGame) => localizedTestableWidget(
      TarotWidget(
        tarotGame: tarotGame,
        gameService: mockAbstractGameService,
        scoreService: mockAbstractScoreService,
        playerService: mockAbstractPlayerService,
      ),
    );

final mockAbstractGameService = MockAbstractTarotGameService();
final mockAbstractScoreService = MockAbstractTarotScoreService();
final mockAbstractPlayerService = MockAbstractPlayerService();

@GenerateMocks([
  AbstractTarotGameService,
  AbstractTarotScoreService,
  AbstractPlayerService,
])
void main() {
  late Tarot tarotGame;
  late TarotScore tarotScore;

  setUp(() {
    final Player player1 = Player(owned: false, id: 'p1', userName: 'player 1');
    final Player player2 = Player(owned: false, id: 'p2', userName: 'player 2');
    final Player player3 = Player(owned: false, id: 'p3', userName: 'player 2');

    tarotGame = Tarot(
      id: 'ID',
      players: TarotPlayers(playerList: ['p1', 'p2', 'p3']),
      isEnded: false,
      startingDate: DateTime(2017, 9, 7, 17, 30),
      gameType: GameType.TAROT,
    );

    tarotScore = TarotScore(
      players: ['p1', 'p2', 'p3'],
      totalPoints: [
        TarotPlayerScore(score: 0, player: 'p1'),
        TarotPlayerScore(score: 100, player: 'p2'),
        TarotPlayerScore(score: 150, player: 'p3'),
      ],
    );

    when(mockAbstractScoreService.getScoreByGame('ID'))
        .thenAnswer((_) => Future<TarotScore?>(() => tarotScore));
    when(mockAbstractPlayerService.get('p1'))
        .thenAnswer((_) => Future(() => player1));
    when(mockAbstractPlayerService.get('p2'))
        .thenAnswer((_) => Future(() => player2));
    when(mockAbstractPlayerService.get('p3'))
        .thenAnswer((_) => Future(() => player3));
  });

  testWidgets(
    'Players - must display 3 players widget when tapped',
    (WidgetTester tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(testableWidget(tarotGame)),
      );
      await mockNetworkImagesFor(
        () => tester.tap(
          find.byKey(
            const ValueKey(
              'expansionTileTitle',
            ),
          ),
        ),
      );
      await mockNetworkImagesFor(
        () => tester.pumpAndSettle(
          const Duration(
            milliseconds: 1000,
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey('apiminiplayerwidget-p1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('apiminiplayerwidget-p2')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('apiminiplayerwidget-p3')),
        findsOneWidget,
      );
    },
  );
}
