import 'package:carg/models/player.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NextPlayerWidget extends StatelessWidget {
  final String? playerId;
  final PlayerService playerService = PlayerService();

  NextPlayerWidget({Key? key, required this.playerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Player?>(
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
            AppLocalizations.of(context)!.errorPlayerNotFound,
            style: const TextStyle(fontStyle: FontStyle.italic),
          );
        }
        return RichText(
          text: TextSpan(
            text:
                '${AppLocalizations.of(context)!.messagePlayerDistributeCardsFirsPart} ',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: snapshot.data!.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: AppLocalizations.of(context)!
                      .messagePlayerDistributeCardsSecondPart),
            ],
          ),
          textAlign: TextAlign.center,
        );
      },
      future: playerService.get(playerId),
    );
  }
}
