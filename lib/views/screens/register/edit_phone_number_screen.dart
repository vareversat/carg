import 'package:carg/services/auth_service.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditPhoneNumberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
      child: Column(children: <Widget>[
        SizedBox(height: 30),
        Container(
          height: 150,
          child: SvgPicture.asset(
            'assets/images/card_game.svg',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(35),
          child: Text(
            'Nouveau numéro de téléphone',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
        RegisterPhoneWidget(
            credentialVerificationType: CredentialVerificationType.EDIT)
      ]),
    )));
  }
}
