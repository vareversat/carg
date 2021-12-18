import 'dart:developer' as developer;

import 'package:carg/helpers/custom_route.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/storage_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/widgets/register/register_email_widget.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = '/register';

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }

}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {

  final _store = StorageService(flutterSecureStorage: FlutterSecureStorage());
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  Future<void> _retrieveDynamicLink() async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;
    var isLogged =
    await Provider.of<AuthService>(context, listen: false).isAlreadyLogin();
    if (deepLink != null && !isLogged) {
      var link = deepLink.toString();
      var email = await _store.getEmail();
      developer.log('Logged : $isLogged', name: 'carg.dynamic-link');
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
      _retrieveDynamicLink();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 110,
                          child: SvgPicture.asset(
                              'assets/images/card_game.svg')),
                      SizedBox(height: 15),
                      Text(
                        'Carg',
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Connexion & Inscription',
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChangeNotifierProvider.value(
                    value: _RegisterData(_EmailRegisterMethod()),
                    child: Consumer<_RegisterData>(
                        builder: (context, registerData, _) =>
                            Column(
                              children: [
                                AnimatedSize(
                                    key: ValueKey('placeholderContainer'),
                                    curve: Curves.ease,
                                    duration: Duration(milliseconds: 500),
                                    child: registerData.selectedRegisterMethod
                                        .registrationWidget)
                                ,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: Text('ou', style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  height: 45,
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    key: ValueKey('emailButton'),
                                    icon: Icon(Icons.mail_outline),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all<
                                            Color>(
                                            registerData
                                                .selectedRegisterMethod is _EmailRegisterMethod
                                                ? Theme
                                                .of(context)
                                                .primaryColor
                                                : Theme
                                                .of(context)
                                                .cardColor),
                                        foregroundColor: MaterialStateProperty
                                            .all<
                                            Color>(
                                            registerData
                                                .selectedRegisterMethod is _EmailRegisterMethod
                                                ? Theme
                                                .of(context)
                                                .cardColor
                                                : Theme
                                                .of(context)
                                                .primaryColor),
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                            RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor),
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    CustomProperties
                                                        .borderRadius)))),
                                    onPressed: () {
                                      registerData.selectedRegisterMethod =
                                          _EmailRegisterMethod();
                                    },
                                    label: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Continuer avec une adresse email',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 45,
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    key: ValueKey('phoneButton'),
                                    icon: Icon(Icons.phone),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all<
                                            Color>(
                                            registerData
                                                .selectedRegisterMethod is _PhoneRegisterMethod
                                                ? Theme
                                                .of(context)
                                                .primaryColor
                                                : Theme
                                                .of(context)
                                                .cardColor),
                                        foregroundColor: MaterialStateProperty
                                            .all<
                                            Color>(
                                            registerData
                                                .selectedRegisterMethod is _PhoneRegisterMethod
                                                ? Theme
                                                .of(context)
                                                .cardColor
                                                : Theme
                                                .of(context)
                                                .primaryColor),
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                            RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor),
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    CustomProperties
                                                        .borderRadius)))),
                                    onPressed: () {
                                      registerData.selectedRegisterMethod =
                                          _PhoneRegisterMethod();
                                    },
                                    label: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Continuer avec un numéro de téléphone',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 45,
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    key: ValueKey('googleButton'),
                                    icon: FaIcon(
                                        FontAwesomeIcons.google, size: 22),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all<
                                            Color>(
                                            registerData
                                                .selectedRegisterMethod is _GoogleRegisterMethod
                                                ? Theme
                                                .of(context)
                                                .primaryColor
                                                : Theme
                                                .of(context)
                                                .cardColor),
                                        foregroundColor: MaterialStateProperty
                                            .all<
                                            Color>(
                                            registerData
                                                .selectedRegisterMethod is _GoogleRegisterMethod
                                                ? Theme
                                                .of(context)
                                                .cardColor
                                                : Theme
                                                .of(context)
                                                .primaryColor),
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                            RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2,
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor),
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    CustomProperties
                                                        .borderRadius)))),
                                    onPressed: () async {
                                      registerData.selectedRegisterMethod =
                                          _GoogleRegisterMethod();
                                      await Provider.of<AuthService>(
                                          context, listen: false)
                                          .googleLogIn();
                                      await Navigator.pushReplacement(
                                        context,
                                        CustomRouteFade(
                                          builder: (context) =>
                                              Provider.of<AuthService>(
                                                  context, listen: false)
                                                  .getCorrectLandingScreen(),
                                        ),
                                      );
                                    },
                                    label: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Continuer avec Google',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

abstract class RegisterMethod {
  Widget registrationWidget;

  RegisterMethod(this.registrationWidget);
}

class _PhoneRegisterMethod extends RegisterMethod {
  _PhoneRegisterMethod() : super(RegisterPhoneWidget(
      credentialVerificationType: CredentialVerificationType.CREATE));
}

class _EmailRegisterMethod extends RegisterMethod {
  _EmailRegisterMethod() : super(RegisterEmailWidget(
      credentialVerificationType: CredentialVerificationType.CREATE));
}

class _GoogleRegisterMethod extends RegisterMethod {
  _GoogleRegisterMethod() : super(Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Connexion à votre compte Google...',
          style: TextStyle(fontStyle: FontStyle.italic)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 3)),
      )
    ],
  ));
}


class _RegisterData with ChangeNotifier {

  RegisterMethod _selectedRegisterMethod;

  _RegisterData(this._selectedRegisterMethod);

  RegisterMethod get selectedRegisterMethod => _selectedRegisterMethod;

  set selectedRegisterMethod(RegisterMethod value) {
    _selectedRegisterMethod = value;
    notifyListeners();
  }
}
