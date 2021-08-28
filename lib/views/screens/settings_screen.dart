import 'package:carg/helpers/custom_route.dart';
import 'package:carg/models/player.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/dialogs/carg_about_dialog.dart';
import 'package:carg/views/dialogs/credentials_dialog.dart';
import 'package:carg/views/screens/register/edit_email_screen.dart';
import 'package:carg/views/screens/register/edit_phone_number_screen.dart';
import 'package:carg/views/screens/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  final Player player;

  const SettingsScreen({required this.player});

  @override
  _SettingsScreenState createState() => _SettingsScreenState(player);
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Player _player;
  final PlayerService _playerService = PlayerService();


  _SettingsScreenState(this._player);

  Future _savePlayer() async {
    await _playerService.updatePlayer(_player);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.all(20),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      content: Text('Profil modifié avec succès',
          style: CustomTextStyle.snackBarTextStyle(context)),
    ));
  }

  Future<void> _signOut() async {
    try {
      await Provider.of<AuthService>(context, listen: false).signOut(context);
      // ignore: empty_catches
    } catch (e) {}
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

    await Navigator.push(context, CustomRouteLeftToRight(
        builder: (context) => EditPhoneNumberScreen()));


    var message = null;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content:
            Text(message, style: CustomTextStyle.snackBarTextStyle(context)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  value: _player,
                  child: Consumer<Player>(
                      builder: (context, playerData, _) => Container(
                            child: Column(
                              children: [
                                ListTile(
                                    title: Text('Mon profil',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30))),
                                ListTile(
                                  title: TextFormField(
                                    initialValue: playerData.userName,
                                    autofillHints: [AutofillHints.username],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
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
                                    enabled:
                                        !playerData.useGravatarProfilePicture,
                                    initialValue: playerData.profilePicture,
                                    autofillHints:
                                        !playerData.useGravatarProfilePicture
                                            ? [AutofillHints.url]
                                            : null,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: !playerData
                                                .useGravatarProfilePicture
                                            ? Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .color
                                            : Colors.grey),
                                    onChanged: (value) {
                                      playerData.profilePicture = value;
                                    },
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
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
                                  title: Text('Utiliser mon Gravatar',
                                      style: TextStyle(fontSize: 20)),
                                  onChanged: (bool value) async {
                                    playerData.gravatarProfilePicture =
                                        Provider.of<AuthService>(
                                            context,
                                            listen: false)
                                            .getConnectedUserEmail();
                                    playerData
                                        .useGravatarProfilePicture =
                                        value;
                                    await _savePlayer();
                                  },
                                  value: playerData
                                      .useGravatarProfilePicture,
                                )
                              ],
                            ),
                          ))),
              SizedBox(height: 15),
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
                          Provider.of<AuthService>(context,
                              listen: false)
                              .getConnectedUserEmail() ??
                              'Pas d\'email renseigné',
                          style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                      selected: true,
                      leading: Icon(
                        Icons.mail_outline,
                        size: 30,
                      ),
                      onTap: () => Navigator.push(context, CustomRouteLeftToRight(
                          builder: (context) => EditEmailScreen())),
                      title: Text('Changer mon adresse e-mail',
                          style: TextStyle(fontSize: 20))),
                  ListTile(
                      subtitle: Text(
                          Provider.of<AuthService>(context,
                              listen: false)
                              .getConnectedUserPhoneNumber() ??
                              'Pas de numéro renseigné',
                          style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                      selected: true,
                      leading: Icon(
                        Icons.phone,
                        size: 30,
                      ),
                      onTap: () => Navigator.push(context, CustomRouteLeftToRight(
                          builder: (context) => EditPhoneNumberScreen())),
                      title: Text('Changer mon numéro de téléphone',
                          style: TextStyle(fontSize: 20))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextButton(
                    onPressed: () => _signOut(),
                    child: Text('Déconnexion',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 25)),
                  ),
                ),
              ),
              ListTile(
                  subtitle: Text('Informations concernant l\'application',
                      style: TextStyle(fontSize: 15)),
                  selected: true,
                  leading: Icon(
                    Icons.info_outline,
                    size: 30,
                  ),
                  onTap: () async => await showGeneralDialog(
                      transitionDuration: Duration(milliseconds: 300),
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
