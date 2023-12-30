import 'package:carg/models/game/setting/belote_game_setting.dart';

class ContreeBeloteGameSetting extends BeloteGameSetting {
  ContreeBeloteGameSetting({
    required super.maxPoint,
    required super.isInfinite,
    required super.addContractToScore,
  });

  factory ContreeBeloteGameSetting.fromJSON(Map<String, dynamic>? json) {
    return ContreeBeloteGameSetting(
        maxPoint: json?['max_point'],
        isInfinite: json?['is_infinite'],
        addContractToScore: json?['add_contract_to_score']);
  }
}
