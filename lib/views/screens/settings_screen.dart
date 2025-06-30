import 'package:carg/exceptions/custom_exception.dart';
import 'package:carg/helpers/custom_route.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/carg_about_dialog.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/screens/register/edit_phone_number_screen.dart';
import 'package:carg/views/widgets/remove_ads_list_tile.dart';
import 'package:carg/views/widgets/theme_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  final Player player;
  final PlayerService playerService;

  const SettingsScreen({
    super.key,
    required this.player,
    required this.playerService,
  });

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _profilePictureController =
      TextEditingController();

  Future<void> _savePlayer() async {
    try {
      await widget.playerService.update(widget.player);
      InfoSnackBar.showSnackBar(
        context,
        AppLocalizations.of(context)!.profileSuccessfullyEdited,
      );
    } on CustomException catch (e) {
      InfoSnackBar.showSnackBar(context, e.message);
    }
  }

  Future<void> _onSwitchTileChanged(bool value) async {
    widget.player.gravatarProfilePicture = Provider.of<AuthService>(
      context,
      listen: false,
    ).getConnectedUserEmail();
    widget.player.useGravatarProfilePicture = value;
    _profilePictureController.text = widget.player.profilePicture;
    await _savePlayer();
  }

  @override
  void initState() {
    _profilePictureController.text = widget.player.profilePicture;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: CustomTextStyle.screenHeadLine1(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChangeNotifierProvider.value(
                value: widget.player,
                child: Consumer<Player>(
                  builder: (context, playerData, _) => Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.myProfile,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            playerData.admin
                                ? ClipRRect(
                                    key: const ValueKey('adminLabel'),
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Container(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondaryContainer,
                                      height: 30,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)!.admin,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                              fontSize: 15,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          key: const ValueKey('usernameTextField'),
                          initialValue: playerData.userName,
                          autofillHints: const [AutofillHints.username],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                            labelText: AppLocalizations.of(context)!.username,
                          ),
                          onFieldSubmitted: (value) async {
                            playerData.userName = value;
                            await _savePlayer();
                          },
                        ),
                      ),
                      ListTile(
                        selected: true,
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(playerData.profilePicture),
                            ),
                          ),
                        ),
                        title: TextFormField(
                          key: const ValueKey('imageURLTextField'),
                          controller: _profilePictureController,
                          enabled: !playerData.useGravatarProfilePicture,
                          autofillHints: !playerData.useGravatarProfilePicture
                              ? [AutofillHints.url]
                              : null,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          onChanged: (value) {
                            playerData.profilePicture = value;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                            labelText: AppLocalizations.of(
                              context,
                            )!.profilePicture,
                          ),
                          onFieldSubmitted: (value) async {
                            await _savePlayer();
                          },
                        ),
                      ),
                      SwitchListTile(
                        key: const ValueKey('gravatarSwitchTile'),
                        title: Text(
                          AppLocalizations.of(context)!.useMyGravatar,
                          style: const TextStyle(fontSize: 20),
                        ),
                        onChanged: (bool value) async =>
                            await _onSwitchTileChanged(value),
                        value: playerData.useGravatarProfilePicture,
                      ),
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.appTheme,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      ThemePickerWidget(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.myAccount,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    subtitle: Text(
                      Provider.of<AuthService>(
                            context,
                            listen: false,
                          ).getConnectedUserPhoneNumber() ??
                          AppLocalizations.of(context)!.noPhoneNumberProvided,
                      key: const ValueKey('phoneText'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    selected: true,
                    leading: const Icon(Icons.phone, size: 30),
                    onTap: () => Navigator.push(
                      context,
                      CustomRouteLeftToRight(
                        builder: (context) => const EditPhoneNumberScreen(),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.changeMyPhoneNumber,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextButton(
                    onPressed: () async => await Provider.of<AuthService>(
                      context,
                      listen: false,
                    ).signOut(context),
                    child: Text(
                      AppLocalizations.of(context)!.signOut,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
              const RemoveAdsListTile(key: ValueKey('removeAdsListTile')),
              ListTile(
                key: const ValueKey('aboutButton'),
                subtitle: Text(
                  AppLocalizations.of(context)!.informationAboutTheApp,
                ),
                selected: true,
                leading: const Icon(Icons.info_outline, size: 30),
                onTap: () async => await showGeneralDialog(
                  transitionDuration: const Duration(milliseconds: 300),
                  context: context,
                  pageBuilder:
                      (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                      ) {
                        return CargAboutDialog();
                      },
                ),
                title: Text(
                  AppLocalizations.of(context)!.about,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
