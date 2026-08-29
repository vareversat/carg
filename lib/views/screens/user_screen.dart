import 'package:carg/helpers/custom_route.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/game/game_type.dart';
import 'package:carg/models/game_stats.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/screens/settings_screen.dart';
import 'package:carg/views/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide CornerStyle;
import 'package:syncfusion_flutter_gauges/gauges.dart'
    show
        SfRadialGauge,
        RadialAxis,
        GaugeAnnotation,
        GaugePointer,
        GaugeSizeUnit,
        AxisLineStyle,
        RangePointer,
        CornerStyle;

class UserScreen extends StatefulWidget {
  static const routeName = '/user';

  const UserScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserScreenState();
  }
}

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  String? _errorMessage;
  Player? _player;
  final _playerService = PlayerService();
  late Animation<Offset> _opacityAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _animationController;

  Future _showSettingsScreen() async {
    if (_player != null) {
      await Navigator.push(
        context,
        CustomRouteFade(
          builder: (context) =>
              SettingsScreen(player: _player!, playerService: PlayerService()),
        ),
      );
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
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _opacityAnimation =
        Tween<Offset>(
          begin: const Offset(0.0, -0.5),
          end: const Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.6, curve: Curves.easeInOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutBack),
      ),
    );
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
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Player?>(
        future: _playerService
            .getPlayerOfUser(
              Provider.of<AuthService>(
                context,
                listen: false,
              ).getConnectedUserId(),
            )
            .catchError(
              // ignore: return_of_invalid_type_from_catch_error
              (onError) => {_errorMessage = onError.toString()},
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingView(context);
          }
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.data == null) {
            return _buildErrorView(context);
          }
          if (snapshot.data == null) {
            return _buildNoPlayerView(context);
          }

          _player = snapshot.data;
          return _buildUserProfileView(context, _player!);
        },
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: false,
          forceElevated: true,
          expandedHeight: 250,
          collapsedHeight: 140,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.loading,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ErrorMessageWidget(
            message:
                _errorMessage ??
                AppLocalizations.of(context)!.youDontHaveAnyPlayer,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  CustomProperties.borderRadius,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async => _signOut(),
            label: Text(
              AppLocalizations.of(context)!.connection,
              style: const TextStyle(fontSize: 16),
            ),
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPlayerView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.person_off,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noPlayerYet,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileView(BuildContext context, Player player) {
    return ChangeNotifierProvider.value(
      value: player,
      child: Consumer<Player>(
        builder: (context, player, _) => RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: CustomScrollView(
            slivers: [
              _buildProfileHeader(context, player),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    if (player.gameStatsList!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildOverallStatsCard(context, player),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        context,
                        AppLocalizations.of(context)!.winPercentage,
                      ),
                      const SizedBox(height: 16),
                      _buildWinPercentageCharts(context, player),
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        context,
                        AppLocalizations.of(context)!.gameDistribution,
                      ),
                      const SizedBox(height: 16),
                      _buildGameDistributionChart(context, player),
                      const SizedBox(height: 32),
                    ] else ...[
                      const SizedBox(height: 24),
                      _buildNoStatsView(context),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Player player) {
    return SliverAppBar(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(CustomProperties.borderRadius),
          bottomRight: Radius.circular(CustomProperties.borderRadius),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      automaticallyImplyLeading: false,
      floating: true,
      pinned: true,
      forceElevated: true,
      expandedHeight: 250,
      collapsedHeight: 140,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: _PlayerUsernameAndProfilePictureWidget(
          player: player,
          animation: _opacityAnimation,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: _showSettingsScreen,
          tooltip: AppLocalizations.of(context)!.settings,
        ),
      ],
    );
  }

  Widget _buildOverallStatsCard(BuildContext context, Player player) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CustomProperties.borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _WonPlayedWidget(player: player),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildWinPercentageCharts(BuildContext context, Player player) {
    return SlideTransition(
      position:
          Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
            ),
          ),
      child: SizedBox(
        height: 220,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: player.gameStatsList!
              .map(
                (stat) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 180,
                    child: _StatGauge(gameStats: stat),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildGameDistributionChart(BuildContext context, Player player) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CustomProperties.borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 300,
            child: _StatCircularChart(gameStatsList: player.gameStatsList),
          ),
        ),
      ),
    );
  }

  Widget _buildNoStatsView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noStatisticYet,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatGauge extends StatelessWidget {
  final GameStats? gameStats;

  const _StatGauge({this.gameStats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CustomProperties.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              gameStats!.gameType.name,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    radiusFactor: 0.9,
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        angle: 90,
                        positionFactor: 0,
                        widget: Text(
                          '${gameStats!.winPercentage().toString()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      GaugeAnnotation(
                        angle: 90,
                        positionFactor: 0.2,
                        widget: Text(
                          '${gameStats!.wonGames} - ${gameStats!.playedGames}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                    startAngle: 140,
                    endAngle: 140 + 260,
                    minimum: 0,
                    maximum: 100,
                    showLabels: false,
                    showTicks: false,
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.2,
                      color: Theme.of(context).colorScheme.outline,
                      thicknessUnit: GaugeSizeUnit.factor,
                      cornerStyle: CornerStyle.bothCurve,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: gameStats!.winPercentage().toDouble(),
                        width: 0.2,
                        sizeUnit: GaugeSizeUnit.factor,
                        color: Theme.of(context).colorScheme.primary,
                        cornerStyle: CornerStyle.bothCurve,
                      ),
                    ],
                  ),
                ],
                enableLoadingAnimation: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCircularChart extends StatelessWidget {
  final List<GameStats>? gameStatsList;

  const _StatCircularChart({this.gameStatsList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCircularChart(
        tooltipBehavior: TooltipBehavior(enable: true, borderWidth: 1),
        series: <CircularSeries>[
          DoughnutSeries<GameStats, String?>(
            radius: '100%',
            innerRadius: '60%',
            dataSource: gameStatsList!,
            xValueMapper: (GameStats data, _) => data.gameType.name,
            yValueMapper: (GameStats data, _) => data.playedGames,
            pointColorMapper: (GameStats data, _) =>
                _getColorForGameType(context, data.gameType),
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
            ),
          ),
        ],
        legend: Legend(
          iconHeight: 16,
          iconWidth: 16,
          position: LegendPosition.left,
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
      ),
    );
  }

  Color _getColorForGameType(BuildContext context, GameType gameType) {
    final colors = Theme.of(context).colorScheme;
    switch (gameType) {
      case GameType.COINCHE:
        return colors.primary;
      case GameType.BELOTE:
        return colors.secondary;
      case GameType.TAROT:
        return colors.tertiary;
      case GameType.CONTREE:
        return colors.error;
      default:
        return colors.outline;
    }
  }
}

class _PlayerUsernameAndProfilePictureWidget extends StatelessWidget {
  final Player? player;
  final Animation<Offset> animation;

  const _PlayerUsernameAndProfilePictureWidget({
    this.player,
    required this.animation,
  });

  String? _getProfilePicture(Player player) {
    try {
      final profilePic = player.profilePicture;
      if (profilePic.isNotEmpty) {
        return profilePic;
      }
      return Player.defaultProfilePicture;
    } catch (e) {
      return Player.defaultProfilePicture;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (player == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SlideTransition(
          position: animation,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: Theme.of(context).colorScheme.surface,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.shadow.withValues(alpha: .3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.shadow.withValues(alpha: .1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
              image: _getProfilePicture(player!) != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_getProfilePicture(player!)!),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          player!.userName.toString(),
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _WonPlayedWidget extends StatelessWidget {
  final Player? player;

  const _WonPlayedWidget({this.player});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatColumn(
          context,
          FontAwesomeIcons.trophy,
          player!.totalWonGames().toString(),
          AppLocalizations.of(context)!.victories,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${player!.totalWinPercentage()}%',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        _buildStatColumn(
          context,
          Icons.videogame_asset,
          player!.totalPlayedGames().toString(),
          AppLocalizations.of(context)!.games,
        ),
      ],
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
