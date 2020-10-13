import 'package:carg/models/score/round/team_game_round.dart';
import 'package:flutter/material.dart';

class RealTimeDisplayWidget extends StatelessWidget {
  final TeamGameRound round;

  const RealTimeDisplayWidget({this.round});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(round.realTimeDisplay(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)));
  }

}