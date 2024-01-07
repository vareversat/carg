import 'package:carg/models/game/setting/belote_game_setting.dart';

class FakeBeloteGameSetting extends BeloteGameSetting {
  FakeBeloteGameSetting({
    required super.maxPoint,
    required super.isInfinite,
    required super.sumTrickPointsAndContract,
  });
}
