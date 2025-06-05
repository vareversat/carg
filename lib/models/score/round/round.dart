import 'package:carg/models/game/setting/game_setting.dart';
import 'package:flutter/widgets.dart';

abstract class Round<S extends GameSetting> with ChangeNotifier {
  int? index;
  S? settings;
  late bool _isManualMode;

  void computeRound();

  String realTimeDisplay(BuildContext context);

  set isManualMode(bool value) {
    _isManualMode = value;
    notifyListeners();
  }

  bool get isManualMode => _isManualMode;

  Round({this.index, this.settings, bool? isManualMode}) {
    this._isManualMode = isManualMode ?? false;
  }
}
