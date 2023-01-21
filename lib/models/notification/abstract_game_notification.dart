import 'package:carg/helpers/correct_instance.dart';
import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/notification/abstract_notification.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/screens/play/play_belote_screen.dart';
import 'package:carg/views/screens/play/play_tarot_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class AbstractGameNotification extends AbstractNotification {
  final String gameId;
  final GameType gameType;

  AbstractGameNotification(
      {super.id,
      super.notificationStatus,
      super.timeStamp,
      required super.kind,
      required super.boundTo,
      required this.gameId,
      required this.gameType});

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({'game_id': gameId, 'game_type': gameType.name});
    return tmpJSON;
  }

  /// Return the correct service to instanciate the associated game
  AbstractGameService getGameService() {
    return CorrectInstance.ofGameService(gameType);
  }

  /// Open the game screen
  void goToGame(BuildContext context) async {
    var gameService = getGameService();
    var game = await gameService.get(gameId);

    if (game == null) {
      InfoSnackBar.showErrorSnackBar(
          context, AppLocalizations.of(context)!.errorGameNotFound);
    } else {
      Navigator.push(
        context,
        CustomRouteFade(
          builder: (context) => gameType == GameType.TAROT
              ? PlayTarotGameScreen(tarotGame: game as Tarot)
              : PlayBeloteScreen(
                  beloteGame: game as Belote<BelotePlayers>,
                ),
        ),
      );
    }
  }
}
