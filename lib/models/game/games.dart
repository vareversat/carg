import 'package:carg/models/game/game.dart';
import 'package:flutter/foundation.dart';

class Games<T extends Game?> with ChangeNotifier {
  late List<T> _gameList;

  Games({gameList}) {
    _gameList = gameList ?? [];
  }

  List<T> get gameList => _gameList;

  set gameList(List<T> value) {
    _gameList = value;
    notifyListeners();
  }
}
