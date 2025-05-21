import 'package:flutter/material.dart';
import 'package:carg/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Widget localizedTestableWidget(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', ''),
      ],
      home: child,
    );
