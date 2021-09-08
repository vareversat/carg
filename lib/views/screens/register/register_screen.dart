import 'package:carg/helpers/custom_route.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/widgets/register/register_email_widget.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = '/register';

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }

}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 110,
                        child: SvgPicture.asset('assets/images/card_game.svg')),
                    SizedBox(height: 15),
                    Text(
                      'Carg',
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Connexion & Inscription',
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChangeNotifierProvider.value(
                  value: RegisterData(EmailRegisterMethod()),
                  child: Consumer<RegisterData>(
                      builder: (context, registerData, _) =>
                          Column(
                            children: [
                              AnimatedSize(
                                  curve: Curves.ease,
                                  vsync: this,
                                  duration: Duration(milliseconds: 500),
                                  child: registerData.selectedRegisterMethod
                                      .registrationWidget)
                              ,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0),
                                child: Text('ou', style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.mail_outline),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all<
                                          Color>(
                                          registerData
                                              .selectedRegisterMethod is EmailRegisterMethod
                                              ? Theme
                                              .of(context)
                                              .primaryColor
                                              : Theme
                                              .of(context)
                                              .cardColor),
                                      foregroundColor: MaterialStateProperty
                                          .all<
                                          Color>(
                                          registerData
                                              .selectedRegisterMethod is EmailRegisterMethod
                                              ? Theme
                                              .of(context)
                                              .cardColor
                                              : Theme
                                              .of(context)
                                              .primaryColor),
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Theme
                                                      .of(context)
                                                      .primaryColor),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  CustomProperties
                                                      .borderRadius)))),
                                  onPressed: () {
                                    registerData.selectedRegisterMethod =
                                        EmailRegisterMethod();
                                  },
                                  label: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Continuer avec une adresse e-mail',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.phone),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all<
                                          Color>(
                                          registerData
                                              .selectedRegisterMethod is PhoneRegisterMethod
                                              ? Theme
                                              .of(context)
                                              .primaryColor
                                              : Theme
                                              .of(context)
                                              .cardColor),
                                      foregroundColor: MaterialStateProperty
                                          .all<
                                          Color>(
                                          registerData
                                              .selectedRegisterMethod is PhoneRegisterMethod
                                              ? Theme
                                              .of(context)
                                              .cardColor
                                              : Theme
                                              .of(context)
                                              .primaryColor),
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Theme
                                                      .of(context)
                                                      .primaryColor),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  CustomProperties
                                                      .borderRadius)))),
                                  onPressed: () {
                                    registerData.selectedRegisterMethod =
                                        PhoneRegisterMethod();
                                  },
                                  label: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Continuer avec un numéro de téléphone',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 45,
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: FaIcon(
                                      FontAwesomeIcons.google, size: 22),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all<
                                          Color>(
                                          registerData
                                              .selectedRegisterMethod is GoogleRegisterMethod
                                              ? Theme
                                              .of(context)
                                              .primaryColor
                                              : Theme
                                              .of(context)
                                              .cardColor),
                                      foregroundColor: MaterialStateProperty
                                          .all<
                                          Color>(
                                          registerData
                                              .selectedRegisterMethod is GoogleRegisterMethod
                                              ? Theme
                                              .of(context)
                                              .cardColor
                                              : Theme
                                              .of(context)
                                              .primaryColor),
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Theme
                                                      .of(context)
                                                      .primaryColor),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  CustomProperties
                                                      .borderRadius)))),
                                  onPressed: () async {
                                    registerData.selectedRegisterMethod =
                                        GoogleRegisterMethod();
                                    await Provider.of<AuthService>(
                                        context, listen: false)
                                        .googleLogIn();
                                    await Navigator.pushReplacement(
                                      context,
                                      CustomRouteFade(
                                        builder: (context) =>
                                            Provider.of<AuthService>(
                                                context, listen: false)
                                                .getCorrectLandingScreen(),
                                      ),
                                    );
                                  },
                                  label: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Continuer avec Google',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract class RegisterMethod {
  Widget registrationWidget;

  RegisterMethod(this.registrationWidget);
}

class PhoneRegisterMethod extends RegisterMethod {
  PhoneRegisterMethod() : super(RegisterPhoneWidget(
      credentialVerificationType: CredentialVerificationType.CREATE));
}

class EmailRegisterMethod extends RegisterMethod {
  EmailRegisterMethod() : super(RegisterEmailWidget(
      credentialVerificationType: CredentialVerificationType.CREATE));
}

class GoogleRegisterMethod extends RegisterMethod {
  GoogleRegisterMethod() : super(Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Connexion à votre compte Google...',
          style: TextStyle(fontStyle: FontStyle.italic)),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 3)),
      )
    ],
  ));
}


class RegisterData with ChangeNotifier {

  RegisterMethod _selectedRegisterMethod;

  RegisterData(this._selectedRegisterMethod);

  RegisterMethod get selectedRegisterMethod => _selectedRegisterMethod;

  set selectedRegisterMethod(RegisterMethod value) {
    _selectedRegisterMethod = value;
    notifyListeners();
  }
}
