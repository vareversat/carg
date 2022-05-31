import 'package:carg/models/score/round/round.dart';
import 'package:carg/models/score/score.dart';

class FakeScore extends Score {
  FakeScore(String? id) : super(id: id);

  @override
  Score<Round> deleteLastRound() {
    return this;
  }

  @override
  Round getLastRound() {
    throw UnimplementedError();
  }

  @override
  Score<Round> replaceLastRound(Round round) {
    return this;
  }

  @override
  Map<String, dynamic> toJSON() {
    throw UnimplementedError();
  }
}