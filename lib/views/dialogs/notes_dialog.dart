import 'package:carg/models/game/game.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/styles/custom_properties.dart';
import 'package:carg/styles/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesDialog extends StatefulWidget {
  final Game game;
  final AbstractGameService gameService;

  const NotesDialog({super.key, required this.game, required this.gameService});

  @override
  State<StatefulWidget> createState() {
    return _NotesDialogState();
  }
}

class _NotesDialogState extends State<NotesDialog> {
  _NotesDialogState();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
      title: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 0, 15),
        child: Text(
          AppLocalizations.of(context)!.gameNotes,
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyle.dialogHeaderStyle(context),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: TextFormField(
        onChanged: (text) => widget.game.notes = text,
        initialValue: widget.game.notes,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: color,
              width: 2,
            ),
          ),
        ),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        minLines: 1,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
      ),
      actions: <Widget>[
        ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              color,
            ),
            foregroundColor:
                MaterialStateProperty.all<Color>(Theme.of(context).cardColor),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
              ),
            ),
          ),
          onPressed: () => {
            widget.gameService.update(widget.game).then(
                  (value) => Navigator.pop(context),
                ),
          },
          label: Text(
            MaterialLocalizations.of(context).okButtonLabel,
          ),
          icon: const Icon(
            Icons.check,
          ),
        ),
        ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Theme.of(context).cardColor),
            foregroundColor: MaterialStateProperty.all<Color>(
              color,
            ),
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
            MaterialLocalizations.of(context).cancelButtonLabel,
          ),
        ),
      ],
    );
  }
}
