import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/views/widgets/ad_banner_widget.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:carg/views/widgets/players/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PlayerListTab extends StatefulWidget {
  final AbstractPlayerService playerService;
  final bool? myPlayers;

  const PlayerListTab({Key? key, required this.playerService, this.myPlayers})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerListTabWidget();
  }
}

class _PlayerListTabWidget extends State<PlayerListTab> {
  String? _errorMessage;
  String searchQuery = '';
  late bool isAdmin;
  final TextEditingController textEditingController = TextEditingController();

  void _resetSearch() {
    setState(() {
      textEditingController.text = '';
      searchQuery = '';
    });
  }

  void _searchPlayer() {
    setState(() {
      searchQuery = textEditingController.text;
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
        body: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: deviceSize.width * 0.5,
              child: TextFormField(
                  onFieldSubmitted: (term) => _searchPlayer(),
                  controller: textEditingController,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    labelText: 'Rechercher...',
                  )),
            ),
            MaterialButton(
              key: const ValueKey('resetSearchButton'),
              onPressed: () => _resetSearch(),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
              child: const Icon(Icons.close),
            ),
            SizedBox(
              width: 35,
              child: SvgPicture.asset('assets/images/search_by_algolia.svg'),
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(4.0),
        child: AdBannerWidget(),
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
                  key: const ValueKey('noPlayersMessage'),
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
                      builder: (context, playerData, child) => PlayerWidget(
                          player: playerData,
                          key: ValueKey("playerWidget-$index"))),
                );
              });
        },
        future: widget.playerService.searchPlayers(
            query: searchQuery,
            myPlayers: widget.myPlayers,
            currentPlayer:
                Provider.of<AuthService>(context, listen: false).getPlayer()),
      ))
    ]));
  }
}
