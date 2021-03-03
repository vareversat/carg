import 'dart:ui';

import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/carg_about_dialog.dart';
import 'package:carg/views/dialogs/credentials_dialog.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

class _UserScreenState extends State<UserScreen> {
  String _errorMessage = 'Vous ne disposez pas de joueur';
  final _playerService = PlayerService();
  Player _player;

  Future<void> _showUpdatePlayerDialog() async {
    var message = await showDialog(
        context: context,
        child: PlayerInfoDialog(player: _player, isEditing: true));
    if (message != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content:
            Text(message, style: CustomTextStyle.snackBarTextStyle(context)),
      ));
    }
  }

  Future<void> _showCreateCredentials() async {
    var message = await showDialog(
        context: context,
        child:
            CredentialsDialog(credentialsStatus: CredentialsStatus.CREATING));
    if (message != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content:
            Text(message, style: CustomTextStyle.snackBarTextStyle(context)),
      ));
    }
  }

  Future<void> _showUpdateCredentials() async {
    var message = await showDialog(
        context: context,
        child: CredentialsDialog(credentialsStatus: CredentialsStatus.EDITING));
    if (message != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content:
            Text(message, style: CustomTextStyle.snackBarTextStyle(context)),
      ));
    }
  }

  Future<void> _signOut() async {
    try {
      if (await Provider.of<AuthService>(context, listen: false)
          .isLocalLogin()) {
        await showDialog(
            context: context,
            child: WarningDialog(
                message:
                    'Vous utilisez actuellement un compte local. Si vous vous '
                    'déconnecter, vous ne pourrez pas récupérer l\'utilisateur actuel',
                title: 'Attention',
                onConfirm: () async => {
                      await Provider.of<AuthService>(context, listen: false)
                          .signOut(),
                      await Navigator.of(context).pushReplacementNamed('/login')
                    },
                color: Theme.of(context).errorColor,
                onConfirmButtonMessage:
                    MaterialLocalizations.of(context).okButtonLabel));
      } else {
        await Provider.of<AuthService>(context, listen: false).signOut();
        await Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  Future<void> _resetPassword() async {
    await showDialog(
        context: context,
        child: WarningDialog(
            message:
                'Un email vous permettant de réinitialiser votre mot de passe va vous être envoyé',
            title: 'Information',
            onConfirm: () async =>
                await Provider.of<AuthService>(context, listen: false)
                    .resetPassword(null),
            color: Theme.of(context).accentColor));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => _player,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mon profil',
                        style: CustomTextStyle.screenHeadLine1(context)),
                    RaisedButton.icon(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        onPressed: () async => await _showUpdatePlayerDialog(),
                        label: Text('Editer'),
                        icon: Icon(
                          FontAwesomeIcons.pen,
                          size: 13,
                        ))
                  ],
                ),
              ),
            ),
            body: FutureBuilder<Player>(
                future: _playerService
                    .getPlayerOfUser(
                        Provider.of<AuthService>(context, listen: false)
                            .getConnectedUserId())
                    .catchError(
                        (onError) => {_errorMessage = onError.toString()}),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SpinKitThreeBounce(
                            size: 20,
                            itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                  decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                              ));
                            }));
                  }
                  if (snapshot.connectionState == ConnectionState.none &&
                          snapshot.hasData == null ||
                      snapshot.data == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ErrorMessageWidget(message: _errorMessage),
                        RaisedButton.icon(
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            onPressed: () async => _signOut(),
                            label: Text('Connexion',
                                style: TextStyle(fontSize: 14)),
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
                  return Consumer<Player>(
                      builder: (context, player, _) => SingleChildScrollView(
                              child: (Column(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 4,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    player.profilePicture)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          )),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Center(
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 25),
                                            child: Text(_player.userName,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(fontSize: 40),
                                                textAlign: TextAlign.center)),
                                      ),
                                    )
                                  ]),
                            ),
                            Divider(thickness: 1.5),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('- STATISTIQUES -',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))),
                            _player.gameStatsList.isNotEmpty
                                ? Column(children: [
                                    _StatCircularChart(
                                        gameStatsList: _player.gameStatsList),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30, bottom: 25),
                                      child: Text(
                                          '-- Pourcentages de victoires totales --',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontStyle: FontStyle.italic)),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                              child: Column(children: [
                                            Icon(FontAwesomeIcons.trophy,
                                                size: 20),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                    _player
                                                        .totalWonGames()
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            Text('Victoires',
                                                style: TextStyle(fontSize: 20))
                                          ])),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 6, // Underline thickness
                                            ))),
                                            child: Text(
                                                '${_player.totalWinPercentage()} %',
                                                style: TextStyle(
                                                    fontSize: 35,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Flexible(
                                              child: Column(children: [
                                            Icon(FontAwesomeIcons.gamepad,
                                                size: 20),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                    _player
                                                        .totalPlayedGames()
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            Text('Parties',
                                                style: TextStyle(fontSize: 20))
                                          ]))
                                        ]),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30, bottom: 25),
                                      child: Text(
                                          '-- Pourcentages de victoires par jeu de cartes --',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  fontStyle: FontStyle.italic)),
                                    ),
                                    Wrap(
                                        runSpacing: 20,
                                        spacing: 10,
                                        alignment: WrapAlignment.spaceEvenly,
                                        children: _player.gameStatsList
                                            .map(
                                              (stat) => ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 140,
                                                      maxHeight: 140),
                                                  child: _StatGauge(
                                                      gameStats: stat)),
                                            )
                                            .toList()
                                            .cast<Widget>())
                                  ])
                                : Text('Pas encore de statistiques'),
                            Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(children: [
                                  FutureBuilder<bool>(
                                      future: Provider.of<AuthService>(context,
                                              listen: true)
                                          .isLocalLogin(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.data != null) {
                                          if (snapshot.data) {
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: RaisedButton.icon(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    textColor: Theme.of(context)
                                                        .cardColor,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                18.0)),
                                                    onPressed: () async =>
                                                        _showCreateCredentials(),
                                                    label: Flexible(
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(
                                                                12.0),
                                                            child: Text('Créer un compte',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(fontSize: Theme.of(context).textTheme.bodyText1.fontSize)))),
                                                    icon: FaIcon(FontAwesomeIcons.userPlus, size: 15)));
                                          } else {
                                            return Column(children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton.icon(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      textColor:
                                                          Theme.of(context)
                                                              .cardColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18.0)),
                                                      onPressed: () async =>
                                                          await _showUpdateCredentials(),
                                                      label: Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Text(
                                                              'Changer mon adresse email',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText1
                                                                      .fontSize)),
                                                        ),
                                                      ),
                                                      icon: Icon(
                                                          FontAwesomeIcons.at,
                                                          size: 20))),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton.icon(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      textColor: Theme.of(context)
                                                          .cardColor,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  18.0)),
                                                      onPressed: () async =>
                                                          _resetPassword(),
                                                      label: Flexible(
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                      12.0),
                                                              child: Text(
                                                                  'Changer mon mot de passe',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize: Theme.of(context).textTheme.bodyText1.fontSize)))),
                                                      icon: Icon(
                                                        FontAwesomeIcons.lock,
                                                        size: 20,
                                                      )))
                                            ]);
                                          }
                                        }
                                        return Container();
                                      }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton.icon(
                                              color: Colors.black,
                                              textColor:
                                                  Theme.of(context).cardColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0)),
                                              onPressed: () async =>
                                                  await showGeneralDialog(
                                                      transitionDuration: Duration(
                                                          milliseconds: 300),
                                                      context: context,
                                                      pageBuilder: (BuildContext context,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secondaryAnimation) {
                                                        return CargAboutDialog();
                                                      }),
                                              label: Flexible(
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(
                                                          12.0),
                                                      child: Text('A propos',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 15)))),
                                              icon: Icon(
                                                FontAwesomeIcons.infoCircle,
                                                size: 20,
                                              ))),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton.icon(
                                              color:
                                                  Theme.of(context).errorColor,
                                              textColor:
                                                  Theme.of(context).cardColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0)),
                                              onPressed: () async => _signOut(),
                                              label: Flexible(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Text('Déconnexion',
                                                          style: TextStyle(
                                                              fontSize: 15)))),
                                              icon: Icon(
                                                FontAwesomeIcons.signOutAlt,
                                                size: 20,
                                              )))
                                    ],
                                  ),
                                ]))
                          ]))));
                })));
  }
}

class _StatGauge extends StatelessWidget {
  final GameStats gameStats;

  const _StatGauge({this.gameStats});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SfRadialGauge(
        title: GaugeTitle(
            text: gameStats.gameType.name,
            textStyle: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    axisValue: 50,
                    positionFactor: 0,
                    widget: Text(
                      '${gameStats.winPercentage().toString()}%',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    )),
                GaugeAnnotation(
                    axisValue: 50,
                    positionFactor: 0.3,
                    widget: Text(
                      '${gameStats.wonGames} | ${gameStats.playedGames}',
                      style: TextStyle(fontSize: 12),
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
                    endValue: gameStats.winPercentage(),
                    color: Theme.of(context).primaryColor),
                GaugeRange(
                    startValue: gameStats.winPercentage(),
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
  final List<GameStats> gameStatsList;

  const _StatCircularChart({this.gameStatsList});

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        tooltipBehavior: TooltipBehavior(
            enable: true, textStyle: Theme.of(context).textTheme.bodyText1),
        title: ChartTitle(
            text: '-- Distributions des parties --',
            alignment: ChartAlignment.center,
            textStyle: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontStyle: FontStyle.italic)),
        series: <CircularSeries>[
          DoughnutSeries<GameStats, String>(
            radius: '110%',
            innerRadius: '70%',
            dataSource: gameStatsList,
            xValueMapper: (GameStats data, _) => data.gameType.name,
            yValueMapper: (GameStats data, _) => data.playedGames,
          )
        ],
        legend: Legend(
            textStyle: Theme.of(context).textTheme.bodyText2,
            position: LegendPosition.right,
            isVisible: true,
            toggleSeriesVisibility: false));
  }
}
