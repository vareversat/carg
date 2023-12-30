import 'package:carg/models/game/setting/game_setting.dart';

abstract class BeloteGameSetting extends GameSetting {
  bool addContractToScore;

  BeloteGameSetting({
    required super.maxPoint,
    required this.addContractToScore,
  });
}
