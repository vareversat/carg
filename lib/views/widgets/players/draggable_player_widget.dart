import 'package:carg/models/player.dart';
import 'package:flutter/material.dart';

class DraggablePlayerWidget extends StatelessWidget {
  final Player player;
  final int index;

  const DraggablePlayerWidget(
      {Key? key, required this.player, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            flex: 3,
            child: Text(
              '#${index + 1}',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Flexible(
            flex: 5,
            child: Text(
              player.userName!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const Flexible(flex: 2, child: Icon(Icons.drag_indicator, size: 35))
        ]),
      ),
    );
  }
}
