import 'package:carg/models/game/game.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameTitleWidget extends StatelessWidget {
  final Game? game;

  const GameTitleWidget({Key? key, this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 2,
          child: Text(
              DateFormat('dd/MM/yyyy, HH:mm').format(game!.startingDate),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        Flexible(
          flex: 1,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(80.0),
              child: Container(
                color: game!.isEnded
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                height: 30,
                child: Center(
                    child: Text(game!.isEnded ? 'Terminée' : 'En cours',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).cardColor,
                            fontSize: 15),
                        overflow: TextOverflow.ellipsis)),
              )),
        )
      ],
    ));
  }
}
