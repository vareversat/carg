import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrickPointsTarotWidget extends StatelessWidget {
  final TarotRound tarotRound;

  const TrickPointsTarotWidget({Key? key, required this.tarotRound})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: tarotRound,
      child: Consumer<TarotRound>(
          builder: (context, roundData, _) => Column(
                children: [
                  const SectionTitleWidget(title: 'Points des plis'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              roundData.attackTrickPoints--;
                            },
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            shape: const CircleBorder(),
                            child: const Icon(Icons.chevron_left_outlined)),
                      ),
                      Flexible(
                        flex: 5,
                        child: Slider(
                          value: roundData.attackTrickPoints,
                          min: 0,
                          max: TarotRound.maxTrickPoints,
                          divisions: TarotRound.maxTrickPoints.toInt(),
                          label:
                              'Attaque : ${roundData.attackTrickPoints.round().toString()} '
                              '\nDéfense : ${(roundData.defenseTrickPoints.round()).toString()}',
                          onChanged: (double value) {
                            roundData.attackTrickPoints = value.roundToDouble();
                          },
                        ),
                      ),
                      Flexible(
                        child: MaterialButton(
                            onPressed: () {
                              roundData.attackTrickPoints++;
                            },
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: const CircleBorder(),
                            child: const Icon(Icons.chevron_right_outlined)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                      'Attaque : ${roundData.attackTrickPoints.round().toString()} '
                      '| Défense : ${roundData.defenseTrickPoints.round().toString()}')
                ],
              )),
    );
  }
}
