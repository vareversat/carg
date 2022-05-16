import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/player_color_explanation_dialog.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/players/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PlayerListScreen extends StatefulWidget {
  final AbstractPlayerService playerService;
  final TextEditingController textEditingController;

  const PlayerListScreen(
      {Key? key,
      required this.playerService,
      required this.textEditingController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerListScreenState();
  }
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  String? _errorMessage;
  String searchQuery = '';
  late bool isAdmin;

  void _resetSearch() {
    setState(() {
      widget.textEditingController.text = '';
      searchQuery = '';
    });
  }

  void _searchPlayer() {
    setState(() {
      searchQuery = widget.textEditingController.text;
    });
  }

  @override
  void initState() {
    isAdmin = Provider.of<AuthService>(context, listen: false).getAdmin()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
              actions: [
                PopupMenuButton<String>(
                    key: const ValueKey('playerListPopupMenuButton'),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                              key: const ValueKey('addPlayerPopupMenuItem'),
                              child: const Text('Nouveau joueur',
                                  style: TextStyle(fontSize: 14)),
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
                                    InfoSnackBar.showSnackBar(context, result);
                                  }
                                });
                              }),
                          PopupMenuItem(
                              key: const ValueKey(
                                  'showInformationPopupMenuItem'),
                              child: const Text('Informations',
                                  style: TextStyle(fontSize: 14)),
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
              title: Text('Joueurs',
                  style: CustomTextStyle.screenHeadLine1(context))),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: deviceSize.width * 0.5,
                    child: TextFormField(
                        onFieldSubmitted: (term) => _searchPlayer(),
                        controller: widget.textEditingController,
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          labelText: 'Rechercher...',
                        )),
                  ),
                  MaterialButton(
                    onPressed: () => _resetSearch(),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.close),
                  ),
                  SizedBox(
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.connectionState == ConnectionState.none ||
                      snapshot.data == null) {
                    return ErrorMessageWidget(message: _errorMessage);
                  }
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
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
                                  PlayerWidget(
                                      player: playerData,
                                      key: ValueKey("playerWidget-$index"))),
                        );
                      });
                },
                future: widget.playerService
                    .searchPlayers(
                        query: searchQuery,
                        currentPlayer:
                            Provider.of<AuthService>(context, listen: false)
                                .getPlayer())
                    .catchError(
                        // ignore: return_of_invalid_type_from_catch_error
                        (error) => {_errorMessage = error.toString()}),
              ),
            ),
          ],
        ));
  }
}
