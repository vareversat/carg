// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/register/pin_code_verification_screen.dart';
import 'package:carg/views/screens/register/register_screen.dart';
import 'package:carg/views/screens/register/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  User? connectedUser;
  Player? _player;
  final PlayerService _playerService = PlayerService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthService();

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }



  Future<String> googleLogIn() async {
    try {
      var _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      final googleUser = (await _googleSignIn.signIn())!;
      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      connectedUser =
          (await _firebaseAuth.signInWithCredential(credential)).user;
      _player = await _playerService.getPlayerOfUser(connectedUser!.uid);
      await connectedUser!.getIdTokenResult(true);
      return connectedUser!.uid;
    } on PlatformException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<void> sendSignInWithEmailLink(String email) async {
    try {
      var acs = ActionCodeSettings(
          url: 'https://carg.page.link/',
          handleCodeInApp: true,
          iOSBundleId: 'fr.vareversat.carg',
          androidPackageName: 'fr.vareversat.carg',
          androidInstallApp: true,
          androidMinimumVersion: '18');
      await _firebaseAuth
          .sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<String> signInWithEmailLink(String email, String link) async {
    try {
      var result = await _firebaseAuth
          .signInWithEmailLink(emailLink: link, email: email);
      connectedUser = result.user;
      _player = await _playerService.getPlayerOfUser(connectedUser!.uid);
      await connectedUser!.getIdTokenResult(true);
      return connectedUser!.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<String> validatePhoneNumber(String smsCode, String verificationId) async {
    try {
      var _credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      var result =
      await _firebaseAuth.signInWithCredential(_credential);
      connectedUser = result.user;
      _player = await _playerService.getPlayerOfUser(connectedUser!.uid);
      await connectedUser!.getIdTokenResult(true);
      return connectedUser!.uid;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future changePhoneNumber(String smsCode, String verificationId) async {
    try {
      var _credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await connectedUser!.updatePhoneNumber(_credential);
      await connectedUser!.getIdTokenResult(true);
      connectedUser = _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Future<dynamic> resendPhoneVerificationCode(String phoneNumber, BuildContext context) async {
    await _verifyPhoneNumber(
        phoneNumber,
        context,
            (verificationId, forceResendingToken) =>
            InfoSnackBar.showSnackBar(context, 'Code renvoyé avec succès'),
            (credentials) => InfoSnackBar.showSnackBar(
            context, 'Erreur : Le numéro de téléphone est invalide'));
  }

  Future<dynamic> sendPhoneVerificationCode(String phoneNumber,
      BuildContext context,
      CredentialVerificationType credentialVerificationType) async {
    await _verifyPhoneNumber(
        phoneNumber,
        context,
            (verificationId, forceResendingToken) => Navigator.push(
            context,
            CustomRouteLeftToRight(
                builder: (context) => PinCodeVerificationScreen(
                    phoneNumber: phoneNumber,
                    verificationId: verificationId,
                    credentialVerificationType: credentialVerificationType))),
            (credentials) => SnackBar(
              margin: const EdgeInsets.all(20),
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              content: Text('Erreur : Le numéro de téléphone est invalide',
                  style: CustomTextStyle.snackBarTextStyle(context)),
            ));
  }

  Future<dynamic> _verifyPhoneNumber(String phoneNumber,
      BuildContext context,
      Function(String verificationId, int? forceResendingToken) onCodeSend,
      Function(FirebaseAuthException credentials) onVerificationFailed) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credentials) {},
        verificationFailed: onVerificationFailed,
        codeSent: onCodeSend,
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<bool> isAlreadyLogin() async {
    await Firebase.initializeApp(name: 'yoo');
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      // Make sure the user is disconnected
      await _firebaseAuth.signOut();
      return false;
    }
    final expiryDate = (await firebaseUser.getIdTokenResult()).expirationTime!;
    if (expiryDate.isBefore(DateTime.now())) {
      // Make sure the user is disconnected
      await _firebaseAuth.signOut();
      return false;
    }
    await firebaseUser.getIdTokenResult(true);
    connectedUser = firebaseUser;
    _player = await _playerService.getPlayerOfUser(connectedUser!.uid);
    return true;
  }

  Future<void> signOut(BuildContext context) async {
    connectedUser = null;
    notifyListeners();
    await _firebaseAuth.signOut();
    await Navigator.pushReplacement(
        context, CustomRouteFade(builder: (context) => const RegisterScreen()));
  }

  Future<void> changeEmail(String newEmail) async {
    try {
      await connectedUser!.verifyBeforeUpdateEmail(newEmail);
      connectedUser = _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw CustomException(e.code);
    }
  }

  Widget getCorrectLandingScreen() {
    if (_player == null) {
      return const WelcomeScreen();
    } else {
      return const HomeScreen(requestedIndex: 0);
    }
  }

  String? getConnectedUserId() {
    return connectedUser?.uid;
  }

  String? getConnectedUserEmail() {
    return connectedUser?.email;
  }

  String? getConnectedUserPhoneNumber() {
    return connectedUser?.phoneNumber;
  }

  String? getPlayerIdOfUser() {
    return _player?.id;
  }

  bool? getAdmin() {
    return _player?.admin;
  }

  Player? getPlayer() {
    return _player;
  }

  void setCurrentPlayer(Player player) {
    _player = player;
  }
}

enum CredentialVerificationType { EDIT, CREATE }
