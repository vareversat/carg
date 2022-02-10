import 'package:carg/models/player.dart';
import 'package:carg/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NextPlayerWidget extends StatelessWidget {
  final String? playerId;
  final PlayerService playerService = PlayerService();

  NextPlayerWidget({Key? key, this.playerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Player>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitThreeBounce(
              size: 20,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                    decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ));
              });
        }
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.data == null) {
          return Text(
            'Error : player $playerId unknown',
            style: const TextStyle(fontStyle: FontStyle.italic),
          );
        }
        return RichText(
          text: TextSpan(
            text: 'Au tours de ',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: snapshot.data!.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: ' de donner les cartes !'),
            ],
          ),
          textAlign: TextAlign.center,
        );
      },
      future: playerService.getPlayer(playerId),
    );
  }
}
