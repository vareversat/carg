import 'dart:async';

import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/register/pin_code_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<String> mailAndPasswordLogIn(String email, String password) async {
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

  Future<void> sendSignInWithEmailLink(String email) async {
    try {
      var acs = ActionCodeSettings(
          url: 'https://carg.page.link/',
          handleCodeInApp: true,
          iOSBundleId: 'fr.devosud.carg',
          androidPackageName: 'fr.devosud.carg',
          androidInstallApp: true,
          androidMinimumVersion: '18');
      await FirebaseAuth.instance
          .sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<String> signInWithEmailLink(String email, String link) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailLink(emailLink: link, email: email);
      _connectedUser = result.user;
      _player = await _playerService.getPlayerOfUser(_connectedUser!.uid);
      _expiryDate = (await _connectedUser!.getIdTokenResult()).expirationTime;
      await _connectedUser!.getIdTokenResult(true);
      return _connectedUser!.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<String> validatePhoneNumber(
      String smsCode, String verificationId) async {
    try {
      var _credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      var result =
          await FirebaseAuth.instance.signInWithCredential(_credential);
      _connectedUser = result.user;
      _player = await _playerService.getPlayerOfUser(_connectedUser!.uid);
      _expiryDate = (await _connectedUser!.getIdTokenResult()).expirationTime;
      await _connectedUser!.getIdTokenResult(true);
      return _connectedUser!.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future changePhoneNumber(
      String smsCode, String verificationId) async {
    try {
      var _credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await _connectedUser!.updatePhoneNumber(_credential);
      await _connectedUser!.getIdTokenResult(true);
      _connectedUser = FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<dynamic> resendPhoneVerificationCode(
      String phoneNumber, BuildContext context) async {
    await _verifyPhoneNumber(
        phoneNumber,
        context,
        (verificationId, forceResendingToken) => SnackBar(
              margin: EdgeInsets.all(20),
              duration: Duration(seconds: 15),
              behavior: SnackBarBehavior.floating,
              content: Text('Code renvoyé avec succès',
                  style: CustomTextStyle.snackBarTextStyle(context)),
            ),
        (credentials) => SnackBar(
              margin: EdgeInsets.all(20),
              duration: Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              content: Text('Erreur : Le numéro de téléphone est invalide',
                  style: CustomTextStyle.snackBarTextStyle(context)),
            ));
  }

  Future<dynamic> sendPhoneVerificationCode(
      String phoneNumber, BuildContext context, CredentialVerificationType credentialVerificationType) async {
    await _verifyPhoneNumber(
        phoneNumber,
        context,
        (verificationId, forceResendingToken) => Navigator.push(
            context,
            CustomRouteLeftAndRight(
                builder: (context) => PinCodeVerificationScreen(
                    phoneNumber: phoneNumber, verificationId: verificationId, credentialVerificationType: credentialVerificationType))),
        (credentials) => SnackBar(
              margin: EdgeInsets.all(20),
              duration: Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              content: Text('Erreur : Le numéro de téléphone est invalide',
                  style: CustomTextStyle.snackBarTextStyle(context)),
            ));
  }

  Future<dynamic> _verifyPhoneNumber(
      String phoneNumber,
      BuildContext context,
      Function(String verificationId, int? forceResendingToken) onCodeSend,
      Function(FirebaseAuthException credentials) onVerificationFailed) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credentials) {},
        verificationFailed: onVerificationFailed,
        codeSent: onCodeSend,
        codeAutoRetrievalTimeout: (String verificationId) {});
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

  Future<void> changeEmail(String newEmail) async {
    try {
      await _connectedUser!.verifyBeforeUpdateEmail(newEmail);
      _connectedUser = FirebaseAuth.instance.currentUser;
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

  String? getConnectedUserPhoneNumber() {
    return _connectedUser?.phoneNumber;
  }

  String? getPlayerIdOfUser() {
    return _player?.id;
  }

  Player? getPlayer() {
    return _player;
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

enum CredentialVerificationType {EDIT, CREATE}
