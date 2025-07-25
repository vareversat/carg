import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/models/players/tarot_round_players.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/round/tarot_round_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/screens/add_round/widget/real_time_display_widget.dart';
import 'package:carg/views/screens/add_round/widget/screen_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/tarot_game/contract_tarot_widget.dart';
import 'package:carg/views/screens/add_round/widget/tarot_game/oudler_picker_widget.dart';
import 'package:carg/views/screens/add_round/widget/tarot_game/tarot_perk_widget.dart';
import 'package:carg/views/screens/add_round/widget/tarot_game/trick_points_tarot_widget.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTarotRoundScreen extends StatelessWidget {
  final Tarot? tarotGame;
  final TarotRound? tarotRound;
  final bool? isEditing;
  final int? roundIndex;
  final tarotRoundService = TarotRoundService();

  void _setupRound() async {
    if (isEditing!) {
      await tarotRoundService.editGameRound(
        tarotGame!.id,
        tarotRound,
        roundIndex!,
      );
    } else {
      await tarotRoundService.addRoundToGame(tarotGame!.id, tarotRound);
    }
  }

  AddTarotRoundScreen({
    super.key,
    this.tarotGame,
    this.tarotRound,
    this.roundIndex,
    this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        title: const ScreenTitleWidget(),
      ),
      body: Column(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      SectionTitleWidget(
                        title: AppLocalizations.of(context)!.takerTitleTarot(
                          tarotRound!.players!.playerList!.length % 5,
                        ),
                      ),
                      ChangeNotifierProvider.value(
                        value: tarotRound!.players!,
                        child: Consumer<TarotRoundPlayers>(
                          builder: (context, playerData, _) => Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            children: playerData.playerList!
                                .map(
                                  (player) => APIMiniPlayerWidget(
                                    isSelected: playerData.isPlayerSelected(
                                      player,
                                    ),
                                    playerId: player,
                                    displayImage: !playerData.isPlayerSelected(
                                      player,
                                    ),
                                    showLoading: false,
                                    selectedColor: playerData.getSelectedColor(
                                      player,
                                      context,
                                    ),
                                    playerService: PlayerService(),
                                    onTap: () =>
                                        playerData.onSelectedPlayer2(player),
                                  ),
                                )
                                .toList()
                                .cast<Widget>(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Divider(),
                      ContractTarotWidget(tarotRound: tarotRound!),
                      const Divider(),
                      OudlerPickerWidget(tarotRound: tarotRound!),
                      const Divider(),
                      TrickPointsTarotWidget(tarotRound: tarotRound!),
                      const Divider(),
                      TarotPerkWidget(
                        tarotRound: tarotRound!,
                        tarotGame: tarotGame,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(CustomProperties.borderRadius),
                topRight: Radius.circular(CustomProperties.borderRadius),
              ),
            ),
            child: Column(
              children: [
                RealTimeDisplayWidget(round: tarotRound!),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: () => {_setupRound(), Navigator.pop(context)},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.confirm,
                            style: const TextStyle(fontSize: 23),
                          ),
                        ),
                        const Icon(Icons.check, size: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
