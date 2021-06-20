import 'package:carg/services/auth_service.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/signing_options_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  final _emailRegex =
      RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
  final Map<String, String?> _authData = {
    'email': '',
    'password': '',
    'username': ''
  };
  var _isLoginLoading = false;
  var _isLocalLoginLoading = false;

  Future<void> _localLogin() async {
    setState(() {
      _isLocalLoginLoading = true;
    });
    try {
      await Provider.of<AuthService>(context, listen: false).localLogIn();
      await Navigator.of(context)
          .pushReplacementNamed(HomeScreen.routeName, arguments: 0);
    } on CustomException catch (e) {
      setState(() {
        _isLocalLoginLoading = false;
      });
      await showDialog(
          context: context,
          builder: (BuildContext context) => WarningDialog(
              message: e.toString(),
              title: 'Erreur',
              onConfirm: () => {},
              onConfirmButtonMessage: 'Fermer',
              showCancelButton: false));
    }
    if (mounted) {
      setState(() {
        _isLocalLoginLoading = false;
      });
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    await showDialog(
        context: context,
        builder: (BuildContext context) => WarningDialog(
            message:
                'Un email vous permettant de réinitialiser votre mot de passe va vous être envoyé',
            title: 'Information',
            onConfirm: () async =>
                await Provider.of<AuthService>(context, listen: false)
                    .resetPassword(_authData['email']),
            color: Theme.of(context).primaryColor,
            onConfirmButtonMessage: 'Confirmer'));
  }

  Future<void> _mailLogin() async {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoginLoading = true;
    });
    try {
      await Provider.of<AuthService>(context, listen: false)
          .mailLogIn(_authData['email']!, _authData['password']!);
      await Navigator.pushReplacementNamed(context, HomeScreen.routeName,
          arguments: 0);
    } on CustomException catch (e) {
      setState(() {
        _isLoginLoading = false;
      });
      await showDialog(
          context: context,
          builder: (BuildContext context) => WarningDialog(
              message: e.toString(),
              title: 'Erreur',
              onConfirm: () => {},
              onConfirmButtonMessage: 'Fermer',
              showCancelButton: false));
    }
    if (mounted) {
      setState(() {
        _isLoginLoading = false;
      });
    }
  }

  Future<void> _googleLogin() async {
    setState(() {
      _isLoginLoading = true;
    });
    try {
      await Provider.of<AuthService>(context, listen: false).googleLogIn();
      await Navigator.pushReplacementNamed(context, HomeScreen.routeName,
          arguments: 0);
    } on CustomException catch (e) {
      setState(() {
        _isLoginLoading = false;
      });
      await showDialog(
          context: context,
          builder: (BuildContext context) => WarningDialog(
              message: e.toString(),
              title: 'Erreur',
              onConfirm: () => {},
              onConfirmButtonMessage: 'Fermer',
              showCancelButton: false));
    }
    if (mounted) {
      setState(() {
        _isLoginLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 80,
                              child: SvgPicture.asset(
                                  'assets/images/card_game.svg')),
                          Text(
                            'Carg',
                            style: TextStyle(
                              color: Theme.of(context).cardColor,
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(1),
                                  offset: Offset(1, 1),
                                  blurRadius: 50,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                            child: Column(children: <Widget>[
                          TextFormField(
                            cursorColor: Colors.white,
                            autofillHints: [AutofillHints.email],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            onFieldSubmitted: (term) => _mailLogin(),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                              labelText: 'Adresse mail',
                              fillColor: Colors.white,
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            // ignore: missing_return
                            validator: (value) {
                              if (!_emailRegex.hasMatch(value!)) {
                                return 'Adresse email invalide';
                              }
                            },
                            onSaved: (value) {
                              _authData['email'] = value;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            cursorColor: Colors.white,
                            autofillHints: [AutofillHints.password],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            onFieldSubmitted: (term) => _mailLogin(),
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                              labelText: 'Mot de passe',
                              fillColor: Colors.white,
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            obscureText: true,
                            controller: _passwordController,
                            onSaved: (value) {
                              _authData['password'] = value;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (_isLoginLoading)
                            SpinKitThreeBounce(
                                size: 20,
                                itemBuilder: (BuildContext context, int index) {
                                  return DecoratedBox(
                                      decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                  ));
                                })
                          else
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color?>(
                                              Theme.of(context).primaryColor),
                                      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              CustomProperties.borderRadius))),
                                      padding:
                                          MaterialStateProperty.all<EdgeInsetsGeometry>(
                                              EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0))),
                                  icon: FaIcon(FontAwesomeIcons.signInAlt,
                                      size: 30),
                                  label: Text(
                                    'Se connecter',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  onPressed: _mailLogin,
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: _resetPassword,
                              child: Text('Mot de passe oublié',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white))),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color?>(
                                          Theme.of(context).primaryColor),
                                  shape: MaterialStateProperty.all<OutlinedBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              CustomProperties.borderRadius))),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsetsGeometry>(
                                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0))),
                              onPressed: _googleLogin,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      height: 30,
                                      child: SvgPicture.asset(
                                          'assets/images/google_logo.svg')),
                                  Text(
                                    'Se connecter avec Google',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 30,
                            thickness: 2,
                            color: Colors.white,
                          ),
                          if (_isLocalLoginLoading)
                            SpinKitThreeBounce(
                                size: 20,
                                itemBuilder: (BuildContext context, int index) {
                                  return DecoratedBox(
                                      decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                  ));
                                })
                          else
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color?>(
                                              Theme.of(context).primaryColor),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              CustomProperties.borderRadius))),
                                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 6))),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SigningOptionsScreen())),
                                  child: Text(
                                    'Utiliser un compte local',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                        ]))),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
