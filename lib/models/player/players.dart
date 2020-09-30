import 'package:carg/models/player/player.dart';
import 'package:flutter/foundation.dart';

abstract class Players with ChangeNotifier {
  Players();

  void onSelectedPlayer(Player player);

  String getSelectedPlayersStatus();

  bool isFull();

  List<String> getPlayerIds();
}
