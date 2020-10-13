import 'package:carg/services/auth_service.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.Login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'username': ''
  };
  var _isLoginLoading = false;
  var _isLocalLoginLoading = false;
  AnimationController _animationController;
  Animation<double> _opacityAnimation;

  Future<void> _localLogin() async {
    setState(() {
      _isLocalLoginLoading = true;
    });
    try {
      await Provider.of<AuthService>(context, listen: false).localLoginIn();
      await Navigator.of(context).pushReplacementNamed(HomeScreen.routeName, arguments: 0);
    } on CustomException catch (e) {
      setState(() {
        _isLocalLoginLoading = false;
      });
      await showDialog(
          context: context,
          child: WarningDialog(
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
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    await showDialog(
        context: context,
        child: WarningDialog(
            message:
                'Un email vous permettant de réinitialiser votre mot de passe va vous être envoyé',
            title: 'Information',
            onConfirm: () async =>
                await Provider.of<AuthService>(context, listen: false)
                    .resetPassword(_authData['email']),
            color: Theme.of(context).primaryColor,
            onConfirmButtonMessage: 'Confirmer'));
  }

  Future<void> _submit() async {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoginLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<AuthService>(context, listen: false)
            .firebaseLoginIn(_authData['email'], _authData['password']);
        await Navigator.of(context).pushReplacementNamed(HomeScreen.routeName, arguments: 0);
      } else {
        await Provider.of<AuthService>(context, listen: false).signUp(
            _authData['email'], _authData['password'], _authData['username']);
        setState(() {
          _isLoginLoading = false;
        });
        await showDialog(
            context: context,
            child: WarningDialog(
                message:
                    'Compte créé avec succès. Un email de confirmation vous a été envoyé',
                title: 'Information',
                onConfirm: () => {},
                color: Theme.of(context).primaryColor,
                onConfirmButtonMessage: 'Valider',
                showCancelButton: false));
      }
    } on CustomException catch (e) {
      setState(() {
        _isLoginLoading = false;
      });
      await showDialog(
          context: context,
          child: WarningDialog(
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

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.9),
                  Theme.of(context).accentColor.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
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
                    padding: const EdgeInsets.all(8.0),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 8.0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        height: _authMode == AuthMode.Signup ? 420 : 300,
                        width: deviceSize.width * 0.75,
                        constraints: BoxConstraints(
                            minHeight:
                                _authMode == AuthMode.Signup ? 420 : 200),
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  autofillHints: [AutofillHints.email],
                                  onFieldSubmitted: (term) => _submit(),
                                  decoration: InputDecoration(
                                    labelText: 'Adresse mail',
                                    prefixIcon:
                                        Icon(FontAwesomeIcons.at, size: 20),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  // ignore: missing_return
                                  validator: (value) {
                                    if (value.isEmpty || !value.contains('@')) {
                                      return 'Email invalide';
                                    }
                                  },
                                  onSaved: (value) {
                                    _authData['email'] = value;
                                  },
                                ),
                                if (_authMode == AuthMode.Signup)
                                  FadeTransition(
                                    opacity: _opacityAnimation,
                                    child: TextFormField(
                                      autofillHints: [
                                        AutofillHints.newUsername
                                      ],
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      enabled: _authMode == AuthMode.Signup,
                                      decoration: InputDecoration(
                                        labelText: 'Nom d\'utilisateur',
                                        prefixIcon: Icon(
                                            FontAwesomeIcons.userCircle,
                                            size: 20),
                                      ),
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Nom d`\'utilisateur non renseigné';
                                        }
                                      },
                                      onSaved: (value) {
                                        _authData['username'] = value;
                                      },
                                    ),
                                  ),
                                TextFormField(
                                  autofillHints: [AutofillHints.password],
                                  onFieldSubmitted: (term) => _submit(),
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    labelText: 'Mot de passe',
                                    prefixIcon:
                                        Icon(FontAwesomeIcons.lock, size: 20),
                                  ),
                                  obscureText: true,
                                  controller: _passwordController,
                                  onSaved: (value) {
                                    _authData['password'] = value;
                                  },
                                ),
                                if (_authMode == AuthMode.Signup)
                                  FadeTransition(
                                    opacity: _opacityAnimation,
                                    child: TextFormField(
                                      enabled: _authMode == AuthMode.Signup,
                                      autofillHints: [AutofillHints.password],
                                      decoration: InputDecoration(
                                        labelText: 'Confirmer le mot de passe',
                                        prefixIcon: Icon(FontAwesomeIcons.lock,
                                            size: 20),
                                      ),
                                      obscureText: true,
                                      validator: _authMode == AuthMode.Signup
                                          // ignore: missing_return
                                          ? (value) {
                                              if (value !=
                                                  _passwordController.text) {
                                                return 'Le mot de passe ne correspond pas';
                                              }
                                            }
                                          : null,
                                    ),
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
                                  RaisedButton.icon(
                                    icon: _authMode == AuthMode.Login
                                        ? FaIcon(FontAwesomeIcons.signInAlt,
                                            size: 15)
                                        : FaIcon(FontAwesomeIcons.userPlus,
                                            size: 15),
                                    label: Text(_authMode == AuthMode.Login
                                        ? 'Connexion'
                                        : 'Créer un compte'),
                                    onPressed: _submit,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 6.0),
                                    color: Theme.of(context).primaryColor,
                                    textColor: Theme.of(context)
                                        .primaryTextTheme
                                        .button
                                        .color,
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                FlatButton.icon(
                                  icon: _authMode == AuthMode.Login
                                      ? FaIcon(FontAwesomeIcons.userPlus,
                                          size: 15)
                                      : FaIcon(FontAwesomeIcons.signInAlt,
                                          size: 15),
                                  label: Text(
                                      '${_authMode == AuthMode.Login ? 'Créer un compte' : 'Connexion'}'),
                                  onPressed: _switchAuthMode,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 4),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  textColor: Theme.of(context).primaryColor,
                                ),
                                FlatButton(
                                  child: Text('Mot de passe oublié',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.underline)),
                                  onPressed: _resetPassword,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 4),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  if (_isLocalLoginLoading)
                    CircularProgressIndicator()
                  else
                    RaisedButton.icon(
                      icon: FaIcon(FontAwesomeIcons.signInAlt, size: 15),
                      label: Text('Utiliser un compte local'),
                      onPressed: _localLogin,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
