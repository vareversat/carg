import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:flutter/material.dart';

class WarningDialog extends StatefulWidget {
  final String title;
  final Function onConfirm;
  final Color? color;
  final bool showCancelButton;
  final String? onConfirmButtonMessage;
  final String? onCancelButtonMessage;
  final String? message;
  final Widget? content;

  const WarningDialog(
      {Key? key,
      this.message,
      this.content,
      required this.title,
      required this.onConfirm,
      this.color,
      this.showCancelButton = true,
      this.onConfirmButtonMessage,
      this.onCancelButtonMessage})
      : assert((message != null) ^ (content != null)),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WarningDialogState();
  }
}

class _WarningDialogState extends State<WarningDialog> {
  bool _isLoading = false;

  _WarningDialogState();

  Future<void> _exec() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.onConfirm();
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
          color: widget.color ?? Theme.of(context).errorColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(
              15.0,
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 15),
        child: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyle.dialogHeaderStyle(context),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      content: widget.message != null
          ? Text(
              widget.message!,
              style: const TextStyle(fontSize: 22),
            )
          : widget.content!,
      actions: <Widget>[
        if (_isLoading)
          const CircularProgressIndicator()
        else
          ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    widget.color ?? Theme.of(context).errorColor),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).cardColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      CustomProperties.borderRadius,
                    ),
                  ),
                ),
              ),
              onPressed: () async => {await _exec(), Navigator.pop(context)},
              label: Text(
                widget.onConfirmButtonMessage?.toUpperCase() ??
                    MaterialLocalizations.of(context).okButtonLabel,
              ),
              icon: const Icon(Icons.check)),
        if (widget.showCancelButton)
          ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Theme.of(context).cardColor),
              foregroundColor: MaterialStateProperty.all<Color>(
                  widget.color ?? Theme.of(context).errorColor),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    CustomProperties.borderRadius,
                  ),
                ),
              ),
            ),
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(Icons.close),
            label: Text(
              widget.onCancelButtonMessage?.toUpperCase() ??
                  MaterialLocalizations.of(context).cancelButtonLabel,
            ),
          )
        else
          Container(),
      ],
    );
  }
}
