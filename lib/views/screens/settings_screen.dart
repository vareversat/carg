import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/custom_exception.dart';
import 'package:carg/services/impl/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/carg_about_dialog.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/screens/register/edit_email_screen.dart';
import 'package:carg/views/screens/register/edit_phone_number_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  final Player player;
  final PlayerService playerService;

  const SettingsScreen(
      {Key? key, required this.player, required this.playerService})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _profilePictureController =
      TextEditingController();

  Future<void> _savePlayer() async {
    try {
      await widget.playerService.update(widget.player);
      InfoSnackBar.showSnackBar(context, 'Profil modifié avec succès');
    } on CustomException catch (e) {
      InfoSnackBar.showSnackBar(context, e.message);
    }
  }

  Future<void> _onSwitchTileChanged(bool value) async {
    widget.player.gravatarProfilePicture =
        Provider.of<AuthService>(context, listen: false)
            .getConnectedUserEmail();
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
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop()),
        title:
            Text('Paramètres', style: CustomTextStyle.screenHeadLine1(context)),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Mon profil',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30)),
                                  playerData.admin
                                      ? ClipRRect(
                                      key: const ValueKey('adminLabel'),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Container(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            height: 30,
                                            child: Center(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text('Admin',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      fontSize: 15),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            )),
                                          ))
                                      : const SizedBox(),
                                ],
                              )),
                              ListTile(
                                title: TextFormField(
                                  key: const ValueKey('usernameTextField'),
                                  initialValue: playerData.userName,
                                  autofillHints: const [AutofillHints.username],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.normal),
                                    labelText: 'Nom d\'utilisateur',
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
                                          color:
                                              Theme.of(context).primaryColor),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              playerData.profilePicture)),
                                    )),
                                title: TextFormField(
                                  key: const ValueKey('imageURLTextField'),
                                  controller: _profilePictureController,
                                  enabled:
                                      !playerData.useGravatarProfilePicture,
                                  autofillHints:
                                      !playerData.useGravatarProfilePicture
                                          ? [AutofillHints.url]
                                          : null,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color:
                                          !playerData.useGravatarProfilePicture
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .color
                                              : Colors.grey),
                                  onChanged: (value) {
                                    playerData.profilePicture = value;
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: const InputDecoration(
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.normal),
                                    labelText: 'Image de profil (URL)',
                                  ),
                                  onFieldSubmitted: (value) async {
                                    await _savePlayer();
                                  },
                                ),
                              ),
                              SwitchListTile(
                                key: const ValueKey('gravatarSwitchTile'),
                                title: const Text('Utiliser mon Gravatar',
                                    style: TextStyle(fontSize: 20)),
                                onChanged: (bool value) async =>
                                    await _onSwitchTileChanged(value),
                                value: playerData.useGravatarProfilePicture,
                              )
                            ],
                          ))),
              const SizedBox(height: 15),
              ListTile(
                  title: Text('Mon compte',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30))),
              Column(
                children: [
                  ListTile(
                      subtitle: Text(
                          Provider.of<AuthService>(context, listen: false)
                                  .getConnectedUserEmail() ??
                              "Pas d'email renseigné'",
                          key: const ValueKey('emailText'),
                          style: const TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic)),
                      selected: true,
                      leading: const Icon(
                        Icons.mail_outline,
                        size: 30,
                      ),
                      onTap: () => Navigator.push(
                          context,
                          CustomRouteLeftToRight(
                              builder: (context) => const EditEmailScreen())),
                      title: const Text('Changer mon adresse e-mail',
                          style: TextStyle(fontSize: 20))),
                  ListTile(
                      subtitle: Text(
                          Provider.of<AuthService>(context, listen: false)
                                  .getConnectedUserPhoneNumber() ??
                              'Pas de numéro renseigné',
                          key: const ValueKey('phoneText'),
                          style: const TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic)),
                      selected: true,
                      leading: const Icon(
                        Icons.phone,
                        size: 30,
                      ),
                      onTap: () => Navigator.push(
                          context,
                          CustomRouteLeftToRight(
                              builder: (context) =>
                                  const EditPhoneNumberScreen())),
                      title: const Text('Changer mon numéro de téléphone',
                          style: TextStyle(fontSize: 20))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextButton(
                    onPressed: () async =>
                        await Provider.of<AuthService>(context, listen: false)
                            .signOut(context),
                    child: const Text('Déconnexion',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 25)),
                  ),
                ),
              ),
              ListTile(
                  key: const ValueKey('aboutButton'),
                  subtitle: const Text('Informations concernant l\'application',
                      style: TextStyle(fontSize: 15)),
                  selected: true,
                  leading: const Icon(
                    Icons.info_outline,
                    size: 30,
                  ),
                  onTap: () async => await showGeneralDialog(
                      transitionDuration: const Duration(milliseconds: 300),
                      context: context,
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return CargAboutDialog();
                      }),
                  title: Text('A propos',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 25)))
            ],
          ),
        ),
      ),
    );
  }
}
