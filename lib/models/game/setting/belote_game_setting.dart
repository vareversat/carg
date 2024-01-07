import 'package:carg/models/game/setting/game_setting.dart';

abstract class BeloteGameSetting extends GameSetting {
  late bool _sumTrickPointsAndContract;

  BeloteGameSetting({
    required super.maxPoint,
    required super.isInfinite,
    required bool sumTrickPointsAndContract,
  }) {
    _sumTrickPointsAndContract = sumTrickPointsAndContract;
  }

  bool get sumTrickPointsAndContract => _sumTrickPointsAndContract;

  set sumTrickPointsAndContract(bool value) {
    _sumTrickPointsAndContract = value;
    notifyListeners();
  }

  @override
  Map<String, dynamic> toJSON() {
    var tmpJSON = super.toJSON();
    tmpJSON.addAll({
      'sum_trick_points_and_contract': sumTrickPointsAndContract,
    });
    return tmpJSON;
  }
}
