import 'package:carg/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChangeLogScreen extends StatelessWidget {
  const ChangeLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(AppLocalizations.of(context)!.changelog),
      ),
      body: FutureBuilder(
        future: rootBundle.loadString(Const.changelogPath),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Markdown(data: snapshot.data!);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
