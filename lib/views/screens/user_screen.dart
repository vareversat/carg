import 'dart:ui';

import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/carg_about_dialog.dart';
import 'package:carg/views/dialogs/credentials_dialog.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:carg/views/dialogs/warning_dialog.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore: import_of_legacy_library_into_null_safe
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

  Future _showUpdatePlayerDialog() async {
    var message = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            PlayerInfoDialog(player: _player, isEditing: true));
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
        builder: (BuildContext context) =>
            CredentialsDialog(credentialsStatus: CredentialsStatus.CREATING));
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
        builder: (BuildContext context) =>
            CredentialsDialog(credentialsStatus: CredentialsStatus.EDITING));
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            builder: (BuildContext context) => WarningDialog(
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
        builder: (BuildContext context) => WarningDialog(
            message:
                'Un email vous permettant de réinitialiser votre mot de passe va vous être envoyé',
            title: 'Information',
            onConfirm: () async =>
                await Provider.of<AuthService>(context, listen: false)
                    .resetPassword(null),
            color: Theme.of(context).accentColor));
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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
                        onPressEdit: _showUpdatePlayerDialog,
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
                                onPressEdit: _showUpdatePlayerDialog,
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
                                              spacing: 10,
                                              alignment:
                                                  WrapAlignment.spaceEvenly,
                                              children: _player!.gameStatsList!
                                                  .map(
                                                    (stat) => ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 140,
                                                                maxHeight: 140),
                                                        child: _StatGauge(
                                                            gameStats: stat)),
                                                  )
                                                  .toList()
                                                  .cast<Widget>()),
                                        )
                                      ])
                                    : Center(child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Pas encore de statistiques', style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: _ButtonsBlockWidget(
                                        onSignOut: _signOut,
                                        onResetPassword: _resetPassword,
                                        onShowCreateCredentials:
                                            _showCreateCredentials,
                                        onShowUpdateCredentials:
                                            _showUpdateCredentials))
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
            innerRadius: '70%',
            dataSource: gameStatsList!,
            xValueMapper: (GameStats data, _) => data.gameType.name,
            yValueMapper: (GameStats data, _) => data.playedGames,
          )
        ],
        legend: Legend(
            iconHeight: 20,
            iconWidth: 20,
            textStyle: Theme.of(context).textTheme.bodyText2!,
            position: LegendPosition.bottom,
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
            label: Text('Éditer'),
            icon: Icon(
              FontAwesomeIcons.pen,
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
          width: 6, // Underline thickness
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

class _ButtonsBlockWidget extends StatelessWidget {
  final Function onSignOut;
  final Function onResetPassword;
  final Function onShowCreateCredentials;
  final Function onShowUpdateCredentials;

  const _ButtonsBlockWidget(
      {required this.onSignOut,
      required this.onResetPassword,
      required this.onShowCreateCredentials,
      required this.onShowUpdateCredentials});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder<bool>(
          future:
              Provider.of<AuthService>(context, listen: true).isLocalLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              if (snapshot.data!) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).accentColor),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).cardColor),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        CustomProperties.borderRadius)))),
                        onPressed: () async => onShowCreateCredentials(),
                        label: Flexible(
                            child:
                                Padding(padding: const EdgeInsets.all(12.0), child: Text('Créer un compte', textAlign: TextAlign.center))),
                        icon: FaIcon(FontAwesomeIcons.userPlus, size: 13)));
              } else {
                return Column(children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).accentColor),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).cardColor),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          CustomProperties.borderRadius)))),
                          onPressed: () async =>
                              await onShowUpdateCredentials(),
                          label: Text('Changer mon adresse email',
                              textAlign: TextAlign.center),
                          icon: Icon(FontAwesomeIcons.at, size: 13))),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).accentColor),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).cardColor),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          CustomProperties.borderRadius)))),
                          onPressed: () async => onResetPassword(),
                          label: Text('Changer mon mot de passe',
                              textAlign: TextAlign.center),
                          icon: Icon(
                            FontAwesomeIcons.lock,
                            size: 13,
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
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).cardColor),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  CustomProperties.borderRadius)))),
                  onPressed: () async => await showGeneralDialog(
                      transitionDuration: Duration(milliseconds: 300),
                      context: context,
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return CargAboutDialog();
                      }),
                  label: Text('A propos', textAlign: TextAlign.center),
                  icon: Icon(
                    FontAwesomeIcons.infoCircle,
                    size: 13,
                  ))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).errorColor),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).cardColor),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  CustomProperties.borderRadius)))),
                  onPressed: () async => onSignOut(),
                  label: Text('Déconnexion'),
                  icon: Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 13,
                  )))
        ],
      ),
    ]);
  }
}
