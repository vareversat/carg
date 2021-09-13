import 'package:carg/models/player.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/players/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
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
  String? _errorMessage;
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Joueurs',
                      style: CustomTextStyle.screenHeadLine1(context)),
                  ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).cardColor),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      CustomProperties.borderRadius)))),
                      onPressed: () async {
                            var result = await showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    PlayerInfoDialog(
                                        player: Player(owned: true), playerService: _playerService, isNewPlayer: true));
                            if (result != null) {
                              InfoSnackBar.showSnackBar(context, result);
                            }
                          },
                      label: Text('Nouveau joueur',
                          style: TextStyle(fontSize: 14)),
                      icon: FaIcon(
                        FontAwesomeIcons.plusCircle,
                        size: 15,
                      ))
                ],
              )),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
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
                      padding: EdgeInsets.zero,
                      shape: CircleBorder(),
                      child: Icon(Icons.close),
                    ),
                  ),
                  Container(
                    width: 35,
                    child:
                        SvgPicture.asset('assets/images/search_by_algolia.svg'),
                  ),
                ],
              ),
            ),
            Flexible(
              child: FutureBuilder<List<Player>>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.none ||
                      snapshot.data == null) {
                    return ErrorMessageWidget(message: _errorMessage);
                  }
                  if (snapshot.data!.isEmpty) {
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
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChangeNotifierProvider.value(
                          value: snapshot.data![index],
                          child: Consumer<Player>(
                              builder: (context, playerData, child) =>
                                  PlayerWidget(player: playerData)),
                        );
                      });
                },
                future: _playerService
                    .searchPlayers(
                        query: searchQuery,
                        playerId:
                            Provider.of<AuthService>(context, listen: false)
                                .getPlayerIdOfUser())
                    .catchError(
                        // ignore: return_of_invalid_type_from_catch_error
                        (error) => {_errorMessage = error.toString()}),
              ),
            ),
          ],
        ));
  }
}
