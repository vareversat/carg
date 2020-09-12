import 'package:carg/models/player/player.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/views/dialogs/edit_player_dialog.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PlayerListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayerListScreenState();
  }
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  final PlayerService _playerService = PlayerService();
  final _searchTextController = TextEditingController();
  String _errorMessage;
  String searchQuery = '';

  void _resetSearch() {
    setState(() {
      _searchTextController.text = '';
      searchQuery = '';
    });
  }

  void _searchPlayer() {
    setState(() {
      searchQuery = _searchTextController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            title:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Joueurs',
                    style: Theme.of(context).textTheme.headline1),
                RaisedButton.icon(
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    onPressed: () async => {await showDialog(context: context, child: EditPlayerDialog(player: null,))},
                    label: Text('Ajouter un joueur',
                        style: TextStyle(fontSize: 14)),
                    icon: FaIcon(
                      FontAwesomeIcons.plusCircle,
                      size: 15,
                    ))
              ],
            )
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: deviceSize.width * 0.5,
                    child: TextFormField(
                        onFieldSubmitted: (term) => _searchPlayer(),
                        controller: _searchTextController,
                        textInputAction: TextInputAction.search,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          labelText: 'Rechercher...',
                        )),
                  ),
                  Container(
                    child: MaterialButton(
                      onPressed: () => _resetSearch(),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Icon(Icons.close),
                      padding: EdgeInsets.all(8),
                      shape: CircleBorder(),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: FutureBuilder<List<Player>>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.none &&
                          snapshot.hasData == null ||
                      snapshot.data == null) {
                    return ErrorMessageWidget(message: _errorMessage);
                  }
                  if (snapshot.data.isEmpty) {
                    return Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Pas encore de joueurs ',
                                style: TextStyle(fontSize: 18)),
                            Icon(Icons.person),
                            Text(' enregistrés', style: TextStyle(fontSize: 18))
                          ]),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChangeNotifierProvider.value(
                          value: snapshot.data[index],
                          child: PlayerWidget(player: snapshot.data[index]),
                        );
                      });
                },
                future: _playerService
                    .getAllPlayers(query: searchQuery)
                    .catchError(
                        (onError) => {_errorMessage = onError.toString()}),
              ),
            ),
          ],
        ));
  }
}
