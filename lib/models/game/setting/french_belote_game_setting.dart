import 'package:carg/models/game/setting/belote_game_setting.dart';

class FrenchBeloteGameSetting extends BeloteGameSetting {
  FrenchBeloteGameSetting({
    required super.maxPoint,
    required super.isInfinite,
    required super.addContractToScore,
  });

  factory FrenchBeloteGameSetting.fromJSON(Map<String, dynamic>? json) {
    return FrenchBeloteGameSetting(
        maxPoint: json?['max_point'],
        isInfinite: json?['is_infinite'],
        addContractToScore: json?['add_contract_to_score']);
  }
}
