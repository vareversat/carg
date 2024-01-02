import 'package:carg/models/score/round/round.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RealTimeDisplayWidget extends StatelessWidget {
  final Round round;

  const RealTimeDisplayWidget({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ChangeNotifierProvider.value(
        value: round,
        child: Consumer<Round>(
          builder: (context, roundData, child) => Center(
            child: Text(
              roundData.realTimeDisplay(context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
