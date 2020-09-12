import 'package:carg/models/carg_object.dart';
import 'package:flutter/material.dart';

class Player extends CargObject with ChangeNotifier {
  String firstName;
  String lastName;
  String _userName;
  String _profilePicture;
  int playedGames;
  int wonGames;
  String linkedUserId;
  bool _selected = false;

  bool get selected => _selected;

  set selected(bool value) {
    _selected = value;
    notifyListeners();
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  String get profilePicture => _profilePicture ?? '';

  set profilePicture(String value) {
    _profilePicture = value;
    notifyListeners();
  }

  Player(
      {String id,
      this.firstName,
      this.lastName,
      userName,
      profilePicture =
          'https://www.dts.edu/wp-content/uploads/sites/6/2018/04/Blank-Profile-Picture.jpg',
      this.playedGames = 0,
      this.wonGames = 0,
      this.linkedUserId})
      : super(id: id) {
    _profilePicture = profilePicture;
    _userName = userName;
  }

  factory Player.fromJSON(Map<String, dynamic> json, String id) {
    if (json == null) {
      return null;
    }
    return Player(
        id: id,
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        userName: json['user_name'] ?? '',
        linkedUserId: json['linked_user_id'] ?? '',
        profilePicture: json['profile_picture'] ?? '',
        playedGames: json['played_games'] ?? 0,
        wonGames: json['won_games'] ?? 0);
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName,
      'profile_picture': profilePicture,
      'played_games': playedGames,
      'won_games': wonGames,
      'linked_user_id': linkedUserId
    };
  }

  static List<Player> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => Player.fromJSON(json, '')).toList();
  }

  @override
  String toString() {
    return 'Player{id: $id, linkedUserId: $linkedUserId, firstName: $firstName, lastName: $lastName, userName: $userName, profilePicture: $profilePicture, playedGames: $playedGames, wonGames: $wonGames}';
  }
}
