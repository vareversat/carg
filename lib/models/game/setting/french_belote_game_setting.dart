import 'package:carg/models/game/setting/belote_game_setting.dart';

class FrenchBeloteGameSetting extends BeloteGameSetting {
  FrenchBeloteGameSetting({
    required super.maxPoint,
    required super.isInfinite,
    required super.sumTrickPointsAndContract,
  });

  factory FrenchBeloteGameSetting.fromJSON(Map<String, dynamic>? json) {
    return FrenchBeloteGameSetting(
      maxPoint: json?['max_point'],
      isInfinite: json?['is_infinite'],
      sumTrickPointsAndContract: json?['sum_trick_points_and_contract'],
    );
  }
}
