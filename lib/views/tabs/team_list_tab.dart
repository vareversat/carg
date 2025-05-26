import 'package:carg/const.dart';
import 'package:carg/models/team.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/widgets/team_stat_widget.dart';
import 'package:flutter/material.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class TeamListTab extends StatefulWidget {
  final AbstractTeamService teamService;
  final AbstractPlayerService playerService;

  const TeamListTab({
    super.key,
    required this.teamService,
    required this.playerService,
  });

  @override
  State<StatefulWidget> createState() {
    return _TeamListTabWidget();
  }
}

class _TeamListTabWidget extends State<TeamListTab> {
  late final String? _playerId;
  PagingState<int, Team> _pagingState = PagingState();

  void _fetchNextPage() async {
    if (_pagingState.isLoading) return;

    await Future.value();

    setState(() {
      _pagingState = _pagingState.copyWith(isLoading: true, error: null);
    });

    try {
      final newKey = (_pagingState.keys?.last ?? 0) + 1;
      final newTeams = await widget.teamService.getAllTeamOfPlayer(
        _playerId,
        CustomProperties.pageSize,
      );
      final isLastPage = newTeams.length < CustomProperties.pageSize;

      setState(() {
        _pagingState = _pagingState.copyWith(
          pages: [...?_pagingState.pages, newTeams],
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
    widget.teamService.resetLastPointedDocument();
    _playerId = Provider.of<AuthService>(
      context,
      listen: false,
    ).getPlayerIdOfUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(() {
        widget.teamService.resetLastPointedDocument();
        _reset();
      }),
      backgroundColor: Theme.of(context).primaryColor,
      color: Theme.of(context).cardColor,
      displacement: 20,
      strokeWidth: 3,
      child: PagedListView<int, Team>(
        state: _pagingState,
        fetchNextPage: _fetchNextPage,
        builderDelegate: PagedChildBuilderDelegate<Team>(
          animateTransitions: true,
          firstPageErrorIndicatorBuilder: (_) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  AppLocalizations.of(context)!.errorLoadingPage,
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => {
                  widget.teamService.resetLastPointedDocument(),
                  _reset(),
                },
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.refresh),
              ),
            ],
          ),
          noItemsFoundIndicatorBuilder: (_) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text(AppLocalizations.of(context)!.noGamesYet)),
              ElevatedButton.icon(
                onPressed: () => {
                  widget.teamService.resetLastPointedDocument(),
                  _reset(),
                },
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.refresh),
              ),
            ],
          ),
          noMoreItemsIndicatorBuilder: (_) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text(Const.appBottomList)),
          ),
          itemBuilder: (BuildContext context, Team team, int index) {
            return TeamStatWidget(
              key: ValueKey('teamStatWidget-${team.id}'),
              team: team,
              playerService: widget.playerService,
              teamService: widget.teamService,
            );
          },
        ),
      ),
    );
  }
}
