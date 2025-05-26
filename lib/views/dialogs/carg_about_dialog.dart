import 'package:carg/const.dart';
import 'package:carg/styles/properties.dart';
import 'package:flutter/material.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CargAboutDialog extends StatelessWidget {
  final String _legalLease = '© ${DateTime.now().year} - Valentin REVERSAT';
  final Widget _iconWidget = Padding(
    padding: const EdgeInsets.all(5),
    child: SizedBox(
      height: 60,
      width: 60,
      child: SvgPicture.asset(Const.svgLogoPath),
    ),
  );

  CargAboutDialog({super.key});

  void _launchURL(String url, BuildContext context) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw '${AppLocalizations.of(context)!.unableToOpen} $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.data == null) {
          return Text(AppLocalizations.of(context)!.unableAppInfo);
        }
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          titlePadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actionsPadding: const EdgeInsets.fromLTRB(0, 10, 20, 20),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconTheme(data: Theme.of(context).iconTheme, child: _iconWidget),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            snapshot.data!.appName,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            ' | v${snapshot.data!.version} (${snapshot.data!.buildNumber})',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _legalLease,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CustomProperties.borderRadius),
          ),
          content: ListBody(
            children: <Widget>[
              Text(
                '${AppLocalizations.of(context)!.appDescription}\n',
                style: const TextStyle(fontSize: 18),
              ),
              ElevatedButton.icon(
                key: const ValueKey('sourceCodeButton'),
                onPressed: () => _launchURL(Const.githubLink, context),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).cardColor,
                  ),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        CustomProperties.borderRadius,
                      ),
                    ),
                  ),
                ),
                label: Text(
                  AppLocalizations.of(context)!.sourceCode,
                  style: const TextStyle(fontSize: 18),
                ),
                icon: const Icon(FontAwesomeIcons.github, size: 20),
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).colorScheme.secondary,
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).cardColor,
                  ),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        CustomProperties.borderRadius,
                      ),
                    ),
                  ),
                ),
                onPressed:
                    () => {
                      launchUrlString(
                        Const.releaseUrl.replaceAll(
                          '%',
                          snapshot.data!.version,
                        ),
                        mode: LaunchMode.externalApplication,
                      ),
                    },
                label: Text(
                  AppLocalizations.of(context)!.changelog,
                  style: const TextStyle(fontSize: 18),
                ),
                icon: const Icon(FontAwesomeIcons.fileCode, size: 20),
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).cardColor,
                  ),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        CustomProperties.borderRadius,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  showLicensePage(
                    context: context,
                    applicationName: snapshot.data!.appName,
                    applicationVersion:
                        'v${snapshot.data!.version}+${snapshot.data!.buildNumber}',
                    applicationIcon: _iconWidget,
                    applicationLegalese: _legalLease,
                  );
                },
                label: Text(
                  MaterialLocalizations.of(context).viewLicensesButtonLabel[0] +
                      MaterialLocalizations.of(
                        context,
                      ).viewLicensesButtonLabel.substring(1).toLowerCase(),
                  style: const TextStyle(fontSize: 18),
                ),
                icon: const Icon(FontAwesomeIcons.fileLines, size: 20),
              ),
              ElevatedButton.icon(
                key: const ValueKey('privacyButton'),
                onPressed: () => _launchURL(Const.privacyInfoLink, context),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Colors.blueAccent,
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).cardColor,
                  ),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        CustomProperties.borderRadius,
                      ),
                    ),
                  ),
                ),
                label: Text(
                  AppLocalizations.of(context)!.privacyPolicy,
                  style: const TextStyle(fontSize: 18),
                ),
                icon: const Icon(FontAwesomeIcons.userShield, size: 20),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                foregroundColor: WidgetStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
                shape: WidgetStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      CustomProperties.borderRadius,
                    ),
                  ),
                ),
              ),
              onPressed: () => {Navigator.pop(context)},
              icon: const Icon(Icons.close),
              label: Text(MaterialLocalizations.of(context).closeButtonLabel),
            ),
          ],
          scrollable: true,
        );
      },
      future: PackageInfo.fromPlatform(),
    );
  }
}
