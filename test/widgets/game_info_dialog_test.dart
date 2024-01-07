import 'package:carg/models/game/coinche_belote.dart';
import 'package:carg/models/game/french_belote.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/setting/coinche_belote_game_setting.dart';
import 'package:carg/views/dialogs/game_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'localized_testable_widget.dart';

Widget testableWidget(Game game) => localizedTestableWidget(
      Scaffold(
        body: GameInfoDialog(
          game: game,
        ),
      ),
    );

void main() {
  late Game game;
  late Game game2;
  late Game game3;

  setUp(() {
    game = CoincheBelote();
    game2 = FrenchBelote();
    game3 = CoincheBelote(
      settings: CoincheBeloteGameSetting(
        maxPoint: 0,
        isInfinite: true,
        sumTrickPointsAndContract: true,
      ),
    );
  });

  group('GameInfoDialog', () {
    testWidgets('display coinche setting', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget(game));
      expect(find.byKey(const ValueKey('addAnnouncementAndPointOption')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('maxPointOption')), findsOneWidget);
    });
    testWidgets('display coinche setting (infinite)',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget(game3));
      expect(find.byKey(const ValueKey('addAnnouncementAndPointOption')),
          findsOneWidget);
      expect(find.byKey(const ValueKey('maxPointOption')), findsNothing);
      expect(find.byKey(const ValueKey('infiniteIcon')), findsOneWidget);
    });
    testWidgets('display french belote setting', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget(game2));
      expect(find.byKey(const ValueKey('addAnnouncementAndPointOption')),
          findsNothing);
      expect(find.byKey(const ValueKey('maxPointOption')), findsOneWidget);
    });
  });
}
