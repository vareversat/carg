import 'package:carg/const.dart';
import 'package:carg/exceptions/custom_exception.dart';
import 'package:carg/exceptions/service_exception.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(35),
                child: SizedBox(
                  height: 150,
                  child: SvgPicture.asset(Const.svgLogoPath),
                ),
              ),
              Text(
                AppLocalizations.of(context)!.welcomeMessage(Const.appName),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
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
                          child:
                              registerData.selectedCreationMethod is _NoneMethod
                              ? Column(
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.add),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                        foregroundColor:
                                            WidgetStateProperty.all<Color>(
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                            ),
                                        shape:
                                            WidgetStateProperty.all<
                                              OutlinedBorder
                                            >(
                                              RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 2,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      CustomProperties
                                                          .borderRadius,
                                                    ),
                                              ),
                                            ),
                                      ),
                                      onPressed: () {
                                        registerData.selectedCreationMethod =
                                            _CreatePlayerMethod(context);
                                      },
                                      label: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.createNewPlayer,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.messageCreatePlayer,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      AppLocalizations.of(context)!.or,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.link),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                        foregroundColor:
                                            WidgetStateProperty.all<Color>(
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                            ),
                                        shape:
                                            WidgetStateProperty.all<
                                              OutlinedBorder
                                            >(
                                              RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 2,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      CustomProperties
                                                          .borderRadius,
                                                    ),
                                              ),
                                            ),
                                      ),
                                      onPressed: () {
                                        registerData.selectedCreationMethod =
                                            _LinkPlayerMethod(context);
                                      },
                                      label: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.linkPlayer,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.messageLinkPlayer,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              : registerData
                                    .selectedCreationMethod
                                    .accountCreationWidget,
                        ),
                        const SizedBox(height: 30),
                        registerData.selectedCreationMethod is _NoneMethod
                            ? ElevatedButton.icon(
                                icon: const Icon(Icons.close),
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                        Theme.of(context).colorScheme.error,
                                      ),
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                        Theme.of(context).colorScheme.onError,
                                      ),
                                  shape:
                                      WidgetStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 2,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onError,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            CustomProperties.borderRadius,
                                          ),
                                        ),
                                      ),
                                ),
                                onPressed: () async {
                                  await Provider.of<AuthService>(
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
                                      WidgetStateProperty.all<Color>(
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                      ),
                                  shape:
                                      WidgetStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 2,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            CustomProperties.borderRadius,
                                          ),
                                        ),
                                      ),
                                ),
                                onPressed: () async {
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
    try {
      var userId = Provider.of<AuthService>(
        context,
        listen: false,
      ).getConnectedUserId();
      var player = Player(
        userName: _usernameTextController.text,
        linkedUserId: userId,
        owned: false,
      );
      await _playerService.create(player);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(requestedIndex: 0),
        ),
      );
    } on ServiceException catch (e) {
      _usernameTextController.clear();
      InfoSnackBar.showSnackBar(context, e.message);
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: TextField(
            controller: _usernameTextController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelStyle: TextStyle(fontWeight: FontWeight.normal),
              labelText: AppLocalizations.of(context)!.messageEnterUsername,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
                borderSide: const BorderSide(width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
                borderSide: BorderSide(
                  width: 2.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
                borderSide: BorderSide(width: 2.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10, height: 5),
        ElevatedButton.icon(
          icon: const Icon(Icons.check),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            foregroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).colorScheme.onPrimary,
            ),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                side: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
              ),
            ),
          ),
          onPressed: () async {
            await _createPlayer();
          },
          label: Text(
            AppLocalizations.of(context)!.confirm,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
    try {
      var userId = Provider.of<AuthService>(
        context,
        listen: false,
      ).getConnectedUserId();
      var player = await _playerService.get(_idTextController.text);
      if (player != null) {
        if (player.owned == false) {
          throw CustomException(
            AppLocalizations.of(context)!.errorPlayerAlreadyLinked,
          );
        } else {
          player.linkedUserId = userId;
          player.ownedBy = '';
          player.owned = false;
          await _playerService.update(player);
          Provider.of<AuthService>(
            context,
            listen: false,
          ).setCurrentPlayer(player);
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(requestedIndex: 0),
            ),
          );
        }
      } else {
        throw CustomException(
          AppLocalizations.of(context)!.errorPlayerNotFound,
        );
      }
    } on CustomException catch (e) {
      InfoSnackBar.showErrorSnackBar(context, e.message);
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
              child: TextField(
                controller: _idTextController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontWeight: FontWeight.normal),
                  labelText: AppLocalizations.of(context)!.messageEnterUniqueId,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      CustomProperties.borderRadius,
                    ),
                    borderSide: const BorderSide(width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      CustomProperties.borderRadius,
                    ),
                    borderSide: BorderSide(
                      width: 2.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      CustomProperties.borderRadius,
                    ),
                    borderSide: BorderSide(width: 2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10, height: 5),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                foregroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    borderRadius: BorderRadius.circular(
                      CustomProperties.borderRadius,
                    ),
                  ),
                ),
              ),
              onPressed: () async {
                await _linkPlayer();
              },
              label: Text(
                AppLocalizations.of(context)!.confirm,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
