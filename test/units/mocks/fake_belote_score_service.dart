import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/setting/belote_game_setting.dart';
import 'package:carg/models/players/belote_players.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/game/abstract_belote_game_service.dart';

import 'fake_belote_game.dart';

class FakeBeloteGameService extends AbstractBeloteGameService {
  FakeBeloteGameService(
      {required super.beloteScoreService,
      required super.beloteGameRepository,
      required super.teamService});

  @override
  Future<Belote<BelotePlayers, BeloteGameSetting>> generateNewGame(
      Team us,
      Team them,
      List<String?>? playerListForOrder,
      DateTime? startingDate,
      BeloteGameSetting settings) async {
    try {
      var belote = FakeBeloteGame(
        null,
        startingDate!,
        BelotePlayers(us: us.id, them: them.id, playerList: playerListForOrder),
        settings,
      );
      belote.id = await beloteGameRepository.create(belote);
      return belote;
    } on Exception catch (e) {
      throw ServiceException(
          'Error while generating a new game : ${e.toString()}');
    }
  }
}
