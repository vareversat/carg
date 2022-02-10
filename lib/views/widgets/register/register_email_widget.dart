import 'package:carg/services/auth_service.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/storage_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/dialogs.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class RegisterEmailWidget extends StatefulWidget {
  final CredentialVerificationType credentialVerificationType;

  const RegisterEmailWidget(
      {Key? key, required this.credentialVerificationType})
      : super(key: key);

  @override
  _RegisterEmailWidgetState createState() => _RegisterEmailWidgetState();
}

class _RegisterEmailWidgetState extends State<RegisterEmailWidget>
    with WidgetsBindingObserver {
  final _store =
      StorageService(flutterSecureStorage: const FlutterSecureStorage());
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  Future<dynamic> _signInWithEmailAndLink(String email) async {
    await _store.setEmail(email);
    try {
      if (widget.credentialVerificationType ==
          CredentialVerificationType.CREATE) {
        await Provider.of<AuthService>(context, listen: false)
            .sendSignInWithEmailLink(email);
        InfoSnackBar.showSnackBar(context, 'Info : Email envoyé');
      } else {
        await Provider.of<AuthService>(context, listen: false)
            .changeEmail(email);
        Dialogs.showMessageDialog(context, _keyLoader,
            'Lien de validation envoyé. Vous allez être déconnecté');
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        await Provider.of<AuthService>(context, listen: false).signOut(context);
      }
    } on CustomException catch (e) {
      InfoSnackBar.showSnackBar(context, e.message);
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
    return ChangeNotifierProvider.value(
        value: _EmailRegistrationData(),
        child: Consumer<_EmailRegistrationData>(
            builder: (context, emailRegistrationData, _) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    TextField(
                      autofillHints: const [AutofillHints.email],
                      onChanged: (value) {
                        emailRegistrationData.emailAddress = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.normal,
                        ),
                        fillColor: Theme.of(context).primaryColor,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              CustomProperties.borderRadius),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              CustomProperties.borderRadius),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              CustomProperties.borderRadius),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    widget.credentialVerificationType ==
                            CredentialVerificationType.CREATE
                        ? const Text(
                            'Un e-mail contenant un lien de connexion va vous être envoyé',
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 13),
                          )
                        : const SizedBox(height: 10),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                !emailRegistrationData.isEmailEmpty()
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).cardColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                !emailRegistrationData.isEmailEmpty()
                                    ? Theme.of(context).cardColor
                                    : Colors.grey),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 2,
                                        color:
                                            !emailRegistrationData.isEmailEmpty()
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey),
                                    borderRadius: BorderRadius.circular(CustomProperties.borderRadius)))),
                        onPressed: !emailRegistrationData.isEmailEmpty()
                            ? () async {
                                await _signInWithEmailAndLink(
                                    emailRegistrationData.emailAddress!);
                              }
                            : null,
                        label: const Text(
                          'Continuer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ]),
                )));
  }
}

class _EmailRegistrationData with ChangeNotifier {
  String? _emailAddress;

  String? get emailAddress => _emailAddress;

  set emailAddress(String? value) {
    _emailAddress = value;
    notifyListeners();
  }

  bool isEmailEmpty() {
    return _emailAddress == null || _emailAddress == '';
  }
}
