import 'package:carg/models/team.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/services/team/abstract_team_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/widgets/team_stat_widget.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class TeamListTab extends StatefulWidget {
  final AbstractTeamService teamService;
  final AbstractPlayerService playerService;

  const TeamListTab(
      {Key? key, required this.teamService, required this.playerService})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TeamListTabWidget();
  }
}

class _TeamListTabWidget extends State<TeamListTab> {
  late final String? _playerId;
  final _pagingController = PagingController<int, Team>(
    firstPageKey: 1,
  );

  Future<void> _fetchTeams(int pageKey) async {
    try {
      final newGames = await widget.teamService
          .getAllTeamOfPlayer(_playerId, CustomProperties.pageSize);
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
    widget.teamService.resetLastPointedDocument();
    _playerId =
        Provider.of<AuthService>(context, listen: false).getPlayerIdOfUser();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchTeams(pageKey);
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
          widget.teamService.resetLastPointedDocument(),
          _pagingController.refresh()
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
      color: Theme.of(context).cardColor,
      displacement: 20,
      strokeWidth: 3,
      child: PagedListView<int, Team>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Team>(
            firstPageErrorIndicatorBuilder: (_) =>
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Center(
                  child: Text(
                'Erreur rencontrée lors du chargement de la page.',
                textAlign: TextAlign.center,
              )),
              ElevatedButton.icon(
                  onPressed: () => {
                        widget.teamService.resetLastPointedDocument(),
                        _pagingController.refresh()
                      },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Rafraîchir'))
            ]),
            noItemsFoundIndicatorBuilder: (_) =>
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Center(child: Text('Pas encore de parties')),
              ElevatedButton.icon(
                  onPressed: () => {
                        widget.teamService.resetLastPointedDocument(),
                        _pagingController.refresh()
                      },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Rafraîchir'))
            ]),
            noMoreItemsIndicatorBuilder: (_) => const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text('♦ ️♣ ♥ ♠ '))),
            itemBuilder: (BuildContext context, Team team, int index) {
              return TeamStatWidget(
                  key: ValueKey('teamStatWidget-${team.id}'),
                  team: team,
                  playerService: widget.playerService,
                  teamService: widget.teamService);
            },
          )),
    );
  }
}
