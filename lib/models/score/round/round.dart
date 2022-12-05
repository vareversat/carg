import 'package:flutter/widgets.dart';

abstract class Round with ChangeNotifier {
  int? index;

  void computeRound();

  String realTimeDisplay(BuildContext context);

  Round({this.index});
}
