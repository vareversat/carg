import 'package:carg/const.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

class EditPhoneNumberScreen extends StatelessWidget {
  const EditPhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                SizedBox(
                  height: 150,
                  child: SvgPicture.asset(
                    Const.svgLogoPath,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(35),
                  child: Text(
                    AppLocalizations.of(context)!.newPhoneNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const RegisterPhoneWidget(
                  credentialVerificationType: CredentialVerificationType.EDIT,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
