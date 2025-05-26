import 'package:carg/models/player.dart';
import 'package:carg/services/player/abstract_player_service.dart';
import 'package:carg/views/dialogs/player_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class APIMiniPlayerWidget extends StatelessWidget {
  final String? playerId;
  final bool displayImage;
  final bool showLoading;
  final double size;
  final bool isSelected;
  final Function? onTap;
  final Color? selectedColor;
  final String additionalText;
  final AbstractPlayerService playerService;

  const APIMiniPlayerWidget({
    super.key,
    required this.playerId,
    required this.displayImage,
    required this.playerService,
    this.showLoading = true,
    this.size = 15,
    this.isSelected = false,
    this.onTap,
    this.selectedColor,
    this.additionalText = '',
  });

  Future _showEditPlayerDialog(BuildContext context, Player? player) async {
    if (player != null) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => PlayerInfoDialog(
          player: player,
          playerService: playerService,
          isNewPlayer: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Player?>(
      builder: (context, snapshot) {
        Widget? child;
        if (snapshot.connectionState == ConnectionState.waiting) {
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: showLoading
                ? SpinKitThreeBounce(
                    size: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      );
                    },
                  )
                : const SizedBox(),
          );
        }
        if (snapshot.hasData) {
          child = Material(
            child: InputChip(
              selected: isSelected,
              selectedColor:
                  selectedColor ?? Theme.of(context).colorScheme.secondary,
              onPressed:
                  onTap as void Function()? ??
                  () => {_showEditPlayerDialog(context, snapshot.data)},
              avatar: (snapshot.data!.profilePicture != '' && displayImage)
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data!.profilePicture),
                        ),
                      ),
                    )
                  : null,
              label: Text(
                snapshot.data!.userName + additionalText,
                style: TextStyle(fontSize: size),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }
        if (!snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          child = Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InputChip(
                avatar: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
                label: Text(AppLocalizations.of(context)!.errorPlayerNotFound),
              ),
            ),
          );
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: child,
        );
      },
      future: playerService.get(playerId),
    );
  }
}
