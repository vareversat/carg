import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/game/game_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/widgets/belote_game_widget.dart';
import 'package:carg/views/widgets/tarot_game_widget.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class GameListWidget extends StatefulWidget {
  final GameService gameService;

  GameListWidget({required this.gameService});

  @override
  State<StatefulWidget> createState() {
    return _GameListWidgetState(gameService);
  }
}

class _GameListWidgetState extends State<GameListWidget> {
  final GameService _gameService;
  late final String? _playerId;
  final _pagingController = PagingController<int, Game>(
    firstPageKey: 1,
  );

  _GameListWidgetState(this._gameService);

  Future<void> _fetchGames(int pageKey) async {
    try {
      final newGames = await _gameService.getAllGamesOfPlayerPaginated(
          _playerId, CustomProperties.pageSize);
      final isLastPage = newGames.length < CustomProperties.pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newGames);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newGames, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _gameService.lastFetchGameDocument = null;
    _playerId =
        Provider.of<AuthService>(context, listen: false).getPlayerIdOfUser();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchGames(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => {
          _gameService.lastFetchGameDocument = null,
          _pagingController.refresh()
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
      color: Theme.of(context).cardColor,
      displacement: 20,
      strokeWidth: 3,
      child: PagedListView<int, Game>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Game>(
            firstPageErrorIndicatorBuilder: (_) =>
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                  child: Text(
                'Erreur rencontrée lors du chargement de la page.',
                textAlign: TextAlign.center,
              )),
              ElevatedButton.icon(
                  onPressed: () => {
                        _gameService.lastFetchGameDocument = null,
                        _pagingController.refresh()
                      },
                  icon: Icon(Icons.refresh),
                  label: Text('Rafraîchir'))
            ]),
            noItemsFoundIndicatorBuilder: (_) =>
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(child: Text('Pas encore de parties')),
              ElevatedButton.icon(
                  onPressed: () => {
                        _gameService.lastFetchGameDocument = null,
                        _pagingController.refresh()
                      },
                  icon: Icon(Icons.refresh),
                  label: Text('Rafraîchir'))
            ]),
            noMoreItemsIndicatorBuilder: (_) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('♦ ️♣ ♥ ♠ '))),
            itemBuilder: (BuildContext context, Game game, int index) {
              if (game.gameType != GameType.TAROT) {
                return BeloteWidget(
                  beloteGame: game as Belote,
                );
              } else {
                return TarotGameWidget(tarotGame: game as Tarot);
              }
            },
          )),
    );
  }
}
