import 'package:carg/models/carg_object.dart';

class Bet extends CargObject {
  String name;
  int value;

  Bet({String id, this.name, this.value}) : super(id: id);

  factory Bet.fromJSON(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Bet(id: json['id'], name: json['name'], value: json['value']);
  }

  static List<Bet> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => Bet.fromJSON(json)).toList();
  }

  @override
  Map<String, dynamic> toJSON() {
    return {'id': id, 'name': name, 'value': value};
  }
}
