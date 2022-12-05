import 'package:carg/models/score/round/round.dart';
import 'package:flutter/widgets.dart';

class FakeRound extends Round {
  @override
  void computeRound() {}

  @override
  String realTimeDisplay(BuildContext context) {
    throw UnimplementedError();
  }
}
