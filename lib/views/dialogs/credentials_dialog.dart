import 'package:carg/services/auth_service.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum CredentialsStatus { EDITING, CREATING }

class CredentialsDialog extends StatefulWidget {
  final CredentialsStatus credentialsStatus;

  CredentialsDialog({@required this.credentialsStatus});

  @override
  State<StatefulWidget> createState() {
    return _CredentialsDialogState(credentialsStatus);
  }
}

class _CredentialsDialogState extends State<CredentialsDialog> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
  var _title = '';
  var _credentialsStatus;
  var _isLoading = false;
  var _infoMessage = '';
  var _errorMessage = '';

  Future<void> _createFirebaseAccount() async {
    var transactionCompleted = true;
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<AuthService>(context, listen: false)
            .linkAnonymousToCredentials(
                _emailTextController.text, _passwordTextController.text);
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
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<AuthService>(context, listen: false).changeEmail(
            _emailTextController.text, _passwordTextController.text);
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
            'envoyé sur votre nouvelle adresse mail. Vous serez automatiquement connects';
        break;
      case CredentialsStatus.CREATING:
        _title = 'Création du compte';
        _infoMessage = 'Merci de renseigner une adresse mail valide ainsi '
            'qu\'un mot de passe fort. Vous serez ensuite invité à vous connecter';
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
      content: Form(
        key: _formKey,
        child: ListBody(children: [
          TextFormField(
              controller: _emailTextController,
              autofillHints: [AutofillHints.email],
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 2)),
                  enabledBorder: InputBorder.none,
                  labelStyle: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                  labelText: 'Nouvelle adresse mail'),
              validator: (value) {
                if (value ==
                    Provider.of<AuthService>(context, listen: false)
                        .getConnectedUserEmail()) {
                  return 'Adresse mail inchangée';
                } else if (value.isEmpty || !emailRegex.hasMatch(value)) {
                  return 'Adresse email invalide';
                }
                return null;
              }),
          TextFormField(
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              autofillHints: [AutofillHints.password],
              controller: _passwordTextController,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 2)),
                  enabledBorder: InputBorder.none,
                  labelStyle: TextStyle(
                      fontSize: 20, color: Theme.of(context).accentColor),
                  labelText: 'Mot de passe'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Mot de passe non renseigné';
                }
                return null;
              }),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Info : ' + _infoMessage,
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(_errorMessage,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    color: Colors.red)),
          )
        ]),
      ),
      actions: <Widget>[
        if (_isLoading)
          CircularProgressIndicator()
        else
          RaisedButton.icon(
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () async => {
                    await _credentialsStatus == CredentialsStatus.EDITING
                        ? _changeEmail()
                        : _createFirebaseAccount()
                  },
              label: Text(MaterialLocalizations.of(context).okButtonLabel),
              icon: Icon(Icons.check)),
        FlatButton.icon(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Theme.of(context).accentColor)),
          onPressed: () => {Navigator.pop(context, null)},
          color: Colors.white,
          textColor: Theme.of(context).accentColor,
          icon: Icon(Icons.close),
          label: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        )
      ],
      scrollable: true,
    );
  }
}
