import 'package:carg/models/carg_object.dart';
import 'package:carg/models/game_stats.dart';
import 'package:flutter/material.dart';

class Player extends CargObject with ChangeNotifier {
  List<GameStats>? gameStatsList;
  String? linkedUserId;
  String? firstName;
  String? lastName;
  String? _userName;
  late String _profilePicture;
  late bool _selected;

  bool get selected => _selected;

  set selected(bool value) {
    _selected = value;
    notifyListeners();
  }

  String? get userName => _userName;

  set userName(String? value) {
    _userName = value;
    notifyListeners();
  }

  String get profilePicture => _profilePicture;

  set profilePicture(String value) {
    _profilePicture = value;
    notifyListeners();
  }

  Player(
      {String? id,
      gameStatsList,
      this.firstName,
      this.lastName,
      userName,
      profilePicture =
          'https://firebasestorage.googleapis.com/v0/b/carg-d3732.appspot.com/o/blank-profile-picture-png.png?alt=media&token=15801776-b75f-4ad5-bec1-2fe834a99f9a',
      this.linkedUserId})
      : super(id: id) {
    this.gameStatsList = gameStatsList ?? [];
    _profilePicture = profilePicture;
    _userName = userName;
    _selected = false;
  }

  double totalWinPercentage() {
    return double.parse(
        ((totalWonGames() * 100) / totalPlayedGames()).toStringAsFixed(1));
  }

  int totalWonGames() {
    var total = 0;
    for (var gameStat in gameStatsList!) {
      total += gameStat.wonGames;
    }
    return total;
  }

  int totalPlayedGames() {
    var total = 0;
    for (var gameStat in gameStatsList!) {
      total += gameStat.playedGames;
    }
    return total;
  }

  factory Player.fromJSON(Map<String, dynamic>? json, String? id) {
    return Player(
        id: id,
        gameStatsList: GameStats.fromJSONList(json?['game_stats']),
        firstName: json?['first_name'] ?? '',
        lastName: json?['last_name'] ?? '',
        userName: json?['user_name'] ?? '',
        linkedUserId: json?['linked_user_id'] ?? '',
        profilePicture: json?['profile_picture'] ?? '');
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'game_stats': gameStatsList!.map((stat) => stat.toJSON()).toList(),
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName,
      'profile_picture': profilePicture,
      'linked_user_id': linkedUserId
    };
  }

  static List<Player> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => Player.fromJSON(json, '')).toList();
  }

  @override
  String toString() {
    return 'Player{gameStatsList: $gameStatsList, linkedUserId: $linkedUserId, firstName: $firstName, lastName: $lastName, _userName: $_userName, _profilePicture: $_profilePicture, _selected: $_selected}';
  }
}
