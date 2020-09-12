import 'dart:async';

import 'package:carg/models/player/player.dart';
import 'package:carg/services/firebase_exception.dart';
import 'package:carg/services/player_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthService with ChangeNotifier {
  FirebaseUser _connectedUser;
  DateTime _expiryDate;
  final _playerService = PlayerService();

  String getConnectedConnectedId() {
    return _connectedUser?.uid;
  }

  bool get isAuth {
    return _connectedUser != null && _expiryDate.isAfter(DateTime.now());
  }

  Future<String> signUp(String email, String password, String username) async {
    try {
      var result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var user = result.user;
      _connectedUser = user;
      _expiryDate = (await _connectedUser.getIdToken()).expirationTime;
      await _sendEmailVerification();
      await _playerService.addPlayer(
          Player(userName: username, linkedUserId: _connectedUser.uid));
      return user.uid;
    } on PlatformException catch (e) {
      throw FirebaseException(e.code);
    }
  }

  Future<String> localLoginIn() async {
    try {
      var result = await FirebaseAuth.instance.signInAnonymously();
      _connectedUser = result.user;
      _expiryDate = (await _connectedUser.getIdToken()).expirationTime;
      await _connectedUser.getIdToken(refresh: true);
      await _playerService.addPlayer(
          Player(userName: 'joueur', linkedUserId: _connectedUser.uid));
      return _connectedUser.uid;
    } on PlatformException catch (e) {
      throw FirebaseException(e.code);
    }
  }

  Future<String> firebaseLoginIn(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _connectedUser = result.user;
      _expiryDate = (await _connectedUser.getIdToken()).expirationTime;
      if (!await _isEmailVerified()) {
        throw FirebaseException('ERROR_EMAIL_NOT_VALIDATED');
      }
      await _connectedUser.getIdToken(refresh: true);
      return _connectedUser.uid;
    } on PlatformException catch (e) {
      throw FirebaseException(e.code);
    }
  }

  Future<String> linkAnonymousToCredentials(
      String email, String password) async {
    try {
      var credentials =
          EmailAuthProvider.getCredential(email: email, password: password);
      await _connectedUser.linkWithCredential(credentials);
      notifyListeners();
      await _sendEmailVerification();
      return _connectedUser.uid;
    } on PlatformException catch (e) {
      throw FirebaseException(e.code);
    }
  }

  Future<bool> isLocalLogin() async {
    var user = await FirebaseAuth.instance.currentUser();
    return user?.isAnonymous ?? false;
  }

  Future<bool> isAlreadyLogin() async {
    final firebaseUser = (await FirebaseAuth.instance.currentUser());
    if (firebaseUser == null) {
      return false;
    }
    final expiryDate = (await firebaseUser.getIdToken()).expirationTime;
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    await firebaseUser.getIdToken(refresh: true);
    _connectedUser = firebaseUser;
    _expiryDate = expiryDate;
    return true;
  }

  Future<void> signOut() async {
    _connectedUser = null;
    _expiryDate = null;
    notifyListeners();
    return FirebaseAuth.instance.signOut();
  }

  String getConnectedUserEmail() {
    return _connectedUser?.email;
  }

  Future<void> _sendEmailVerification() async {
    var user = await FirebaseAuth.instance.currentUser();
    await user.sendEmailVerification();
  }

  Future<bool> _isEmailVerified() async {
    var user = await FirebaseAuth.instance.currentUser();
    return user.isEmailVerified;
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email ?? _connectedUser.email);
  }

  Future<void> changeEmail(String newEmail, String currentPassword) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _connectedUser.email, password: currentPassword);
      await _connectedUser.updateEmail(newEmail);
      await _sendEmailVerification();
    } on PlatformException catch (e) {
      throw FirebaseException(e.code);
    }
  }
}
