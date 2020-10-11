import 'package:carg/views/screens/change_log_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class CargAboutDialog extends StatelessWidget {
  final String _repoUrl = 'https://github.com/Devosud/carg';
  final String _legalLease = '© 2020 - Devosud';
  final String _errorMessage =
      'Impossible d\'obtenir les informations de l\'application';
  final String _appInfo =
      'L\'application pour enregistrer vos parties de Belote, Coinche et Tarot ! \n';
  final String _sourceCode = 'Code source';
  final String _changeLog = 'Journal des modifications';
  final Widget _iconWidget = Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        height: 60,
        width: 60,
        child: SvgPicture.asset('assets/images/card_game.svg'),
      ));

  Future<PackageInfo> _getVersionNumber() async {
    return await PackageInfo.fromPlatform();
  }

  void _launchURL() async {
    if (await canLaunch(_repoUrl)) {
      await launch(_repoUrl, forceSafariVC: false);
    } else {
      throw 'Impossible d\'ouvrir $_repoUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.none &&
                snapshot.hasData == null ||
            snapshot.data == null) {
          return Text(_errorMessage);
        }
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          titlePadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actionsPadding: const EdgeInsets.fromLTRB(0, 10, 20, 20),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconTheme(data: Theme.of(context).iconTheme, child: _iconWidget),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ListBody(
                    children: <Widget>[
                      Text(snapshot.data.appName,
                          style: Theme.of(context).textTheme.headline5),
                      Text(
                          'v${snapshot.data.version}+${snapshot.data.buildNumber}',
                          style: Theme.of(context).textTheme.bodyText2),
                      SizedBox(height: 10),
                      Text(_legalLease,
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                ),
              ),
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: ListBody(
            children: <Widget>[
              Text(_appInfo),
              RaisedButton.icon(
                  color: Colors.black,
                  textColor: Theme.of(context).cardColor,
                  onPressed: () => _launchURL(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  label: Text(_sourceCode),
                  icon: Icon(
                    FontAwesomeIcons.github,
                    size: 16,
                  )),
              RaisedButton.icon(
                  color: Theme.of(context).accentColor,
                  textColor: Theme.of(context).cardColor,
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeLogScreen(),
                        ),
                      ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  label: Text(_changeLog, style: TextStyle(fontSize: 14)),
                  icon: Icon(
                    FontAwesomeIcons.fileCode,
                    size: 16,
                  ))
            ],
          ),
          actions: <Widget>[
            RaisedButton.icon(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                onPressed: () {
                  showLicensePage(
                    context: context,
                    applicationName: snapshot.data.appName,
                    applicationVersion:
                        'v${snapshot.data.version}+${snapshot.data.buildNumber}',
                    applicationIcon: _iconWidget,
                    applicationLegalese: _legalLease,
                  );
                },
                label: Text(
                  MaterialLocalizations.of(context).viewLicensesButtonLabel,
                ),
                icon: Icon(
                  FontAwesomeIcons.fileAlt,
                  size: 16,
                )),
            FlatButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Theme.of(context).primaryColor)),
              onPressed: () => {Navigator.pop(context)},
              color: Colors.white,
              textColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.close),
              label: Text(
                MaterialLocalizations.of(context).closeButtonLabel,
              ),
            )
          ],
          scrollable: true,
        );
      },
      future: _getVersionNumber(),
    );
  }
}
