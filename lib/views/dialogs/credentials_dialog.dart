import 'package:carg/services/auth_service.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/screens/register/pin_code_verification_screen.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum CredentialsStatus { EDITING, CREATING }

class CredentialsDialog extends StatefulWidget {
  final CredentialsStatus credentialsStatus;

  CredentialsDialog({required this.credentialsStatus});

  @override
  State<StatefulWidget> createState() {
    return _CredentialsDialogState(credentialsStatus);
  }
}

class _CredentialsDialogState extends State<CredentialsDialog> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _emailRegex =
      RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
  var _title = '';
  var _credentialsStatus;
  var _isLoading = false;
  var _infoMessage = '';
  String? _errorMessage = '';

  Future<void> _createFirebaseAccount() async {
    var transactionCompleted = true;
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        // await Provider.of<AuthService>(context, listen: false)
        //     .linkAnonymousToCredentials(
        //         _emailTextController.text, _passwordTextController.text);
      } on CustomException catch (e) {
        setState(() {
          _errorMessage = e.message;
          transactionCompleted = false;
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
    if (transactionCompleted) {
      await Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _changeEmail() async {
    var transactionCompleted = true;
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        //await Provider.of<AuthService>(context, listen: false).changeEmail(
         //   _emailTextController.text, _passwordTextController.text);
      } on CustomException catch (e) {
        setState(() {
          _errorMessage = e.message;
          transactionCompleted = false;
        });
      }
      setState(() {
        _isLoading = false;
      });
      if (transactionCompleted) {
        await Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  _CredentialsDialogState(CredentialsStatus credentialsStatus) {
    _credentialsStatus = credentialsStatus;
    switch (credentialsStatus) {
      case CredentialsStatus.EDITING:
        _title = 'Edition du compte';
        _infoMessage = 'Après validation, un mail de confirmation va vous être '
            'envoyé sur votre nouvelle adresse mail. Vous serez automatiquement déconnectés';
        break;
      case CredentialsStatus.CREATING:
        _title = 'Création du compte';
        _infoMessage = 'Merci de renseigner une adresse mail valide ainsi '
            'qu\'un mot de passe fort. Vous serez ensuite redirigés vers l\'écran de connexion';
        break;
    }
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0))),
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 15),
        child: Text(
          _title,
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyle.dialogHeaderStyle(context),
        ),
      ),
      content: Container(),
      actions: <Widget>[
        if (_isLoading)
          CircularProgressIndicator()
        else
          ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).accentColor),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).cardColor),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              CustomProperties.borderRadius)))),
              onPressed: () async => {
                    await _credentialsStatus == CredentialsStatus.EDITING
                        ? _changeEmail()
                        : _createFirebaseAccount()
                  },
              label: Text(MaterialLocalizations.of(context).okButtonLabel),
              icon: Icon(Icons.check)),
        ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).accentColor),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          CustomProperties.borderRadius)))),
          onPressed: () => {Navigator.pop(context, null)},
          icon: Icon(Icons.close),
          label: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        )
      ],
      scrollable: true,
    );
  }
}
