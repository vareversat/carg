import 'package:flutter/foundation.dart';

abstract class Round with ChangeNotifier {
  int index;

  void computeRound();

  String realTimeDisplay();

  Round({this.index});
}
