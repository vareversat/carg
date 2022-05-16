import 'package:carg/models/score/french_belote_score.dart';
import 'package:flutter/material.dart';

import '../../services/impl/score/french_belote_score_service.dart';

class BeloteRoundWidget extends StatefulWidget {
  final String beloteGameId;

  const BeloteRoundWidget({
    Key? key,
    required this.beloteGameId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BeloteRoundWidgetState();
  }
}

class _BeloteRoundWidgetState extends State<BeloteRoundWidget> {
  final _roundService = FrenchBeloteScoreService();

  _BeloteRoundWidgetState();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FrenchBeloteScore?>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.none) {
          return Container(
              alignment: Alignment.center, child: const Icon(Icons.error));
        }
        if (snapshot.data != null) {
          return Column(
            children: <Widget>[
              const Flexible(
                flex: 1,
                child: Text('Score'),
              ),
              Flexible(
                flex: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: ListView.builder(
                          itemCount: snapshot.data!.rounds.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: <Widget>[
                                Flexible(
                                  child: Center(
                                    child: Text(snapshot
                                        .data!.rounds[index].takerScore
                                        .toString()),
                                  ),
                                ),
                                Flexible(
                                  child: Center(
                                    child: Text(snapshot
                                        .data!.rounds[index].defenderScore
                                        .toString()),
                                  ),
                                )
                              ],
                            );
                          }),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Center(
                                child: Text(
                                    snapshot.data!.usTotalPoints.toString())),
                          ),
                          Flexible(
                            child: Center(
                                child: Text(
                                    snapshot.data!.themTotalPoints.toString())),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        }
        return const Text('Pas de score pour le moment');
      },
      future: _roundService.getScoreByGame(widget.beloteGameId),
    );
  }
}
