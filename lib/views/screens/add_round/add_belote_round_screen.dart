import 'package:carg/models/game/belote.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/models/score/round/coinche_belote_round.dart';
import 'package:carg/models/score/round/contree_belote_round.dart';
import 'package:carg/models/score/round/french_belote_round.dart';
import 'package:carg/services/round/abstract_round_service.dart';
import 'package:carg/styles/custom_properties.dart';
import 'package:carg/views/screens/add_round/widget/real_time_display_widget.dart';
import 'package:carg/views/screens/add_round/widget/screen_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/contract_belote_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/contract_coinche_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/contract_contree_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/taker_team_widget.dart';
import 'package:carg/views/screens/add_round/widget/team_game/trick_points_belote_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddBeloteRoundScreen extends StatelessWidget {
  final Belote? beloteGame;
  final BeloteRound? beloteRound;
  final bool isEditing;
  final AbstractRoundService roundService;

  const AddBeloteRoundScreen({
    super.key,
    this.beloteGame,
    required this.beloteRound,
    this.isEditing = false,
    required this.roundService,
  });

  void _setupRound() async {
    if (isEditing) {
      await roundService.editLastRoundOfScoreByGameId(
        beloteGame!.id,
        beloteRound,
      );
    } else {
      await roundService.addRoundToGame(beloteGame!.id, beloteRound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        title: const ScreenTitleWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Flexible(
              child: ListView(
                children: [
                  TakerTeamWidget(beloteRound: beloteRound!),
                  const Divider(),
                  TrickPointsBeloteWidget(round: beloteRound!),
                  const Divider(),
                  if (beloteRound! is CoincheBeloteRound)
                    ContractCoincheWidget(
                      coincheRound: beloteRound! as CoincheBeloteRound,
                    )
                  else if (beloteRound! is FrenchBeloteRound)
                    ContractBeloteWidget(
                      frenchBeloteRound: beloteRound! as FrenchBeloteRound,
                    )
                  else if (beloteRound! is ContreeBeloteRound)
                    ContractContreeWidget(
                      contreeRound: beloteRound! as ContreeBeloteRound,
                    ),
                ],
              ),
            ),
            Column(
              children: [
                RealTimeDisplayWidget(round: beloteRound!),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).cardColor,
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                CustomProperties.borderRadius,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () => {
                          _setupRound(),
                          Navigator.pop(context),
                        },
                        label: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.validate,
                            style: const TextStyle(
                              fontSize: 23,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.check,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
