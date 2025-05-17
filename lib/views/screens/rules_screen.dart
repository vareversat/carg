import 'package:carg/models/game/game_type.dart';
import 'package:carg/styles/text_style.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher_string.dart';

class RulesScreen extends StatelessWidget {
  final GameType gameType;

  const RulesScreen({super.key, required this.gameType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        centerTitle: true,
        title: Text(
          '${gameType.name} - Règles',
          style: CustomTextStyle.screenHeadLine1(context),
        ),
      ),
      body: FutureBuilder(
        future: rootBundle.loadString('assets/rules/${gameType.rulesFile}'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Markdown(
              onTapLink: (text, url, title) {
                Future.delayed(const Duration(seconds: 1)).then(
                  (value) => launchUrlString(
                    url!,
                    mode: LaunchMode.externalApplication,
                  ),
                );
                InfoSnackBar.showSnackBar(context, 'Overture de $text...');
              },
              data: snapshot.data!,
              selectable: true,
              extensionSet: md.ExtensionSet(
                md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                [
                  md.EmojiSyntax(),
                  md.LinkSyntax(),
                  ...md.ExtensionSet.gitHubWeb.inlineSyntaxes,
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
