import 'dart:async';

import 'package:carg/models/player/player.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/player_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  User _connectedUser;
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
      _expiryDate = (await _connectedUser.getIdTokenResult()).expirationTime;
      await _sendEmailVerification();
      await _playerService.addPlayer(
          Player(userName: username, linkedUserId: _connectedUser.uid));
      return user.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<String> localLoginIn() async {
    try {
      var result = await FirebaseAuth.instance.signInAnonymously();
      _connectedUser = result.user;
      _expiryDate = (await _connectedUser.getIdTokenResult()).expirationTime;
      await _connectedUser.getIdTokenResult(true);
      await _playerService.addPlayer(
          Player(userName: 'joueur', linkedUserId: _connectedUser.uid));
      return _connectedUser.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<String> firebaseLoginIn(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _connectedUser = result.user;
      _expiryDate = (await _connectedUser.getIdTokenResult()).expirationTime;
      if (!await _isEmailVerified()) {
        throw CustomException('ERROR_EMAIL_NOT_VALIDATED');
      }
      await _connectedUser.getIdTokenResult(true);
      return _connectedUser.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<String> linkAnonymousToCredentials(
      String email, String password) async {
    try {
      var credentials =
          EmailAuthProvider.credential(email: email, password: password);
      await _connectedUser.linkWithCredential(credentials);
      notifyListeners();
      await _sendEmailVerification();
      return _connectedUser.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<bool> isLocalLogin() async {
    var user = FirebaseAuth.instance.currentUser;
    return user?.isAnonymous ?? false;
  }

  Future<bool> isAlreadyLogin() async {
    await Firebase.initializeApp();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return false;
    }
    final expiryDate = (await firebaseUser.getIdTokenResult()).expirationTime;
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    await firebaseUser.getIdTokenResult(true);
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
    var user = FirebaseAuth.instance.currentUser;
    await user.sendEmailVerification();
  }

  Future<bool> _isEmailVerified() async {
    var user = FirebaseAuth.instance.currentUser;
    return user.emailVerified;
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
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }
}
