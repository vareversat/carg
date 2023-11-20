import 'dart:async';

import 'package:carg/const.dart';
import 'package:carg/exceptions/custom_exception.dart';
import 'package:carg/routes/custom_route_fade.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final CredentialVerificationType credentialVerificationType;

  const PinCodeVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    required this.credentialVerificationType,
  });

  @override
  State<StatefulWidget> createState() {
    return _PinCodeVerificationScreenState();
  }
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
    try {
      await Provider.of<AuthService>(context, listen: false)
          .resendPhoneVerificationCode(widget.phoneNumber, context);
    } on CustomException catch (e) {
      if (mounted) {
        InfoSnackBar.showSnackBar(context, e.message);
      }
    }
  }

  void _verifyCode() async {
    Dialogs.showLoadingDialog(
      context,
      _keyLoaderLoading,
      AppLocalizations.of(context)!.validating,
    );
    try {
      if (widget.credentialVerificationType ==
          CredentialVerificationType.CREATE) {
        await Provider.of<AuthService>(context, listen: false)
            .validatePhoneNumber(
          _pinTextController.text,
          widget.verificationId,
        );
        Navigator.of(_keyLoaderLoading.currentContext!, rootNavigator: true)
            .pop();
        if (mounted) {
          await Navigator.of(context).pushReplacement(
            CustomRouteFade(
              builder: (context) =>
                  Provider.of<AuthService>(context, listen: false)
                      .getCorrectLandingScreen(),
            ),
          );
        }
      } else {
        await Provider.of<AuthService>(context, listen: false)
            .changePhoneNumber(
          _pinTextController.text,
          widget.verificationId,
        );
        Navigator.of(
          _keyLoaderLoading.currentContext!,
          rootNavigator: true,
        ).pop();
        if (mounted) {
          Dialogs.showMessageDialog(
            context,
            _keyLoaderSuccess,
            AppLocalizations.of(context)!.newPhoneNumberValidate,
          );
        }
        await Future.delayed(
          const Duration(
            seconds: 2,
          ),
        );
        Navigator.of(
          _keyLoaderSuccess.currentContext!,
          rootNavigator: true,
        ).pop();
        if (mounted) {
          await Navigator.pushReplacement(
            context,
            CustomRouteFade(
              builder: (context) => Provider.of<AuthService>(
                context,
                listen: false,
              ).getCorrectLandingScreen(),
            ),
          );
        }
      }
    } on CustomException catch (e) {
      Navigator.of(
        _keyLoaderLoading.currentContext!,
        rootNavigator: true,
      ).pop();
      _errorController!.add(
        ErrorAnimationType.shake,
      );
      _pinTextController.clear();
      if (mounted) {
        InfoSnackBar.showSnackBar(
          context,
          e.message,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 110,
                      child: SvgPicture.asset(
                        Const.svgLogoPath,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      Const.appName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.otp,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${AppLocalizations.of(context)!.enterOtp} ',
                  children: [
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 30),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: primaryColor,
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
                      selectedColor: primaryColor,
                      selectedFillColor: primaryColor,
                      activeColor: primaryColor,
                      inactiveColor: Theme.of(context).colorScheme.secondary,
                      inactiveFillColor:
                          Theme.of(context).colorScheme.secondary,
                      activeFillColor: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    errorAnimationDuration: 25,
                    errorAnimationController: _errorController,
                    controller: _pinTextController,
                    keyboardType: TextInputType.number,
                    onCompleted: (value) {
                      _verifyCode();
                    },
                    //ignore: no-empty-block
                    onChanged: (value) {},
                    beforeTextPaste: null,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _pinTextController.clear();
                },
                child: Text(AppLocalizations.of(context)!.deleteAll),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.messageDidYouReceiveOTP,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _resendCode(),
                    child: Text(
                      AppLocalizations.of(context)!.resend,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
