import 'package:carg/models/carg_object.dart';
import 'package:carg/models/score/round/round.dart';

abstract class Score extends CargObject {
  Score({id}) : super(id: id);

  Round getLastRound();

  @override
  Map<String, dynamic> toJSON();
}
