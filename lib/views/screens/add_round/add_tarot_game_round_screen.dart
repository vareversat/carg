import 'package:carg/models/game/tarot_game.dart';
import 'package:carg/models/player/tarot_game_players_round.dart';
import 'package:carg/models/score/round/tarot_round.dart';
import 'package:carg/views/screens/add_round/widget/tarot_game/contract_tarot_widget.dart';
import 'package:carg/views/screens/add_round/widget/tarot_game/oudler_picker_widget.dart';
import 'package:carg/views/screens/add_round/widget/real_time_display_widget.dart';
import 'package:carg/views/screens/add_round/widget/screen_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/section_title_widget.dart';
import 'package:carg/views/screens/add_round/widget/tarot_game/tarot_perk_widget.dart';
import 'package:carg/views/screens/add_round/widget/tarot_game/trick_points_tarot_widget.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTarotGameRoundScreen extends StatelessWidget {
  final TarotGame tarotGame;
  final TarotRound tarotRound;
  final bool isEditing;

  void _setupRound() async {
    if (isEditing) {
      await tarotGame.scoreService
          .editLastRoundOfGame(tarotGame.id, tarotRound);
    } else {
      await tarotGame.scoreService.addRoundToGame(tarotGame.id, tarotRound);
    }
  }

  AddTarotGameRoundScreen(
      {this.tarotGame,
      this.tarotRound,
      this.isEditing});

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
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: [
              ChangeNotifierProvider(
                  create: (BuildContext context) =>
                      tarotRound.players,
                  child: Column(
                    children: [
                      SectionTitleWidget(
                          title: 'Peneur' +
                              (tarotRound.players.playerList.length >
                                      4
                                  ? 's'
                                  : '')),
                      Consumer<TarotGamePlayersRound>(
                        builder: (context, playerData, _) => Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          children: playerData.playerList
                              .map((playerId) => APIMiniPlayerWidget(
                                  isSelected:
                                      playerData.isPlayerSelected(playerId),
                                  playerId: playerId,
                                  displayImage:
                                      !playerData.isPlayerSelected(playerId),
                                  showLoading: false,
                                  selectedColor: playerData.getSelectedColor(
                                      playerId, context),
                                  size: 20,
                                  onTap: () =>
                                      playerData.onSelectedPlayer2(playerId)))
                              .toList()
                              .cast<Widget>(),
                        ),
                      ),
                    ],
                  )),
              ChangeNotifierProvider(
                create: (BuildContext context) => tarotRound..computeRound(),
                child: Consumer<TarotRound>(
                  builder: (context, roundData, _) => Column(children: [
                    Divider(),
                    ContractTarotWidget(round: roundData),
                    Divider(),
                    OudlerPickerWidget(round: roundData),
                    Divider(),
                    TrickPointsTarotWidget(round: roundData),
                    Divider(),
                    TarotPerkWidget(round: roundData, tarotGame: tarotGame),
                    SizedBox(height: 20),
                    RealTimeDisplayWidget(round: tarotRound),
                    SizedBox(height: 20),
                    Center(
                        child: RaisedButton.icon(
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            onPressed: () async =>
                                {await _setupRound(), Navigator.pop(context)},
                            label: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Valider',
                                  style: Theme.of(context).textTheme.bodyText1),
                            ),
                            icon: Icon(Icons.check)))
                  ]),
                ),
              ),
            ])));
  }
}
