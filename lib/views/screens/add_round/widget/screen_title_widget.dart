import 'package:carg/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenTitleWidget extends StatelessWidget {
  const ScreenTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Text(
        AppLocalizations.of(context)!.newRound,
        style: CustomTextStyle.screenHeadLine2(context),
      ),
    );
  }
}
