import 'package:carg/models/score/round/round.dart';

class FakeRound extends Round {
  @override
  void computeRound() {}

  @override
  String realTimeDisplay() {
    throw UnimplementedError();
  }
}
