import 'package:carg/models/carg_object.dart';

abstract class Score extends CargObject {
  Score({id}) : super(id: id);

  @override
  Map<String, dynamic> toJSON() {
    return {'id': id};
  }
}
