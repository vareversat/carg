import 'package:flutter/foundation.dart';

abstract class GameSetting with ChangeNotifier {
  late int _maxPoint;
  late bool _isInfinite;

  GameSetting({required int maxPoint, required bool isInfinite}) {
    _maxPoint = maxPoint;
    _isInfinite = isInfinite;
  }

  set isInfinite(bool value) {
    _isInfinite = value;
    notifyListeners();
  }

  set maxPoint(int value) {
    _maxPoint = value;
    notifyListeners();
  }

  bool get isInfinite => _isInfinite;

  int get maxPoint => _maxPoint;

  Map<String, dynamic> toJSON() {
    return {'max_point': maxPoint, 'is_infinite': isInfinite};
  }

  @override
  String toString() {
    return 'GameSetting{_maxPoint: $_maxPoint, _isInfinite: $_isInfinite}';
  }
}
