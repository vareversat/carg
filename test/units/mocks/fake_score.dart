import 'package:carg/models/game/setting/game_setting.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:carg/models/score/score.dart';

class FakeScore extends Score {
  FakeScore(String? id) : super(id: id);

  @override
  Score<Round> deleteRound(int index) {
    return this;
  }

  @override
  Map<String, dynamic> toJSON() {
    throw UnimplementedError();
  }

  @override
  void refreshScore() {
    throw UnimplementedError();
  }

  @override
  Score<Round<GameSetting>> updateRound(Round<GameSetting> round, int index) {
    return this;
  }
}
