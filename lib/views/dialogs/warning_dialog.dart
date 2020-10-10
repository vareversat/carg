import 'package:carg/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WarningDialog extends StatefulWidget {
  final String message;
  final String title;
  final Function onConfirm;
  final Color color;
  final bool showCancelButton;
  final String onConfirmButtonMessage;

  WarningDialog(
      {@required this.message,
      @required this.title,
      @required this.onConfirm,
      this.color,
      this.showCancelButton = true,
      this.onConfirmButtonMessage});

  @override
  State<StatefulWidget> createState() {
    return _WarningDialogState(message, title, onConfirm, color,
        showCancelButton, onConfirmButtonMessage);
  }
}

class _WarningDialogState extends State<WarningDialog> {
  final String _message;
  final String _title;
  final Function _onConfirm;
  final Color _color;
  final bool _showCancelButton;
  final String _onConfirmButtonMessage;
  bool _isLoading = false;

  _WarningDialogState(this._message, this._title, this._onConfirm, this._color,
      this._showCancelButton, this._onConfirmButtonMessage);

  Future<void> _exec() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _onConfirm();
    } catch (e) {
      _isLoading = false;
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
      title: Container(
        decoration: BoxDecoration(
            color: _color ?? Theme.of(context).errorColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0))),
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 15),
        child: Text(
          _title,
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyle.screenHeadLine1(context),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Text(_message),
      actions: <Widget>[
        if (_isLoading)
          CircularProgressIndicator()
        else
          RaisedButton.icon(
              color: _color ?? Theme.of(context).errorColor,
              textColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () async => {await _exec(), Navigator.pop(context)},
              label: Text(
                _onConfirmButtonMessage?.toUpperCase() ??
                    MaterialLocalizations.of(context).okButtonLabel,
              ),
              icon: Icon(Icons.check)),
        if (_showCancelButton)
          FlatButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side:
                    BorderSide(color: _color ?? Theme.of(context).errorColor)),
            onPressed: () => {Navigator.pop(context)},
            color: Colors.white,
            textColor: _color ?? Theme.of(context).errorColor,
            icon: Icon(Icons.close),
            label: Text(
              MaterialLocalizations.of(context).cancelButtonLabel,
            ),
          )
        else
          Container(),
      ],
    );
  }
}
