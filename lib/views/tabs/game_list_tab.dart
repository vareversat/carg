import 'package:carg/const.dart';
import 'package:carg/models/game/belote_game.dart';
import 'package:carg/models/game/game.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game/tarot.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/game/abstract_game_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/widgets/ad_banner_widget.dart';
import 'package:carg/views/widgets/belote_widget.dart';
import 'package:carg/views/widgets/tarot_widget.dart';
import 'package:flutter/material.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class GameListTabWidget extends StatefulWidget {
  final AbstractGameService gameService;

  const GameListTabWidget({super.key, required this.gameService});

  @override
  State<StatefulWidget> createState() {
    return _GameListTabWidgetState();
  }
}

class _GameListTabWidgetState extends State<GameListTabWidget> {
  late final String? _playerId;
  PagingState<int, Game> _pagingState = PagingState();

  _GameListTabWidgetState();

  void _fetchNextPage() async {
    if (_pagingState.isLoading) return;

    await Future.value();
    setState(() {
      _pagingState = _pagingState.copyWith(isLoading: true, error: null);
    });

    try {
      final newKey = (_pagingState.keys?.last ?? 0) + 1;
      final newGames = await widget.gameService.getAllGamesOfPlayerPaginated(
        _playerId,
        CustomProperties.pageSize,
      );
      final isLastPage = newGames.length < CustomProperties.pageSize;

      setState(() {
        _pagingState = _pagingState.copyWith(
          pages: [...?_pagingState.pages, newGames],
          keys: [...?_pagingState.keys, newKey],
          hasNextPage: !isLastPage,
          isLoading: false,
        );
      });
    } catch (error) {
      setState(() {
        _pagingState = _pagingState.copyWith(error: error, isLoading: false);
      });
    }
  }

  void _reset() async {
    setState(() {
      _pagingState = _pagingState.reset();
    });
  }

  @override
  void initState() {
    widget.gameService.resetLastPointedDocument();
    _playerId =
        Provider.of<AuthService>(context, listen: false).getPlayerIdOfUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          () => Future.sync(() {
            widget.gameService.resetLastPointedDocument();
            _reset();
          }),
      backgroundColor: Theme.of(context).primaryColor,
      color: Theme.of(context).cardColor,
      displacement: 20,
      strokeWidth: 3,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(8.0), child: AdBannerWidget()),
          Flexible(
            child: PagedListView<int, Game>(
              state: _pagingState,
              fetchNextPage: _fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<Game>(
                animateTransitions: true,
                firstPageErrorIndicatorBuilder:
                    (_) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.errorLoadingPage,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed:
                              () => {
                                widget.gameService.resetLastPointedDocument(),
                                _reset(),
                              },
                          icon: const Icon(Icons.refresh),
                          label: Text(AppLocalizations.of(context)!.refresh),
                        ),
                      ],
                    ),
                noItemsFoundIndicatorBuilder:
                    (_) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(AppLocalizations.of(context)!.noGamesYet),
                        ),
                        ElevatedButton.icon(
                          onPressed:
                              () => {
                                widget.gameService.resetLastPointedDocument(),
                                _reset(),
                              },
                          icon: const Icon(Icons.refresh),
                          label: Text(AppLocalizations.of(context)!.refresh),
                        ),
                      ],
                    ),
                noMoreItemsIndicatorBuilder:
                    (_) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text(Const.appBottomList)),
                    ),
                itemBuilder: (BuildContext context, Game game, int index) {
                  if (game.gameType != GameType.TAROT) {
                    return BeloteWidget(beloteGame: game as Belote);
                  } else {
                    return TarotWidget(tarotGame: game as Tarot);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
