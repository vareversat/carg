import 'dart:async';

import 'package:carg/services/auth_service.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/register/register_screen.dart';
import 'package:carg/views/screens/register/welcome_screen.dart';
import 'package:carg/views/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final CredentialVerificationType credentialVerificationType;

  PinCodeVerificationScreen(
      {required this.phoneNumber,
      required this.verificationId,
      required this.credentialVerificationType});

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  final TextEditingController _pinTextController = TextEditingController();
  final GlobalKey<State> _keyLoaderLoading = GlobalKey<State>();
  final GlobalKey<State> _keyLoaderSuccess = GlobalKey<State>();
  final GlobalKey<State> _formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? _errorController;

  @override
  void initState() {
    _errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    _errorController!.close();
    super.dispose();
  }

  void _resendCode() async {
    Dialogs.showLoadingDialog(context, _keyLoaderLoading, 'Renvoie...');
    try {
      await Provider.of<AuthService>(context, listen: false)
          .resendPhoneVerificationCode(widget.phoneNumber, context);
    } on CustomException catch (e) {
      _snackBar(e.message);
    }
    Navigator.of(_keyLoaderLoading.currentContext!, rootNavigator: true).pop();
  }

  void _verifyCode() async {
    Dialogs.showLoadingDialog(context, _keyLoaderLoading, 'Validation...');
    try {
      if (widget.credentialVerificationType == CredentialVerificationType.CREATE) {
        await Provider.of<AuthService>(context, listen: false)
            .validatePhoneNumber(
                _pinTextController.text, widget.verificationId);
        Navigator.of(_keyLoaderLoading.currentContext!, rootNavigator: true).pop();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(requestedIndex: 0),
          ),
        );
      } else {
        await Provider.of<AuthService>(context, listen: false)
            .changePhoneNumber(
            _pinTextController.text, widget.verificationId);
        Navigator.of(_keyLoaderLoading.currentContext!, rootNavigator: true).pop();
        Dialogs.showMessageDialog(context, _keyLoaderSuccess, 'Nouveau numéro validé avec succès !');
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(_keyLoaderSuccess.currentContext!, rootNavigator: true).pop();
        if (Provider.of<AuthService>(context, listen: false).getPlayer() != null) {
          await Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (Route<dynamic> route) => false, arguments: 0);
        } else {
          await Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.routeName, (Route<dynamic> route) => false, arguments: 0);
        }

      }
    } on CustomException catch (e) {
      Navigator.of(_keyLoaderLoading.currentContext!, rootNavigator: true).pop();
      _errorController!.add(ErrorAnimationType.shake);
      _pinTextController.clear();
      _snackBar(e.message);
    }

  }

  ScaffoldFeatureController _snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        content:
            Text(message, style: CustomTextStyle.snackBarTextStyle(context)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView(children: <Widget>[
        SizedBox(height: 30),
        Container(
          height: 150,
          child: SvgPicture.asset(
            'assets/images/card_game.svg',
          ),
        ),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Code de vérification',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
          child: RichText(
            text: TextSpan(
                text: 'Veuillez entrer le code envoyé au ',
                children: [
                  TextSpan(
                      text: '${widget.phoneNumber}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ],
                style: TextStyle(color: Colors.black54, fontSize: 15)),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Form(
          key: _formKey,
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscuringCharacter: '•',
                blinkWhenObscuring: false,
                animationType: AnimationType.none,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    selectedColor: Theme.of(context).primaryColor,
                    selectedFillColor: Theme.of(context).primaryColor,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Theme.of(context).accentColor,
                    inactiveFillColor: Theme.of(context).accentColor,
                    activeFillColor: Colors.white),
                cursorColor: Colors.white,
                errorAnimationDuration: 25,
                errorAnimationController: _errorController,
                controller: _pinTextController,
                keyboardType: TextInputType.number,
                onCompleted: (value) {
                  _verifyCode();
                },
                onChanged: (value) {},
                beforeTextPaste: null,
              )),
        ),
        TextButton(
          onPressed: () {
            _pinTextController.clear();
          },
          child: Text('Tout supprimer'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Vous n'avez pas reçu le code ? ",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            TextButton(
                onPressed: () => _resendCode(),
                child: Text(
                  'RENVOYER',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ))
          ],
        )
      ]),
    ));
  }
}
