import 'package:carg/models/score/round/round.dart';
import 'package:flutter/material.dart';

class RealTimeDisplayWidget extends StatelessWidget {
  final Round round;

  const RealTimeDisplayWidget({this.round});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(round.realTimeDisplay(),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)));
  }

}