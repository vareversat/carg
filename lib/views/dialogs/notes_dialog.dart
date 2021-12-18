import 'package:carg/models/game/game.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:flutter/material.dart';

class NotesDialog extends StatefulWidget {
  final Game game;

  NotesDialog({required this.game});

  @override
  State<StatefulWidget> createState() {
    return _NotesDialogState(game);
  }
}

class _NotesDialogState extends State<NotesDialog> {
  final Game _game;

  _NotesDialogState(this._game);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
      title: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0))),
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 15),
        child: Text(
          'Notes de partie',
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyle.dialogHeaderStyle(context),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: TextFormField(
        onChanged: (text) => _game.notes = text,
        initialValue: _game.notes,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary, width: 2))),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        minLines: 1,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
      ),
      actions: <Widget>[
        ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.secondary),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).cardColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            CustomProperties.borderRadius)))),
            onPressed: () async => {
                  await _game.gameService.updateGame(_game),
                  Navigator.pop(context)
                },
            label: Text(
              MaterialLocalizations.of(context).okButtonLabel,
            ),
            icon: Icon(Icons.check)),
        ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Theme.of(context).cardColor),
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.secondary),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          CustomProperties.borderRadius)))),
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(Icons.close),
          label: Text(
            MaterialLocalizations.of(context).cancelButtonLabel,
          ),
        )
      ],
    );
  }
}
