import 'package:carg/models/score/round/round.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RealTimeDisplayWidget extends StatelessWidget {
  final Round round;

  const RealTimeDisplayWidget({Key? key, required this.round})
      : super(key: key);

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
