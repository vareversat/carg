import 'dart:developer' as developer;

import 'package:carg/exceptions/custom_exception.dart';
import 'package:carg/helpers/custom_route.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/storage_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class RegisterEmailWidget extends StatefulWidget {
  final CredentialVerificationType credentialVerificationType;
  final FirebaseDynamicLinks linkProvider;

  const RegisterEmailWidget(
      {Key? key,
      required this.credentialVerificationType,
      required this.linkProvider})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterEmailWidgetState();
  }
}

class _RegisterEmailWidgetState extends State<RegisterEmailWidget>
    with WidgetsBindingObserver {
  bool _emailSending = false;

  final _store =
      StorageService(flutterSecureStorage: const FlutterSecureStorage());
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  Future<dynamic> _signInWithEmailAndLink(String email) async {
    await _store.setEmail(email);
    try {
      setState(() {
        _emailSending = true;
      });
      if (widget.credentialVerificationType ==
          CredentialVerificationType.CREATE) {
        await Provider.of<AuthService>(context, listen: false)
            .sendSignInWithEmailLink(email);
        InfoSnackBar.showSnackBar(
            context, AppLocalizations.of(context)!.emailSent);
      } else {
        await Provider.of<AuthService>(context, listen: false)
            .changeEmail(email);
        Dialogs.showMessageDialog(context, _keyLoader,
            AppLocalizations.of(context)!.emailSentAndSignOut);
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        await Provider.of<AuthService>(context, listen: false).signOut(context);
      }
    } on CustomException catch (e) {
      InfoSnackBar.showSnackBar(context, e.message);
      setState(() {
        _emailSending = false;
      });
    } finally {
      setState(() {
        _emailSending = false;
      });
    }
  }

  Future<void> _retrieveDynamicLink() async {
    final data = await widget.linkProvider.getInitialLink();
    final deepLink = data?.link;
    var isLogged =
        await Provider.of<AuthService>(context, listen: false).isAlreadyLogin();
    developer.log('Logged : $isLogged', name: 'carg.dynamic-link');
    if (deepLink != null && !isLogged) {
      var link = deepLink.toString();
      var email = await _store.getEmail();
      developer.log('Link : $link', name: 'carg.dynamic-link');
      developer.log('Email : $email', name: 'carg.dynamic-link');
      try {
        await Provider.of<AuthService>(context, listen: false)
            .signInWithEmailLink(email!, link);
        developer.log('Sing in : OK', name: 'carg.dynamic-link');
        Dialogs.showLoadingDialog(context, _keyLoader, 'Connexion');
        await Navigator.pushReplacement(
          context,
          CustomRouteFade(
            builder: (context) =>
                Provider.of<AuthService>(context, listen: false)
                    .getCorrectLandingScreen(),
          ),
        );
      } on CustomException catch (e) {
        developer.log(e.message, name: 'carg.dynamic-link');
        InfoSnackBar.showSnackBar(context, e.message);
      } finally {
        if (_keyLoader.currentContext != null) {
          Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      developer.log('Call from didChangeAppLifecycleState',
          name: 'carg.dynamic-link');
      _retrieveDynamicLink();
    }
  }

  @override
  void initState() {
    super.initState();
    developer.log('Call from initState', name: 'carg.dynamic-link');
    WidgetsBinding.instance.addObserver(this);
    _retrieveDynamicLink();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              AnimatedSize(
                  key: const ValueKey('placeholderPhoneContainer'),
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 200),
                  child: _emailSending
                      ? const Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: CircularProgressIndicator(strokeWidth: 5),
                        )
                      : const SizedBox(width: 0)),
              Flexible(
                child: TextField(
                  textInputAction: TextInputAction.go,
                  autofillHints: const [AutofillHints.email],
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      await _signInWithEmailAndLink(value);
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.normal,
                    ),
                    fillColor: Theme.of(context).primaryColor,
                    disabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(CustomProperties.borderRadius),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(CustomProperties.borderRadius),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(CustomProperties.borderRadius),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          widget.credentialVerificationType == CredentialVerificationType.CREATE
              ? Text(
                  AppLocalizations.of(context)!.emailSentWithLink,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                )
              : const SizedBox(
                  height: 10,
                )
        ],
      ),
    );
  }
}
