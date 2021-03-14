import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/screens/add_round/widget/real_time_display_widget.dart';
import 'package:carg/views/screens/add_round/widget/screen_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/contract_belote_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/contract_coinche_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/taker_team_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/trick_points_belote_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AddBeloteRoundScreen extends StatelessWidget {
  final Belote? teamGame;
  final BeloteRound? beloteRound;
  final bool isEditing;

  const AddBeloteRoundScreen(
      {this.teamGame, required this.beloteRound, this.isEditing = false});

  void _setupRound() async {
    if (isEditing) {
      await teamGame!.scoreService
          .editLastRoundOfGame(teamGame!.id, beloteRound);
    } else {
      await teamGame!.scoreService.addRoundToGame(teamGame!.id, beloteRound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          title: ScreenTitleWidget()),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Flexible(
              child: ListView(children: [
                TakerTeamWidget(beloteRound: beloteRound!),
                Divider(),
                TrickPointsBeloteWidget(round: beloteRound!),
                Divider(),
                beloteRound! is CoincheBeloteRound
                    ? ContractCoincheWidget(
                        coincheRound: beloteRound! as CoincheBeloteRound)
                    : ContractBeloteWidget(
                        frenchBeloteRound: beloteRound! as FrenchBeloteRound),
                SizedBox(height: 20),
                RealTimeDisplayWidget(round: beloteRound!),
                SizedBox(height: 20),
              ]),
            ),
            Center(
                child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).cardColor),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    CustomProperties.borderRadius)))),
                    onPressed: () => {_setupRound(), Navigator.pop(context)},
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Valider', style: TextStyle(fontSize: 23)),
                    ),
                    icon: Icon(Icons.check, size: 30)),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
