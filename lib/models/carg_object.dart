abstract class CargObject {
  String? id;

  CargObject({this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CargObject && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJSON();

  @override
  String toString() {
    return '$id';
  }
}
