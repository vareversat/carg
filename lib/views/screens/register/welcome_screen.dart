import 'package:carg/models/player.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';

  @override
  State<StatefulWidget> createState() {
    return _WelcomeScreenState();
  }
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  final _title = 'Bienvenue sur Carg !';
  final _description =
      'L\'application qui vous permet d\'enregistrer vos parties de Belote, Coinche, Contrée et Tarot !';
  final _createPlayerButton = 'Créer un nouveau joueur';
  final _linkPlayerButton = 'Lier un joueur existant à son compte';
  final _quitButton = 'Quitter';
  final _returnButton = 'Retour';
  final _createPlayerDescription =
      'Créer un nouveau joueur sans aucune parties associées';
  final _linkPlayerDescription =
      'Si vous avez un joueur sur le Carg de l\'un de vos amis, vous pouvez le lier à votre nouveau compte !';
  final _imagePath = 'assets/images/card_game.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(35),
                child: Container(
                  height: 150,
                  child: SvgPicture.asset(
                    _imagePath,
                  ),
                ),
              ),
              Text(
                _title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  _description,
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),
              ChangeNotifierProvider.value(
                  value: _AccountCreationData(_NoneMethod()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<_AccountCreationData>(
                        builder: (context, registerData, _) =>
                            Column(
                              children: [
                                AnimatedSize(
                                  curve: Curves.ease,
                                  vsync: this,
                                  duration: Duration(milliseconds: 500),
                                  child: registerData
                                      .selectedCreationMethod is _NoneMethod
                                      ? Column(children: [
                                    Container(
                                      child: ElevatedButton.icon(
                                          icon: Icon(Icons.add),
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty
                                                  .all<Color>(
                                                  Theme
                                                      .of(context)
                                                      .primaryColor),
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Theme
                                                      .of(context)
                                                      .cardColor),
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
                                            registerData
                                                .selectedCreationMethod =
                                                _CreatePlayerMethod(context);
                                          },
                                          label: Text(
                                            _createPlayerButton,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 40,
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _createPlayerDescription,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text('ou',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 20),
                                    Container(
                                      width: 250,
                                      height: 40,
                                      child: ElevatedButton.icon(
                                          icon: Icon(Icons.link),
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty
                                                  .all<Color>(
                                                  Theme
                                                      .of(context)
                                                      .primaryColor),
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Theme
                                                      .of(context)
                                                      .cardColor),
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
                                            registerData
                                                .selectedCreationMethod =
                                                _LinkPlayerMethod(context);
                                          },
                                          label: Flexible(
                                            child: Text(
                                              _linkPlayerButton,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      width: 300,
                                      child: Text(
                                        _linkPlayerDescription,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ])
                                      : registerData
                                      .selectedCreationMethod
                                      .accountCreationWidget,
                                ),
                                SizedBox(height: 30),
                                registerData
                                    .selectedCreationMethod is _NoneMethod
                                    ?
                                ElevatedButton.icon(
                                    icon: Icon(Icons.close),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all<Color>(
                                            Theme
                                                .of(context)
                                                .errorColor),
                                        foregroundColor: MaterialStateProperty
                                            .all<Color>(
                                            Theme
                                                .of(context)
                                                .cardColor),
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                            RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2, color: Theme
                                                    .of(context)
                                                    .errorColor),
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    CustomProperties
                                                        .borderRadius)))),
                                    onPressed: () async {
                                      await Provider.of<AuthService>(
                                          context, listen: false)
                                          .signOut(context);
                                    },
                                    label: Flexible(
                                      child: Text(
                                        _quitButton,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )) : ElevatedButton.icon(
                                    icon: Icon(Icons.arrow_back),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all<Color>(
                                            Theme
                                                .of(context)
                                                .accentColor),
                                        foregroundColor: MaterialStateProperty
                                            .all<Color>(
                                            Theme
                                                .of(context)
                                                .cardColor),
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                            RoundedRectangleBorder(
                                                side: BorderSide(
                                                    width: 2, color: Theme
                                                    .of(context)
                                                    .accentColor),
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    CustomProperties
                                                        .borderRadius)))),
                                    onPressed: () async {
                                      registerData
                                          .selectedCreationMethod =
                                          _NoneMethod();
                                    },
                                    label: Flexible(
                                      child: Text(
                                        _returnButton,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ],
                            )),
                  )),
            ]),
          ),
        ));
  }
}

abstract class _AccountCreationMethod {
  Widget accountCreationWidget;

  _AccountCreationMethod(this.accountCreationWidget);
}

class _NoneMethod extends _AccountCreationMethod {
  _NoneMethod() : super(Container());
}

class _CreatePlayerMethod extends _AccountCreationMethod {
  _CreatePlayerMethod(BuildContext context)
      : super(_EnterUsernameWidget(context));
}

class _LinkPlayerMethod extends _AccountCreationMethod {
  _LinkPlayerMethod(BuildContext context) : super(_LinkPlayerWidget(context));
}

class _AccountCreationData with ChangeNotifier {
  _AccountCreationMethod _selectedCreationMethod;

  _AccountCreationData(this._selectedCreationMethod);

  _AccountCreationMethod get selectedCreationMethod => _selectedCreationMethod;

  set selectedCreationMethod(_AccountCreationMethod value) {
    _selectedCreationMethod = value;
    notifyListeners();
  }
}

class _EnterUsernameWidget extends StatelessWidget {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final TextEditingController _usernameTextController = TextEditingController();
  final PlayerService _playerService = PlayerService();
  final BuildContext context;

  final _playerIsCreating = 'Création du joueur...';
  final _enterUserName = 'Saisissez votre nom d\'utilisateur';
  final _validate = 'Valider';

  _EnterUsernameWidget(this.context);

  Future<void> _createPlayer() async {
    Dialogs.showLoadingDialog(context, _keyLoader, _playerIsCreating);
    try {
      var userId = Provider.of<AuthService>(context, listen: false)
          .getConnectedUserId();
      var player = Player(
          userName: _usernameTextController.text, linkedUserId: userId);
      await _playerService.addPlayer(player);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(requestedIndex: 0),
        ),
      );
    } on CustomException catch (e) {
      _usernameTextController.clear();
      InfoSnackBar.showSnackBar(context, e.message);
    }
    Navigator.of(context, rootNavigator: true)
        .pop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          child: TextField(
            controller: _usernameTextController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: Theme
                    .of(context)
                    .primaryColor,
                fontWeight: FontWeight.normal,
              ),
              labelText: _enterUserName,
              fillColor: Theme
                  .of(context)
                  .primaryColor,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    CustomProperties.borderRadius),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    CustomProperties.borderRadius),
                borderSide: BorderSide(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    CustomProperties.borderRadius),
                borderSide: BorderSide(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10, height: 5),
        Flexible(child: ElevatedButton.icon(
            icon: Icon(Icons.check),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme
                        .of(context)
                        .primaryColor),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme
                        .of(context)
                        .cardColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        side: BorderSide(
                            width: 2, color: Theme
                            .of(context)
                            .primaryColor),
                        borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius)))),
            onPressed: () async {
              await _createPlayer();
            },
            label: Flexible(
              child: Text(
                _validate,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )),)
      ],
    );
  }
}

class _LinkPlayerWidget extends StatelessWidget {
  final BuildContext context;
  final PlayerService _playerService = PlayerService();
  final TextEditingController _idTextController = TextEditingController();

  final _enterUniqueId = 'Saisissez l\'identifiant unique';
  final _enterUniqueIdDescription = 'L\'identifiant unique peut être retrouvé sur la liste des joueurs du Carg où vous avez déjà enregistré votre joueur';
  final _validate = 'Valider';

  _LinkPlayerWidget(this.context);

  Future<void> _linkPlayer() async {
    try {
      var userId = Provider.of<AuthService>(context, listen: false)
          .getConnectedUserId();
      var player = await _playerService.getPlayer(_idTextController.text);
      print(player);
      if (player.ownedBy == '' || player.linkedUserId != '') {
        throw CustomException('Impossible d\'associer cet utilisateur');
      }
      player.linkedUserId = userId;
      player.ownedBy = '';
      await _playerService.updatePlayer(player);
      Provider.of<AuthService>(context, listen: false)
          .setCurrentPlayer(player);
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(requestedIndex: 0),
        ),
      );
    } on CustomException catch (e) {
      InfoSnackBar.showSnackBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: TextField(
                controller: _idTextController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontWeight: FontWeight.normal,
                  ),
                  labelText: _enterUniqueId,
                  fillColor: Theme
                      .of(context)
                      .primaryColor,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        CustomProperties.borderRadius),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        CustomProperties.borderRadius),
                    borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        CustomProperties.borderRadius),
                    borderSide: BorderSide(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10, height: 5),
            Flexible(child: ElevatedButton.icon(
                icon: Icon(Icons.check),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme
                            .of(context)
                            .primaryColor),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme
                            .of(context)
                            .cardColor),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            side: BorderSide(
                                width: 2, color: Theme
                                .of(context)
                                .primaryColor),
                            borderRadius: BorderRadius.circular(
                                CustomProperties.borderRadius)))),
                onPressed: () async {
                  await _linkPlayer();
                },
                label: Flexible(
                  child: Text(
                    _validate,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),)
          ],
        ),
        SizedBox(height: 8),
        Text(
          _enterUniqueIdDescription,
          style: TextStyle(
              fontStyle: FontStyle.italic, fontSize: 13),
        ),
      ],
    );
  }
}

