import 'dart:async';

import 'package:carg/models/player.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/player_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AUTH_PROVIDER { EMAIL, GOOGLE, LOCAL }

class AuthService with ChangeNotifier {
  User? _connectedUser;
  Player? _player;
  DateTime? _expiryDate;
  final _playerService = PlayerService();

  bool get isAuth {
    return _connectedUser != null && _expiryDate!.isAfter(DateTime.now());
  }

  Future<String> localLogIn() async {
    try {
      var result = await FirebaseAuth.instance.signInAnonymously();
      _connectedUser = result.user;
      _expiryDate = (await _connectedUser!.getIdTokenResult()).expirationTime;
      await _connectedUser!.getIdTokenResult(true);
      var player =
          Player(userName: 'Nouveau joueur', linkedUserId: _connectedUser!.uid);
      var playerId = await _playerService.addPlayer(player);
      player.id = playerId;
      _player = player;
      return _connectedUser!.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<String> googleLogIn() async {
    try {
      var _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      final googleUser = (await _googleSignIn.signIn())!;
      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      _connectedUser =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      _player = await _playerService.getPlayerOfUser(_connectedUser!.uid);
      _expiryDate = (await _connectedUser!.getIdTokenResult()).expirationTime;
      await _connectedUser!.getIdTokenResult(true);
      return _connectedUser!.uid;
    } on PlatformException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<String> mailLogIn(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _connectedUser = result.user;
      _player = await _playerService.getPlayerOfUser(_connectedUser!.uid);
      _expiryDate = (await _connectedUser!.getIdTokenResult()).expirationTime;
      if (!await _isEmailVerified()) {
        throw CustomException('ERROR_EMAIL_NOT_VALIDATED');
      }
      await _connectedUser!.getIdTokenResult(true);
      return _connectedUser!.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<String> linkAnonymousToCredentials(
      String email, String password) async {
    try {
      var credentials =
          EmailAuthProvider.credential(email: email, password: password);
      await _connectedUser!.linkWithCredential(credentials);
      notifyListeners();
      await _sendEmailVerification();
      return _connectedUser!.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<bool> isLocalLogin() async {
    var user = FirebaseAuth.instance.currentUser;
    return (user?.isAnonymous ?? false) || user?.email == null;
  }

  Future<bool> isAlreadyLogin() async {
    await Firebase.initializeApp();
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return false;
    }
    final expiryDate = (await firebaseUser.getIdTokenResult()).expirationTime!;
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    await firebaseUser.getIdTokenResult(true);
    _connectedUser = firebaseUser;
    _player = await _playerService.getPlayerOfUser(_connectedUser!.uid);
    _expiryDate = expiryDate;
    return true;
  }

  Future<void> signOut() async {
    _connectedUser = null;
    _expiryDate = null;
    notifyListeners();
    return FirebaseAuth.instance.signOut();
  }

  Future<void> resetPassword(String? email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email ?? _connectedUser!.email!);
  }

  Future<void> changeEmail(String newEmail, String currentPassword) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _connectedUser!.email!, password: currentPassword);
      await _connectedUser!.updateEmail(newEmail);
      await _sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  String? getConnectedUserId() {
    return _connectedUser?.uid;
  }

  String? getConnectedUserEmail() {
    return _connectedUser?.email;
  }

  String? getPlayerIdOfUser() {
    return _player?.id;
  }

  Future<void> _sendEmailVerification() async {
    var user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  Future<bool> _isEmailVerified() async {
    var user = FirebaseAuth.instance.currentUser!;
    return user.emailVerified;
  }
}
