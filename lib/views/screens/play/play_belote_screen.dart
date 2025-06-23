import 'package:carg/helpers/correct_instance.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/setting/belote_game_setting.dart';
import 'package:carg/models/score/belote_score.dart';
import 'package:carg/models/score/misc/belote_special_round.dart';
import 'package:carg/models/score/misc/belote_team_enum.dart';
import 'package:carg/models/score/round/belote_round.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/services/impl/team_service.dart';
import 'package:carg/services/round/abstract_round_service.dart';
import 'package:carg/services/score/abstract_score_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/notes_dialog.dart';
import 'package:carg/views/dialogs/special_roud_dialog.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/add_round/add_belote_round_screen.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/play/play_screen_app_bar.dart';
import 'package:carg/views/screens/play/play_screen_button_block.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/players/next_player_widget.dart';
import 'package:carg/views/widgets/team_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayBeloteScreen extends StatefulWidget {
  final Belote beloteGame;
  final AbstractGameService gameService;
  final AbstractScoreService scoreService;
  final AbstractRoundService roundService;

  const PlayBeloteScreen({
    super.key,
    required this.beloteGame,
    required this.gameService,
    required this.scoreService,
    required this.roundService,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayBeloteScreenState();
  }
}

class _PlayBeloteScreenState extends State<PlayBeloteScreen> {
  String? _errorMessage;

  void _addNewRound() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBeloteRoundScreen(
          beloteGame: widget.beloteGame,
          beloteRound:
              widget.roundService.getNewRound(widget.beloteGame.settings)
                  as BeloteRound?,
          roundService: CorrectInstance.ofRoundService(widget.beloteGame),
        ),
      ),
    );
  }

  void _addNewSpecialRound() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => SpecialRoundDialog(
        beloteGame: widget.beloteGame,
        beloteRound:
            widget.roundService.getNewRound(widget.beloteGame.settings)
                as BeloteRound?,
        roundService: CorrectInstance.ofRoundService(widget.beloteGame),
      ),
    );
  }

  void _deleteRound(int index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => WarningDialog(
        onConfirm: () async => {
          await widget.roundService.deleteGameRound(
            widget.beloteGame.id,
            index,
          ),
        },
        message: AppLocalizations.of(context)!.messageDeleteRound,
        title: AppLocalizations.of(context)!.warning,
      ),
    );
  }

  void _endGame() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => WarningDialog(
        onConfirm: () async => {
          await widget.gameService.endAGame(widget.beloteGame, DateTime.now()),
          await Navigator.of(
            context,
          ).pushReplacementNamed(HomeScreen.routeName, arguments: 1),
        },
        message: AppLocalizations.of(context)!.messageStopGame,
        title: AppLocalizations.of(context)!.warning,
      ),
    );
  }

  void _editRound(
    int index,
    BeloteRound round,
    BeloteGameSetting? settings,
  ) async {
    round.settings = settings;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBeloteRoundScreen(
          beloteGame: widget.beloteGame,
          roundIndex: index,
          beloteRound: round,
          roundService: CorrectInstance.ofRoundService(widget.beloteGame),
          isEditing: true,
        ),
      ),
    );
  }

  void _addNotes() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) =>
          NotesDialog(game: widget.beloteGame, gameService: widget.gameService),
    );
  }

  bool _showLastRoundLayout(BeloteScore score) {
    if (widget.beloteGame.settings.isInfinite) {
      return false;
    } else {
      return widget.beloteGame.settings.maxPoint <= score.themTotalPoints ||
          widget.beloteGame.settings.maxPoint <= score.usTotalPoints;
    }
  }

  _PlayBeloteScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PlayScreenAppBar(game: widget.beloteGame),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TeamWidget(
                    teamId: widget.beloteGame.players!.us,
                    title: AppLocalizations.of(context)!.us,
                    teamService: TeamService(),
                    playerService: PlayerService(),
                  ),
                ),
                Flexible(
                  child: TeamWidget(
                    teamId: widget.beloteGame.players!.them,
                    title: AppLocalizations.of(context)!.them,
                    teamService: TeamService(),
                    playerService: PlayerService(),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    width: 1,
                  ),
                ),
              ),
              child: StreamBuilder<BeloteScore?>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              _TotalPointsWidget(
                                totalPoints: snapshot.data!.usTotalPoints,
                              ),
                              _TotalPointsWidget(
                                totalPoints: snapshot.data!.themTotalPoints,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListView.builder(
                              itemCount: snapshot.data!.rounds.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AbsorbPointer(
                                  absorbing: widget.beloteGame.isEnded,
                                  child: InkWell(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    onLongPress: () async =>
                                        _deleteRound(index),
                                    onTap: () async =>
                                        !snapshot.data!.rounds[index]
                                            .isSpecialRound()
                                        ? {
                                            _editRound(
                                              index,
                                              snapshot.data!.rounds[index],
                                              widget.beloteGame.settings,
                                            ),
                                          }
                                        : {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 5,
                                          child: _RoundDisplayWidget(
                                            round: snapshot.data!.rounds[index],
                                            team: BeloteTeamEnum.US,
                                          ),
                                        ),
                                        if (snapshot.data!.rounds[index]
                                            .isSpecialRound())
                                          _SpecialRoundDisplayWidget(
                                            round: snapshot.data!.rounds[index],
                                          )
                                        else
                                          Flexible(
                                            child: Text(
                                              snapshot.data!.rounds[index]
                                                  .getRoundWidgetCentralElement(),
                                              style: const TextStyle(
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        Flexible(
                                          flex: 5,
                                          child: _RoundDisplayWidget(
                                            round: snapshot.data!.rounds[index],
                                            team: BeloteTeamEnum.THEM,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        if (!widget.beloteGame.isEnded)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NextPlayerWidget(
                              playerId:
                                  widget
                                      .beloteGame
                                      .players!
                                      .playerList![snapshot
                                          .data!
                                          .rounds
                                          .length %
                                      4]!,
                            ),
                          ),
                        if (!widget.beloteGame.isEnded)
                          PlayScreenButtonBlock(
                            endGame: _endGame,
                            addNewRound: _addNewRound,
                            addNotes: _addNotes,
                            addNewSpecialRound: _addNewSpecialRound,
                            lastRoundLayout: _showLastRoundLayout(
                              snapshot.data!,
                            ),
                          )
                        else if (widget.beloteGame.notes != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.gameNotes} : ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(widget.beloteGame.notes!),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  } else {
                    return ErrorMessageWidget(message: _errorMessage);
                  }
                },
                stream:
                    widget.scoreService
                            .getScoreByGameStream(widget.beloteGame.id)
                            .handleError(
                              (error) => {_errorMessage = error.toString()},
                            )
                        as Stream<BeloteScore<BeloteRound>?>?,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialRoundDisplayWidget extends StatelessWidget {
  final BeloteRound round;

  _SpecialRoundDisplayWidget({required this.round})
    : assert(round.isSpecialRound());

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(CustomProperties.borderRadius),
            left: Radius.circular(CustomProperties.borderRadius),
          ),
          color: round.beloteSpecialRound!.color(context),
        ),
        child: Text(
          round.specialRoundToString(),
          style: TextStyle(
            fontSize: 13,
            color: round.beloteSpecialRound!.textColor(context),
          ),
        ),
      ),
    );
  }
}

class _RoundDisplayWidget extends StatelessWidget {
  final BeloteRound? round;
  final BeloteTeamEnum? team;

  const _RoundDisplayWidget({this.round, this.team});

  int? _getScore(BeloteRound teamGameRound, BeloteTeamEnum? teamGameEnum) {
    if (teamGameEnum == teamGameRound.taker) {
      return teamGameRound.takerScore;
    } else {
      return teamGameRound.defenderScore;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: team == BeloteTeamEnum.US
          ? TextDirection.ltr
          : TextDirection.rtl,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            _getScore(round!, team).toString(),
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        if (!round!.isSpecialRound())
          Row(
            textDirection: team == BeloteTeamEnum.US
                ? TextDirection.ltr
                : TextDirection.rtl,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(CustomProperties.borderRadius),
                    left: Radius.circular(CustomProperties.borderRadius),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  textDirection: team == BeloteTeamEnum.US
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: [
                    if (round!.dixDeDer == team)
                      Text(
                        '+10',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    if (round!.beloteRebelote == team)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.crown,
                              size: 10,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            Text(
                              '|',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            FaIcon(
                              FontAwesomeIcons.chessQueen,
                              size: 10,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (!round!.isSpecialRound())
                Row(
                  textDirection: team == BeloteTeamEnum.US
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: [
                    if (round!.taker == team)
                      if (round!.contractFulfilled)
                        const FaIcon(
                          FontAwesomeIcons.solidCircleCheck,
                          size: 12,
                          color: Colors.green,
                        )
                      else
                        const FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          size: 12,
                          color: Colors.red,
                        )
                    else
                      const SizedBox(width: 12),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}

class _TotalPointsWidget extends StatelessWidget {
  final int? totalPoints;

  const _TotalPointsWidget({this.totalPoints});

  @override
  Widget build(BuildContext context) {
    return Text(
      totalPoints.toString(),
      style: const TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
    );
  }
}
