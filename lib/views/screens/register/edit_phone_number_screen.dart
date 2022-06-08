import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class EditPhoneNumberScreen extends StatelessWidget {
  const EditPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          body: Center(
              child: SingleChildScrollView(
        child: Column(children: <Widget>[
          const SizedBox(height: 30),
          SizedBox(
            height: 150,
            child: SvgPicture.asset(
              'assets/images/card_game.svg',
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(35),
            child: Text(
              'Nouveau numéro de téléphone',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          const RegisterPhoneWidget(
              credentialVerificationType: CredentialVerificationType.EDIT)
        ]),
      ))),
    );
  }
}
