import 'package:carg/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:carg/l10n/app_localizations.dart';

class ScreenTitleWidget extends StatelessWidget {
  const ScreenTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        AppLocalizations.of(context)!.newRound,
        style: CustomTextStyle.screenHeadLine2(context),
      ),
    );
  }
}
