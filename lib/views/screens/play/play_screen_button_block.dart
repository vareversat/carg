import 'package:carg/styles/properties.dart';
import 'package:flutter/material.dart';

class PlayScreenButtonBlock extends StatelessWidget {
  final Function deleteLastRound;
  final Function editLastRound;
  final Function endGame;
  final Function addNewRound;
  final Function addNotes;

  const PlayScreenButtonBlock(
      {required this.deleteLastRound,
      required this.editLastRound,
      required this.endGame,
      required this.addNewRound,
      required this.addNotes});

  @override
  Widget build(BuildContext context) {
    return Wrap(
        runSpacing: 10,
        spacing: 10,
        alignment: WrapAlignment.spaceEvenly,
        children: <Widget>[
          RawMaterialButton(
              onPressed: () async => {deleteLastRound()},
              elevation: 2.0,
              fillColor: Theme.of(context).errorColor,
              textStyle: TextStyle(color: Theme.of(context).cardColor),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
              child: Icon(
                Icons.delete_rounded,
                size: 22,
              )),
          RawMaterialButton(
              onPressed: () async => {editLastRound()},
              elevation: 2.0,
              fillColor: Colors.black,
              textStyle: TextStyle(color: Theme.of(context).cardColor),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
              child: Icon(
                Icons.edit,
                size: 22,
              )),
          RawMaterialButton(
            onPressed: () async => {addNotes()},
            elevation: 2.0,
            fillColor: Theme.of(context).colorScheme.secondary,
            textStyle: TextStyle(color: Theme.of(context).cardColor),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
            child: Icon(
              Icons.notes,
              size: 22,
            ),
          ),
          RawMaterialButton(
            onPressed: () async => {endGame()},
            elevation: 2.0,
            fillColor: Theme.of(context).errorColor,
            textStyle: TextStyle(color: Theme.of(context).cardColor),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
            child: Icon(
              Icons.stop,
              size: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).cardColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius)))),
                    onPressed: () => {addNewRound()},
                    icon: Icon(Icons.plus_one, size: 30),
                    label: Text('Nouvelle manche',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 23))),
              ),
            ),
          )
        ]);
  }
}
