import 'package:carg/models/team.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/dialogs/team_stat_dialog.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeamStatWidget extends StatelessWidget {
  final Team team;
  final AbstractPlayerService playerService;
  final AbstractTeamService teamService;

  const TeamStatWidget({
    super.key,
    required this.team,
    required this.playerService,
    required this.teamService,
  });

  Future _showStatDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder:
          (BuildContext context) => TeamStatDialog(
            team: team,
            playerService: playerService,
            teamService: teamService,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            Theme.of(context).colorScheme.secondary,
          ),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                CustomProperties.borderRadius,
              ),
              side: BorderSide.none,
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
            const EdgeInsets.only(right: 0, left: 0),
          ),
        ),
        onPressed: () => _showStatDialog(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                key: const ValueKey('apiminiplayerwidget'),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    team.players!
                        .map(
                          (playerId) => Flexible(
                            child: APIMiniPlayerWidget(
                              key: ValueKey('apiminiplayerwidget-$playerId'),
                              onTap: () {},
                              playerId: playerId,
                              displayImage: true,
                              playerService: playerService,
                            ),
                          ),
                        )
                        .toList()
                        .cast<Widget>(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: Theme.of(context).cardColor),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        team.name == null || team.name == ''
                            ? AppLocalizations.of(context)!.noName
                            : team.name!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight:
                              team.name == null || team.name == ''
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                          color:
                              team.name == null || team.name == ''
                                  ? Colors.grey
                                  : Theme.of(context).cardColor,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.trophy,
                            size: 13,
                            color: Theme.of(context).cardColor,
                          ),
                          Text(
                            '  ${team.totalWonGames()}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 15),
                          Icon(
                            FontAwesomeIcons.gamepad,
                            size: 13,
                            color: Theme.of(context).cardColor,
                          ),
                          Text(
                            '  ${team.totalPlayedGames()}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
