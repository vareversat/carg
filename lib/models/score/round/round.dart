import 'package:carg/models/game/setting/game_setting.dart';
import 'package:flutter/widgets.dart';

abstract class Round<S extends GameSetting> with ChangeNotifier {
  int? index;
  S? settings;

  void computeRound();

  String realTimeDisplay(BuildContext context);

  Round({this.index, this.settings});
}
