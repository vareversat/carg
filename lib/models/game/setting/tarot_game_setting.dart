import 'package:carg/models/game/setting/game_setting.dart';

class TarotGameSetting extends GameSetting {
  TarotGameSetting({
    required super.maxPoint,
    required super.isInfinite,
  });

  factory TarotGameSetting.fromJSON(Map<String, dynamic>? json) {
    return TarotGameSetting(
      maxPoint: json?['max_point'],
      isInfinite: json?['is_infinite'],
    );
  }
}
