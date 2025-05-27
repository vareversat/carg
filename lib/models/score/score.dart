import 'package:carg/models/carg_object.dart';
import 'package:carg/models/score/round/round.dart';
import 'package:flutter/foundation.dart';

abstract class Score<T extends Round> extends CargObject with ChangeNotifier {
  Score({super.id});

  Score deleteRound(int index);

  Score updateRound(T round, int index);

  void refreshScore();

  @override
  Map<String, dynamic> toJSON();
}
