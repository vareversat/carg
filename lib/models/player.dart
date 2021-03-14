import 'dart:convert';

import 'package:carg/models/carg_object.dart';
import 'package:carg/models/game_stats.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class Player extends CargObject with ChangeNotifier {
  List<GameStats>? gameStatsList;
  String? linkedUserId;
  String? firstName;
  String? lastName;
  String? _userName;
  late String _gravatarProfilePicture;
  late String _profilePicture;
  late bool _selected;
  late bool _useGravatarProfilePicture;

  String get gravatarProfilePicture => _gravatarProfilePicture;

  set gravatarProfilePicture(String? value) {
    var emailHash;
    if (value == null) {
      emailHash = '';
    } else {
      emailHash = md5.convert(utf8.encode(value)).toString();
    }
    _gravatarProfilePicture = 'https://gravatar.com/avatar/$emailHash?s=200';
  }

  bool get useGravatarProfilePicture => _useGravatarProfilePicture;

  set useGravatarProfilePicture(bool value) {
    _useGravatarProfilePicture = value;
    notifyListeners();
  }

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

  String get profilePicture {
    if (!useGravatarProfilePicture) {
      return _profilePicture;
    } else {
      return _gravatarProfilePicture;
    }
  }

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
      this.linkedUserId,
      useGravatarProfilePicture,
      gravatarProfilePicture})
      : super(id: id) {
    this.gameStatsList = gameStatsList ?? [];
    _profilePicture = profilePicture;
    _userName = userName;
    _selected = false;
    _useGravatarProfilePicture = useGravatarProfilePicture ?? false;
    _gravatarProfilePicture = gravatarProfilePicture ?? '';
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
      profilePicture: json?['profile_picture'] ?? '',
      useGravatarProfilePicture: json?['use_gravatar_profile_picture'] ?? false,
      gravatarProfilePicture: json?['gravatar_profile_picture'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'game_stats': gameStatsList!.map((stat) => stat.toJSON()).toList(),
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName,
      'profile_picture': _profilePicture,
      'gravatar_profile_picture': gravatarProfilePicture,
      'use_gravatar_profile_picture': useGravatarProfilePicture,
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
