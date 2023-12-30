import 'package:carg/models/game/setting/game_setting.dart';

abstract class BeloteGameSetting extends GameSetting {
  late bool _addContractToScore;

  BeloteGameSetting({
    required super.maxPoint,
    required super.isInfinite,
    required bool addContractToScore,
  }) {
    _addContractToScore = addContractToScore;
  }

  bool get addContractToScore => _addContractToScore;

  set addContractToScore(bool value) {
    _addContractToScore = value;
    notifyListeners();
  }
}
