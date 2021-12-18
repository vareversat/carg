import 'package:carg/models/score/round/round.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RealTimeDisplayWidget extends StatelessWidget {
  final Round round;

  const RealTimeDisplayWidget({required this.round});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ChangeNotifierProvider.value(
        value: round,
        child: Consumer<Round>(
            builder: (context, roundData, child) => Center(
                child: Text(roundData.realTimeDisplay(),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 23)))),
      ),
    );
  }
}
