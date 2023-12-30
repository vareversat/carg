import 'package:carg/models/game/setting/belote_game_setting.dart';

class CoincheBeloteGameSetting extends BeloteGameSetting {
  CoincheBeloteGameSetting({
    required super.maxPoint,
    required super.isInfinite,
    required super.addContractToScore,
  });

  factory CoincheBeloteGameSetting.fromJSON(Map<String, dynamic>? json) {
    return CoincheBeloteGameSetting(
        maxPoint: json?['max_point'],
        isInfinite: json?['is_infinite'],
        addContractToScore: json?['add_contract_to_score']);
  }
}
