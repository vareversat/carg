import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/player_color_explanation_dialog.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/tabs/player_list_tab.dart';
import 'package:carg/views/tabs/team_list_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayerListScreen extends StatefulWidget {
  final AbstractPlayerService playerService;
  final AbstractTeamService teamService;

  const PlayerListScreen(
      {Key? key, required this.playerService, required this.teamService})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerListScreenState();
  }
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  late bool isAdmin;

  @override
  void initState() {
    isAdmin = Provider.of<AuthService>(context, listen: false).getAdmin()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: AppBar(
                actions: [
                  PopupMenuButton<String>(
                      key: const ValueKey('playerListPopupMenuButton'),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                key: const ValueKey('addPlayerPopupMenuItem'),
                                child: Text(
                                    AppLocalizations.of(context)!.newPlayer,
                                    style: const TextStyle(fontSize: 14)),
                                onTap: () async {
                                  Future.delayed(const Duration(seconds: 0),
                                      () async {
                                    var result = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            PlayerInfoDialog(
                                                key: const ValueKey(
                                                    'addPlayerDialog'),
                                                player: Player(owned: true),
                                                playerService:
                                                    widget.playerService,
                                                isNewPlayer: true));
                                    if (result != null) {
                                      InfoSnackBar.showSnackBar(
                                          context, result);
                                    }
                                  });
                                }),
                            PopupMenuItem(
                                key: const ValueKey(
                                    'showInformationPopupMenuItem'),
                                child: Text(
                                    AppLocalizations.of(context)!.information,
                                    style: const TextStyle(fontSize: 14)),
                                onTap: () async {
                                  Future.delayed(const Duration(seconds: 0),
                                      () async {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            PlayerColorExplanationDialog(
                                              key: const ValueKey(
                                                  'playerColorExplanationDialog'),
                                              isAdmin: isAdmin,
                                            ));
                                  });
                                })
                          ])
                ],
                automaticallyImplyLeading: false,
                title: Text(AppLocalizations.of(context)!.player(2),
                    style: CustomTextStyle.screenHeadLine1(context)),
                bottom: TabBar(
                  indicatorWeight: 4,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                        key: const ValueKey('playerListTab'),
                        child: Text(AppLocalizations.of(context)!.player(2),
                            style: const TextStyle(fontSize: 15))),
                    Tab(
                        key: const ValueKey('ownedPlayerListTab'),
                        child: Text(AppLocalizations.of(context)!.myPlayers,
                            style: const TextStyle(fontSize: 15))),
                    Tab(
                        key: const ValueKey('playerListTeam'),
                        child: Text(AppLocalizations.of(context)!.myTeams,
                            style: const TextStyle(fontSize: 15))),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                PlayerListTab(
                    playerService: widget.playerService, myPlayers: false),
                PlayerListTab(
                    playerService: widget.playerService, myPlayers: true),
                TeamListTab(
                    teamService: widget.teamService,
                    playerService: widget.playerService)
              ],
            )));
  }
}
