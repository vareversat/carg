import 'package:carg/models/team.dart';
import 'package:carg/services/team_service.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:flutter/material.dart';

class TeamWidget extends StatefulWidget {
  final String teamId;

  const TeamWidget({@required this.teamId});

  @override
  State<StatefulWidget> createState() {
    return _TeamWidgetState(teamId);
  }
}

class _TeamWidgetState extends State<TeamWidget> {
  final String _teamId;
  final TeamService _teamService = TeamService();

  _TeamWidgetState(this._teamId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Team>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return Container(
              alignment: Alignment.center, child: Icon(Icons.error));
        }
        if (snapshot.data != null) {
          return Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Text(snapshot.data.name ?? 'No name',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ),
              Flexible(
                flex: 2,
                child: ListView.builder(
                    itemCount: snapshot.data.players.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                          child: APIMiniPlayerWidget(
                        playerId: snapshot.data.players[index],
                        displayImage: true,
                      ));
                    }),
              )
            ],
          );
        }
        return Text('error');
      },
      future: _teamService.getTeam(_teamId),
    );
  }
}
