import 'package:carg/models/game/setting/belote_game_setting.dart';

class ContreeBeloteGameSetting extends BeloteGameSetting {
  ContreeBeloteGameSetting({
    required super.maxPoint,
    required super.isInfinite,
    required super.sumTrickPointsAndContract,
  });

  factory ContreeBeloteGameSetting.fromJSON(Map<String, dynamic>? json) {
    return ContreeBeloteGameSetting(
      maxPoint: json?['max_point'],
      isInfinite: json?['is_infinite'],
      sumTrickPointsAndContract: json?['sum_trick_points_and_contract'],
    );
  }
}
