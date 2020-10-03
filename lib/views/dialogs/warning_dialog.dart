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
      this.onConfirmButtonMessage = 'Confirmer'});

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
    return SimpleDialog(
        contentPadding: const EdgeInsets.all(18),
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          decoration: BoxDecoration(
              color: _color ?? Theme.of(context).errorColor,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0))),
          padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  _title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        children: <Widget>[
          Text(_message, style: Theme.of(context).textTheme.bodyText2),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _showCancelButton
                    ? FlatButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: _color ?? Theme.of(context).errorColor)),
                        onPressed: () => {Navigator.pop(context)},
                        color: Colors.white,
                        textColor: _color ?? Theme.of(context).errorColor,
                        icon: Icon(Icons.close),
                        label: Text('Annuler',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      )
                    : Container(),
                SizedBox(
                  width: 10,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton.icon(
                        color: _color ?? Theme.of(context).errorColor,
                        textColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        onPressed: () async =>
                            {await _exec(), Navigator.pop(context)},
                        label: Text(_onConfirmButtonMessage,
                            style: TextStyle(fontSize: 14)),
                        icon: Icon(Icons.check)),
              ],
            ),
          ),
        ]);
  }
}
