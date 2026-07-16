import 'package:carg/exceptions/custom_exception.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/styles/theme/theme_service.dart';
import 'package:carg/views/dialogs/carg_about_dialog.dart';
import 'package:carg/views/dialogs/edit_phone_number_dialog.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
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
              _buildProfileSection(),
              const SizedBox(height: 24),
              _buildAccountSection(),
              const SizedBox(height: 24),
              _buildMyAppSection(),
              const SizedBox(height: 24),
              _buildAppSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return ChangeNotifierProvider.value(
      value: widget.player,
      child: Consumer<Player>(
        builder: (context, playerData, _) => Consumer<ThemeService>(
          builder: (context, themeService, _) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.myProfile,
                    playerData.admin
                        ? AppLocalizations.of(context)!.admin
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildUsernameField(playerData),
                  const SizedBox(height: 20),
                  _buildProfilePictureSection(playerData),
                  const SizedBox(height: 20),
                  _buildGravatarSwitch(playerData),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicColorsSwitch(ThemeService themeService) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(
            AppLocalizations.of(context)!.useDynamicColors,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            themeService.useDynamicColors
                ? AppLocalizations.of(context)!.dynamicColorsEnabled
                : AppLocalizations.of(context)!.dynamicColorsDisabled,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeService.useDynamicColors
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
          ),
          activeThumbColor: Theme.of(context).colorScheme.primary,
          contentPadding: EdgeInsets.zero,
          onChanged: (bool value) {
            themeService.useDynamicColors = value;
          },
          value: themeService.useDynamicColors,
        ),
        if (themeService.useDynamicColors) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppLocalizations.of(context)!.dynamicColorsNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String? badgeText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (badgeText != null) _buildAdminBadge(context, badgeText),
      ],
    );
  }

  Widget _buildAdminBadge(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUsernameField(Player playerData) {
    return TextFormField(
      key: const ValueKey('usernameTextField'),
      initialValue: playerData.userName,
      autofillHints: const [AutofillHints.username],
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.username,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.person),
      ),
      onFieldSubmitted: (value) async {
        playerData.userName = value;
        await _savePlayer();
      },
    );
  }

  Widget _buildProfilePictureSection(Player playerData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.profilePicture,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(playerData.profilePicture),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                key: const ValueKey('imageURLTextField'),
                controller: _profilePictureController,
                enabled: !playerData.useGravatarProfilePicture,
                autofillHints: !playerData.useGravatarProfilePicture
                    ? [AutofillHints.url]
                    : null,
                style: Theme.of(context).textTheme.bodyLarge,
                onChanged: (value) {
                  playerData.profilePicture = value;
                },
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.profilePicture,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onFieldSubmitted: (value) async {
                  await _savePlayer();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGravatarSwitch(Player playerData) {
    return SwitchListTile(
      key: const ValueKey('gravatarSwitchTile'),
      title: Text(
        AppLocalizations.of(context)!.useMyGravatar,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      activeThumbColor: Theme.of(context).colorScheme.primary,
      contentPadding: EdgeInsets.zero,
      onChanged: (bool value) async => await _onSwitchTileChanged(value),
      value: playerData.useGravatarProfilePicture,
    );
  }

  Widget _buildAccountSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              AppLocalizations.of(context)!.myAccount,
              null,
            ),
            const SizedBox(height: 16),
            _buildPhoneNumberTile(),
            const SizedBox(height: 20),
            _buildSignOutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberTile() {
    final phoneNumber = Provider.of<AuthService>(
      context,
      listen: false,
    ).getConnectedUserPhoneNumber();

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.phone,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.changeMyPhoneNumber,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        phoneNumber ?? AppLocalizations.of(context)!.noPhoneNumberProvided,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => showEditPhoneNumberDialog(context),
    );
  }

  Widget _buildSignOutButton() {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async => await Provider.of<AuthService>(
          context,
          listen: false,
        ).signOut(context),
        icon: const Icon(Icons.logout),
        label: Text(
          AppLocalizations.of(context)!.signOut,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMyAppSection() {
    return ChangeNotifierProvider.value(
      value: widget.player,
      child: Consumer<Player>(
        builder: (context, playerData, _) => Consumer<ThemeService>(
          builder: (context, themeService, _) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    context,
                    AppLocalizations.of(context)!.settings,
                    null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.appTheme,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ThemePickerWidget(),
                  const SizedBox(height: 16),
                  _buildDynamicColorsSwitch(themeService),
                  const SizedBox(height: 20),
                  const RemoveAdsListTile(key: ValueKey('removeAdsListTile')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              AppLocalizations.of(context)!.about,
              null,
            ),
            const SizedBox(height: 16),
            _buildAboutTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.info_outline,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.about,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        AppLocalizations.of(context)!.informationAboutTheApp,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.chevron_right),
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
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );
  }
}
