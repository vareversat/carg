import 'package:carg/models/carg_object.dart';
import 'package:carg/models/score/round/round.dart';

abstract class Score<T extends Round> extends CargObject {
  Score({id}) : super(id: id);

  Round getLastRound();

  Score deleteLastRound();

  Score replaceLastRound(T round);

  @override
  Map<String, dynamic> toJSON();
}
