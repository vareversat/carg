import 'package:carg/models/team.dart';
import 'package:carg/services/team_service.dart';
import 'package:carg/views/widgets/api_mini_player_widget.dart';
import 'package:flutter/material.dart';

class TeamWidget extends StatefulWidget {
  final String teamId;
  final String title;

  const TeamWidget({@required this.teamId, this.title});

  @override
  State<StatefulWidget> createState() {
    return _TeamWidgetState(teamId, title);
  }
}

class _TeamWidgetState extends State<TeamWidget> {
  final _teamService = TeamService();
  final String _teamId;
  final String _title;
  String _errorMessage = '';

  _TeamWidgetState(this._teamId, this._title);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(children: <Widget>[
        Text(_title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        FutureBuilder<Team>(
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.players.length,
                    itemBuilder: (BuildContext context, int index) {
                      return APIMiniPlayerWidget(
                          playerId: snapshot.data.players[index],
                          displayImage: true);
                    });
              }
              return Center(child: Text(_errorMessage));
            },
            future: _teamService.getTeam(_teamId).catchError((error) => {
              setState(() {
                _errorMessage = error.toString();
              })
            }))
      ]),
    );
  }
}