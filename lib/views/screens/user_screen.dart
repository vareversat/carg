import 'package:carg/models/player/player.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user';

  @override
  State<StatefulWidget> createState() {
    return _UserScreenState();
  }
}

class _UserScreenState extends State<UserScreen> {
  String _errorMessage = 'Vous ne disposez pas de joueur';

  final _pseudoTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _profilePictureTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _playerService = PlayerService();
  final GlobalKey<FormState> _formKey = GlobalKey();
  Player _player;

  void _getInitialValues() {
    if (_player != null) {
      _pseudoTextController.text = _player.userName;
      _profilePictureTextController.text = _player.profilePicture;
      _emailTextController.text =
          Provider.of<AuthService>(context, listen: false)
              .getConnectedUserEmail();
    }
  }

  Future<void> _updatePlayer() async {
    await _playerService.updatePlayer(_player);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Joueur mis à jour',
          style: (TextStyle(fontWeight: FontWeight.bold))),
    ));
  }

  Future<void> _signOut() async {
    try {
      if (await Provider.of<AuthService>(context, listen: false)
          .isLocalLogin()) {
        await showDialog(
            context: context,
            child: WarningDialog(
                message:
                    'Vous utilisez actuellement un compte local. Si vous vous déconnecter, vous ne pourrez pas récupérer l\'utilisateur actuel',
                title: 'Attention',
                onConfirm: () async => {
                      await Provider.of<AuthService>(context, listen: false)
                          .signOut(),
                      await Navigator.of(context).pushReplacementNamed('/login')
                    },
                color: Theme.of(context).errorColor,
                onConfirmButtonMessage: 'Confirmer'));
      } else {
        await Provider.of<AuthService>(context, listen: false).signOut();
        await Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  Future<void> _switchToRealAccount() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final _keyLoader = GlobalKey<State>();
    // ignore: unawaited_futures
    Dialogs.showLoadingDialog(context, _keyLoader, 'Création du compte');
    await Provider.of<AuthService>(context, listen: false)
        .linkAnonymousToCredentials(
            _emailTextController.text, _passwordTextController.text)
        .catchError((error) async => {
              await showDialog(
                  context: context,
                  child: WarningDialog(
                      showCancelButton: false,
                      message: error.toString(),
                      title: 'Erreur',
                      onConfirm: () {},
                      color: Theme.of(context).errorColor,
                      onConfirmButtonMessage: 'Fermer')),
              Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop()
            });
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  Future<void> _resetPassword() async {
    await showDialog(
        context: context,
        child: WarningDialog(
            message:
                'Un email vous permettant de réinitialiser votre mot de passe va vous être envoyé',
            title: 'Information',
            onConfirm: () async =>
                await Provider.of<AuthService>(context, listen: false)
                    .resetPassword(null),
            color: Theme.of(context).primaryColor,
            onConfirmButtonMessage: 'Confirmer'));
  }

  Future<void> _changePassword() async {
    var _isAcceptedTransaction = true;
    if (!_formKey.currentState.validate()) {
      return;
    }
    await showDialog(
        context: context,
        child: WarningDialog(
            message:
                'Vous vous apprêtez à changer d\'adresse mail. Un email de confirmation va vous être envoyé. Après confirmation, vous serez déconnectez automatiquement',
            title: 'Information',
            onConfirm: () async =>
                await Provider.of<AuthService>(context, listen: false)
                    .changeEmail(
                        _emailTextController.text, _passwordTextController.text)
                    .catchError((error) async => {
                          _isAcceptedTransaction = false,
                          await showDialog(
                              context: context,
                              child: WarningDialog(
                                  showCancelButton: false,
                                  message: error.toString(),
                                  title: 'Erreur',
                                  onConfirm: () {},
                                  color: Theme.of(context).errorColor,
                                  onConfirmButtonMessage: 'Fermer'))
                        }),
            color: Theme.of(context).primaryColor,
            onConfirmButtonMessage: 'Confirmer'));
    if (_isAcceptedTransaction) {
      await Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _pseudoTextController.dispose();
    _profilePictureTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Future<String> _getVersionNumber() async {
    var packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version + '+' + packageInfo.buildNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bienvenue', style: Theme.of(context).textTheme.headline1),
                RaisedButton.icon(
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    onPressed: () async => showAboutDialog(
                      applicationIcon: Container(
                          height: 60,
                          width: 60,
                          child: SvgPicture.asset(
                              'assets/images/card_game.svg')),
                        context: context,
                        applicationVersion: await _getVersionNumber(),
                        children: [
                          Divider(height: 25,),
                          RichText(
                            text: TextSpan(
                              text: 'L\'application pour enregistrer vos parties de Belote, Coinche et Tarot ! \n\n',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(text: 'Code source disponible ici : '),
                                TextSpan(
                                  text: 'https://github.com/Devosud/carg',
                                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final url =
                                          'https://github.com/Devosud/carg';
                                      if (await canLaunch(url)) {
                                        await launch(
                                          url,
                                          forceSafariVC: false,
                                        );
                                      }
                                    },
                                ),
                              ],
                            ),
                          )
                        ],
                        applicationLegalese: '© 2020 - Devosud'),
                    label: Text('À propos', style: TextStyle(fontSize: 14)),
                    icon: Icon(
                      FontAwesomeIcons.info,
                      size: 10,
                    ))
              ],
            ),
          ),
        ),
        body: FutureBuilder<Player>(
            future: _playerService
                .getPlayerOfUser(
                    Provider.of<AuthService>(context, listen: false)
                        .getConnectedConnectedId())
                .catchError((onError) => {_errorMessage = onError.toString()}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.none &&
                      snapshot.hasData == null ||
                  snapshot.data == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ErrorMessageWidget(message: _errorMessage),
                    RaisedButton.icon(
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        onPressed: () async => _signOut(),
                        label:
                            Text('Connexion', style: TextStyle(fontSize: 14)),
                        icon: Icon(Icons.arrow_back)),
                  ],
                );
              }
              if (snapshot.data == null) {
                return Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Pas encore de joueur',
                            style: TextStyle(fontSize: 18))
                      ]),
                );
              }
              _player = snapshot.data;
              _getInitialValues();
              return ChangeNotifierProvider(
                create: (BuildContext context) => _player,
                child: Consumer<Player>(
                  builder: (context, player, _) => SingleChildScrollView(
                    child: (Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.stars, size: 25),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    _player.wonGames.toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Text('Victoires',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic)),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 4,
                                          color:
                                              Theme.of(context).primaryColor),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              player.profilePicture)))),
                            ),
                            Column(
                              children: [
                                Icon(Icons.gamepad, size: 25),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    _player.playedGames.toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Text('Parties',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic)),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Center(
                                child: TextFormField(
                                    onChanged: (text) =>
                                        _player.userName = text,
                                    controller: _pseudoTextController,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      labelText: 'Pseudo',
                                      suffixIcon: Icon(
                                          FontAwesomeIcons.userCircle,
                                          size: 30),
                                    )),
                              ),
                              Center(
                                child: TextFormField(
                                  maxLines: 3,
                                  onChanged: (text) =>
                                      _player.profilePicture = text,
                                  controller: _profilePictureTextController,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    labelText: 'Image de profile (url)',
                                    suffixIcon:
                                        Icon(FontAwesomeIcons.image, size: 30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        RaisedButton.icon(
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            onPressed: () async => _updatePlayer(),
                            label: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text('Mettre à jour mes infos',
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .fontSize)),
                            ),
                            icon: Icon(
                              FontAwesomeIcons.pen,
                              size: 15,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Center(
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: _emailTextController,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                          decoration: InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            labelText: 'Adresse email',
                                            suffixIcon: Icon(
                                                FontAwesomeIcons.at,
                                                size: 30),
                                          ),
                                          // ignore: missing_return
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                !value.contains('@') ||
                                                value ==
                                                    Provider.of<AuthService>(
                                                            context,
                                                            listen: false)
                                                        .getConnectedUserEmail()) {
                                              return 'Email invalide ou inchangé';
                                            }
                                          },
                                        ),
                                      ),
                                      Center(
                                        child: TextFormField(
                                          obscureText: true,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          controller: _passwordTextController,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                          decoration: InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            labelText: 'Mot de passe',
                                            suffixIcon: Icon(
                                                FontAwesomeIcons.lock,
                                                size: 30),
                                          ),
                                          // ignore: missing_return
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Mot de passe non renseigné';
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              FutureBuilder<bool>(
                                  future: Provider.of<AuthService>(context,
                                          listen: true)
                                      .isLocalLogin(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.data != null) {
                                      if (snapshot.data) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton.icon(
                                              color:
                                                  Theme.of(context).accentColor,
                                              textColor:
                                                  Theme.of(context).cardColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0)),
                                              onPressed: () async =>
                                                  _switchToRealAccount(),
                                              label: Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Text('Créer un compte',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .fontSize)),
                                                ),
                                              ),
                                              icon: FaIcon(
                                                  FontAwesomeIcons.userPlus,
                                                  size: 15)),
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RaisedButton.icon(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  textColor: Theme.of(context)
                                                      .cardColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0)),
                                                  onPressed: () async =>
                                                      await _changePassword(),
                                                  label: Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Text(
                                                          'Changer mon adresse email',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .fontSize)),
                                                    ),
                                                  ),
                                                  icon: Icon(
                                                    FontAwesomeIcons.at,
                                                    size: 20,
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RaisedButton.icon(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  textColor: Theme.of(context)
                                                      .cardColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0)),
                                                  onPressed: () async =>
                                                      _resetPassword(),
                                                  label: Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Text(
                                                          'Changer mon mot de passe',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1
                                                                  .fontSize)),
                                                    ),
                                                  ),
                                                  icon: Icon(
                                                    FontAwesomeIcons.lock,
                                                    size: 20,
                                                  )),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                    return Container();
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton.icon(
                                    color: Theme.of(context).errorColor,
                                    textColor: Theme.of(context).cardColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
                                    onPressed: () async => _signOut(),
                                    label: Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text('Déconnexion',
                                            style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .fontSize)),
                                      ),
                                    ),
                                    icon: Icon(
                                      FontAwesomeIcons.signOutAlt,
                                      size: 20,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              );
            }));
  }
}
