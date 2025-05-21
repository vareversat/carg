import 'package:carg/models/team.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:flutter/material.dart';

class TeamWidget extends StatefulWidget {
  final String? teamId;
  final String title;
  final AbstractTeamService teamService;
  final AbstractPlayerService playerService;

  const TeamWidget({
    super.key,
    required this.teamId,
    required this.title,
    required this.teamService,
    required this.playerService,
  });

  @override
  State<StatefulWidget> createState() {
    return _TeamWidgetState();
  }
}

class _TeamWidgetState extends State<TeamWidget> {
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          widget.title,
          key: const ValueKey('textTitleWidget'),
          style: CustomTextStyle.boldAndItalic(context),
        ),
        FutureBuilder<Team?>(
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.players!.length,
                itemBuilder: (BuildContext context, int index) {
                  return APIMiniPlayerWidget(
                    key: ValueKey(
                      'apiminiplayerwidget-${snapshot.data!.players![index]}',
                    ),
                    playerId: snapshot.data!.players![index],
                    displayImage: true,
                    playerService: widget.playerService,
                  );
                },
              );
            }
            return Center(child: Text(_errorMessage));
          },
          // ignore: return_of_invalid_type_from_catch_error
          future: widget.teamService
              .get(widget.teamId)
              // ignore: return_of_invalid_type_from_catch_error
              .catchError((error) => {_errorMessage = error.toString()}),
        ),
      ],
    );
  }
}
