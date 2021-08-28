import 'dart:ui';

import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/screens/register/register_screen.dart';
import 'package:carg/views/screens/settings_screen.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user';

  @override
  State<StatefulWidget> createState() {
    return _UserScreenState();
  }
}

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  String _errorMessage = 'Vous ne disposez pas de joueur';
  Player? _player;
  final _playerService = PlayerService();
  late Animation<Offset> _opacityAnimation;
  late AnimationController _animationController;

  Future _showSettingsScreen() async {
    if (_player != null) {
      await Navigator.push(
          context,
          CustomRouteFade(
              builder: (context) => SettingsScreen(
                    player: _player!,
                  )));
    }
  }

  Future<void> _signOut() async {
    try {
      await Provider.of<AuthService>(context, listen: false).signOut(context);
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1100));
    _opacityAnimation = Tween<Offset>(
            begin: const Offset(0.0, -1.0), end: Offset(0.0, 0.0))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Player?>(
            future: _playerService
                .getPlayerOfUser(
                    Provider.of<AuthService>(context, listen: false)
                        .getConnectedUserId())
                .catchError(
                    // ignore: return_of_invalid_type_from_catch_error
                    (onError) => {_errorMessage = onError.toString()}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      forceElevated: true,
                      expandedHeight: 200,
                      collapsedHeight: 140,
                      title: _AppBarTitle(
                        onPressEdit: _showSettingsScreen,
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(''),
                      ),
                    )
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.data == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ErrorMessageWidget(message: _errorMessage),
                    ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).cardColor),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        CustomProperties.borderRadius)))),
                        onPressed: () async => _signOut(),
                        label:
                            Text('Connexion', style: TextStyle(fontSize: 14)),
                        icon: Icon(Icons.arrow_back)),
                  ],
                );
              }
              if (snapshot.data == null) {
                return Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Pas encore de joueur',
                            style: TextStyle(fontSize: 18))
                      ]),
                );
              }
              _player = snapshot.data;
              return ChangeNotifierProvider.value(
                value: _player!,
                child: Consumer<Player>(
                    builder: (context, player, _) => CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              floating: true,
                              pinned: true,
                              forceElevated: true,
                              expandedHeight: 200,
                              collapsedHeight: 140,
                              title: _AppBarTitle(
                                onPressEdit: _showSettingsScreen,
                              ),
                              flexibleSpace: FlexibleSpaceBar(
                                centerTitle: true,
                                title: _PlayerUsernameAndProfilePictureWidget(
                                    player: _player,
                                    animation: _opacityAnimation),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                _player!.gameStatsList!.isNotEmpty
                                    ? Column(children: [
                                        _StatCircularChart(
                                            gameStatsList:
                                                _player!.gameStatsList),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 30),
                                          child: Text(
                                              '-- Pourcentages de victoires --',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      fontStyle:
                                                          FontStyle.italic)),
                                        ),
                                        _WonPlayedWidget(player: _player),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 30),
                                          child: Wrap(
                                              runSpacing: 20,
                                              spacing: 80,
                                              alignment:
                                                  WrapAlignment.spaceEvenly,
                                              children: _player!.gameStatsList!
                                                  .map(
                                                    (stat) => ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 160,
                                                                maxHeight: 160),
                                                        child: _StatGauge(
                                                            gameStats: stat)),
                                                  )
                                                  .toList()
                                                  .cast<Widget>()),
                                        )
                                      ])
                                    : Center(
                                        child: Padding(
                                        padding: const EdgeInsets.all(30),
                                        child: Text(
                                          'Pas encore de statistiques',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ))
                              ]),
                            )
                          ],
                        )),
              );
            }));
  }
}

class _StatGauge extends StatelessWidget {
  final GameStats? gameStats;

  const _StatGauge({this.gameStats});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SfRadialGauge(
        title: GaugeTitle(
            text: gameStats!.gameType.name,
            textStyle: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    axisValue: 50,
                    positionFactor: 0,
                    widget: Text(
                      '${gameStats!.winPercentage().toString()}%',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    )),
                GaugeAnnotation(
                    axisValue: 50,
                    positionFactor: 0.3,
                    widget: Text(
                      '${gameStats!.wonGames} | ${gameStats!.playedGames}',
                      style: TextStyle(fontSize: 15),
                    ))
              ],
              startAngle: 270,
              endAngle: 270,
              interval: 10,
              showLabels: false,
              showTicks: false,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: gameStats!.winPercentage(),
                    color: Theme.of(context).primaryColor),
                GaugeRange(
                    startValue: gameStats!.winPercentage(),
                    endValue: 100,
                    color: Theme.of(context).accentColor),
              ]),
        ],
        enableLoadingAnimation: true,
      ),
    );
  }
}

class _StatCircularChart extends StatelessWidget {
  final List<GameStats>? gameStatsList;

  const _StatCircularChart({this.gameStatsList});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        tooltipBehavior: TooltipBehavior(
            enable: true, textStyle: Theme.of(context).textTheme.bodyText1!),
        title: ChartTitle(
            text: '-- Distributions des parties --',
            alignment: ChartAlignment.center,
            textStyle: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontStyle: FontStyle.italic)),
        series: <CircularSeries>[
          DoughnutSeries<GameStats, String?>(
            radius: '110%',
            innerRadius: '60%',
            dataSource: gameStatsList!,
            xValueMapper: (GameStats data, _) => data.gameType.name,
            yValueMapper: (GameStats data, _) => data.playedGames,
          )
        ],
        legend: Legend(
            iconHeight: 20,
            iconWidth: 20,
            textStyle: Theme.of(context).textTheme.bodyText2!,
            position: LegendPosition.left,
            isVisible: true,
            toggleSeriesVisibility: true));
  }
}

class _PlayerUsernameAndProfilePictureWidget extends StatelessWidget {
  final Player? player;
  final Animation<Offset> animation;

  const _PlayerUsernameAndProfilePictureWidget(
      {this.player, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Flexible(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: SlideTransition(
              position: animation,
              child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2, color: Theme.of(context).cardColor),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(player!.profilePicture)),
                  ))),
        ),
      ),
      Center(
          child: Text(player!.userName!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center))
    ]);
  }
}

class _AppBarTitle extends StatelessWidget {
  final Function onPressEdit;

  const _AppBarTitle({required this.onPressEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Profil', style: CustomTextStyle.screenHeadLine1(context)),
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
            onPressed: () async => await onPressEdit(),
            label: Text('Paramètres'),
            icon: Icon(
              FontAwesomeIcons.cogs,
              size: 13,
            ))
      ],
    );
  }
}

class _WonPlayedWidget extends StatelessWidget {
  final Player? player;

  const _WonPlayedWidget({this.player});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Flexible(
          child: Column(children: [
        Icon(FontAwesomeIcons.trophy, size: 20),
        Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(player!.totalWonGames().toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Text('Victoires', style: TextStyle(fontSize: 20))
      ])),
      Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 6,
        ))),
        child: Text('${player!.totalWinPercentage()} %',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
      ),
      Flexible(
          child: Column(children: [
        Icon(FontAwesomeIcons.gamepad, size: 20),
        Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(player!.totalPlayedGames().toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Text('Parties', style: TextStyle(fontSize: 20))
      ]))
    ]);
  }
}
