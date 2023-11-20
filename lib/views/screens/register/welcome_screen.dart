import 'package:carg/const.dart';
import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/styles/custom_properties.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';

  const WelcomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WelcomeScreenState();
  }
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final foregroundColor = MaterialStateProperty.all<Color>(
      Theme.of(context).cardColor,
    );
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(35),
                child: SizedBox(
                  height: 150,
                  child: SvgPicture.asset(
                    Const.svgLogoPath,
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context)!.welcomeMessage(Const.appName),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.messageWelcomeDescription,
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              ChangeNotifierProvider.value(
                value: _AccountCreationData(_NoneMethod()),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<_AccountCreationData>(
                    builder: (context, registerData, _) => Column(
                      children: [
                        AnimatedSize(
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 500),
                          child: registerData.selectedCreationMethod
                                  is _NoneMethod
                              ? Column(
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.add),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor,
                                        ),
                                        foregroundColor: foregroundColor,
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                          RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              CustomProperties.borderRadius,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        registerData.selectedCreationMethod =
                                            _CreatePlayerMethod(context);
                                      },
                                      label: Text(
                                        AppLocalizations.of(context)!
                                            .createNewPlayer,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      height: 40,
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .messageCreatePlayer,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      AppLocalizations.of(context)!.or,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: 250,
                                      height: 40,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.link),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor,
                                          ),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Theme.of(context).cardColor,
                                          ),
                                          shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                CustomProperties.borderRadius,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          registerData.selectedCreationMethod =
                                              _LinkPlayerMethod(context);
                                        },
                                        label: Text(
                                          AppLocalizations.of(context)!
                                              .linkPlayer,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      width: 300,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .messageLinkPlayer,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                )
                              : registerData
                                  .selectedCreationMethod.accountCreationWidget,
                        ),
                        const SizedBox(height: 30),
                        registerData.selectedCreationMethod is _NoneMethod
                            ? ElevatedButton.icon(
                                icon: const Icon(Icons.close),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    colorScheme.error,
                                  ),
                                  foregroundColor: foregroundColor,
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 2,
                                        color: colorScheme.error,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        CustomProperties.borderRadius,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Provider.of<AuthService>(
                                    context,
                                    listen: false,
                                  ).signOut(context);
                                },
                                label: Text(
                                  AppLocalizations.of(context)!.leave,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : ElevatedButton.icon(
                                icon: const Icon(Icons.arrow_back),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    colorScheme.secondary,
                                  ),
                                  foregroundColor: foregroundColor,
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 2,
                                        color: colorScheme.secondary,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        CustomProperties.borderRadius,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  registerData.selectedCreationMethod =
                                      _NoneMethod();
                                },
                                label: Text(
                                  AppLocalizations.of(context)!.back,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  _EnterUsernameWidget(this.context);

  Future<void> _createPlayer() async {
    Dialogs.showLoadingDialog(
      context,
      _keyLoader,
      '${AppLocalizations.of(context)!.messagePlayerCreation}...',
    );
    var userId =
        Provider.of<AuthService>(context, listen: false).getConnectedUserId();
    var player = Player(
      userName: _usernameTextController.text,
      linkedUserId: userId,
      owned: false,
    );
    await _playerService
        .create(player)
        .then((value) => {
              Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                  .pop(),
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(
                    requestedIndex: 0,
                  ),
                ),
              ),
            })
        .onError<ServiceException>((error, stackTrace) => {
              _usernameTextController.clear(),
              InfoSnackBar.showSnackBar(context, error.message),
            })
        .whenComplete(
          () => Navigator.of(context, rootNavigator: true).pop(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: TextField(
            controller: _usernameTextController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.normal,
              ),
              labelText: AppLocalizations.of(context)!.messageEnterUsername,
              fillColor: primaryColor,
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
                  color: primaryColor,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(CustomProperties.borderRadius),
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10, height: 5),
        ElevatedButton.icon(
          icon: const Icon(Icons.check),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              primaryColor,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).cardColor,
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                side: BorderSide(
                  width: 2,
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
              ),
            ),
          ),
          onPressed: () {
            _createPlayer();
          },
          label: Text(
            AppLocalizations.of(context)!.validate,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _LinkPlayerWidget extends StatelessWidget {
  final BuildContext context;
  final PlayerService _playerService = PlayerService();
  final TextEditingController _idTextController = TextEditingController();

  _LinkPlayerWidget(this.context);

  Future<void> _linkPlayer() async {
    FocusManager.instance.primaryFocus?.unfocus();

    var userId =
        Provider.of<AuthService>(context, listen: false).getConnectedUserId();

    await _playerService.get(_idTextController.text).then(
          (player) async => {
            if (player != null)
              if (!player.owned)
                {
                  InfoSnackBar.showErrorSnackBar(
                    context,
                    AppLocalizations.of(context)!.errorPlayerAlreadyLinked,
                  ),
                }
              else
                {
                  player.linkedUserId = userId,
                  player.ownedBy = '',
                  player.owned = false,
                  await _playerService
                      .update(player)
                      .then((value) => {
                            Provider.of<AuthService>(context, listen: false)
                                .setCurrentPlayer(
                              player,
                            ),
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(
                                  requestedIndex: 0,
                                ),
                              ),
                            ),
                          })
                      .catchError(
                        (err) => {
                          InfoSnackBar.showErrorSnackBar(context, err.message),
                        },
                      ),
                },
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: TextField(
                controller: _idTextController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.normal,
                  ),
                  labelText: AppLocalizations.of(context)!.messageEnterUniqueId,
                  fillColor: primaryColor,
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
                      color: primaryColor,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(CustomProperties.borderRadius),
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10, height: 5),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  primaryColor,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).cardColor,
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(
                      CustomProperties.borderRadius,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                _linkPlayer();
              },
              label: Text(
                AppLocalizations.of(context)!.validate,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.messageFindUniqueId,
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
        ),
      ],
    );
  }
}
