import 'dart:convert';

import 'package:carg/models/carg_player_object.dart';
import 'package:carg/models/game_stats.dart';
import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class Player extends CargPlayerObject with ChangeNotifier {
  String? linkedUserId;
  String? firstName;
  String? lastName;
  String? ownedBy;
  String? _gravatarProfilePicture;
  bool owned;
  late String _userName;
  late bool testing;
  late bool admin;
  late String _profilePicture;
  late bool _selected;
  late bool _useGravatarProfilePicture;
  static const String defaultProfilePicture =
      'https://firebasestorage.googleapis.com/v0/b/carg-d3732.appspot.com/o/carg_logo.png?alt=media&token=861511da-db26-4216-8ee6-29b20c0a6852';

  String? get gravatarProfilePicture => _gravatarProfilePicture;

  set gravatarProfilePicture(String? value) {
    String emailHash;
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

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  String get profilePicture {
    if (!useGravatarProfilePicture) {
      return _profilePicture;
    } else {
      return _gravatarProfilePicture!;
    }
  }

  set profilePicture(String value) {
    _profilePicture = value;
    notifyListeners();
  }

  Player(
      {String? id,
      List<GameStats>? gameStatsList,
      this.firstName,
      this.lastName,
      this.ownedBy,
      userName,
      profilePicture,
      this.linkedUserId,
      useGravatarProfilePicture,
      gravatarProfilePicture,
      testing,
      admin,
      required this.owned})
      : super(id: id, gameStatsList: gameStatsList) {
    this.testing = testing ?? false;
    this.admin = admin ?? false;
    this.gameStatsList = gameStatsList ?? [];
    _profilePicture = profilePicture ?? defaultProfilePicture;
    _userName = userName ?? '';
    _selected = false;
    _useGravatarProfilePicture = useGravatarProfilePicture ?? false;
    _gravatarProfilePicture = gravatarProfilePicture;
  }

  Color getSideColor(BuildContext context) {
    if (testing) {
      return Colors.purple;
    } else if (!owned) {
      return Theme.of(context).primaryColor;
    } else {
      return Theme.of(context).colorScheme.secondary;
    }
  }

  factory Player.fromJSON(Map<String?, dynamic>? json, String id) {
    return Player(
        id: id,
        gameStatsList: GameStats.fromJSONList(json?['game_stats']),
        firstName: json?['first_name'],
        lastName: json?['last_name'],
        userName: json?['user_name'],
        linkedUserId: json?['linked_user_id'],
        profilePicture: json?['profile_picture'],
        ownedBy: json?['owned_by'],
        useGravatarProfilePicture:
            json?['use_gravatar_profile_picture'] ?? false,
        gravatarProfilePicture: json?['gravatar_profile_picture'],
        owned: json?['owned'] ?? true,
        testing: json?['testing'] ?? false,
        admin: json?['admin'] ?? false);
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
      'linked_user_id': linkedUserId,
      'owned_by': ownedBy,
      'owned': owned,
      'testing': testing,
      'admin': admin
    };
  }

  static List<Player> fromJSONList(List<dynamic> jsonList) {
    return jsonList.map((json) => Player.fromJSON(json, '')).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Player &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(gameStatsList, other.gameStatsList) &&
          linkedUserId == other.linkedUserId &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          ownedBy == other.ownedBy &&
          _gravatarProfilePicture == other._gravatarProfilePicture &&
          owned == other.owned &&
          _userName == other._userName &&
          testing == other.testing &&
          admin == other.admin &&
          _profilePicture == other._profilePicture &&
          _selected == other._selected &&
          _useGravatarProfilePicture == other._useGravatarProfilePicture;

  @override
  int get hashCode =>
      super.hashCode ^
      gameStatsList.hashCode ^
      linkedUserId.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      ownedBy.hashCode ^
      _gravatarProfilePicture.hashCode ^
      owned.hashCode ^
      _userName.hashCode ^
      testing.hashCode ^
      admin.hashCode ^
      _profilePicture.hashCode ^
      _selected.hashCode ^
      _useGravatarProfilePicture.hashCode;

  @override
  String toString() {
    return 'Player{id: $id, \n'
        'gameStatsList: $gameStatsList, \n'
        'linkedUserId: $linkedUserId, \n'
        'firstName: $firstName, \n'
        'lastName: $lastName, \n'
        'ownedBy: $ownedBy, \n'
        '_gravatarProfilePicture: $_gravatarProfilePicture, \n'
        'owned: $owned, \n'
        '_userName: $_userName, \n'
        'testing: $testing, \n'
        'admin: $admin, \n'
        '_profilePicture: $_profilePicture, \n'
        '_selected: $_selected, \n'
        '_useGravatarProfilePicture: $_useGravatarProfilePicture}';
  }
}
