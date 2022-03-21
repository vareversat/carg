import 'package:carg/bloc_test/test_2/login_bloc.dart';
import 'package:carg/bloc_test/test_2/login_event.dart';
import 'package:carg/bloc_test/test_2/login_state.dart';
import 'package:carg/helpers/custom_route.dart';
import 'package:carg/services/auth_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/widgets/register/register_email_widget.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }

}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
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
                      SizedBox(
                          height: 110,
                          child: SvgPicture.asset(
                              'assets/images/card_game.svg')),
                      const SizedBox(height: 15),
                      const Text(
                        'Carg',
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
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
                  child: Column(
                    children: [
                      BlocProvider(
                          create: (BuildContext context) => LoginBloc(),
                          child: BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              return Text(state.loginMethod.toString());
                            },
                          )
                      ),
                      AnimatedSize(
                          key: const ValueKey('placeholderContainer'),
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 500),
                          child: Text('old widget')),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0),
                        child: Text('ou', style: TextStyle(
                            fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          key: const ValueKey('emailButton'),
                          icon: const Icon(Icons.mail_outline),
                          onPressed: () {
                          },
                          label: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Continuer avec une adresse email',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          key: const ValueKey('phoneButton'),
                          icon: const Icon(Icons.phone),
                          onPressed: () {
                            context.read<LoginBloc>().add(const PhoneLoginMethod());
                          },
                          label: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Continuer avec un numéro de téléphone',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          key: const ValueKey('googleButton'),
                          icon: const FaIcon(
                              FontAwesomeIcons.google, size: 22),
                          onPressed: () async {
                          },
                          label: const Padding(
                            padding: EdgeInsets.all(8.0),
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
                  ),
                ),
              ],
            ),
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

class _PhoneRegisterMethod extends RegisterMethod {
  _PhoneRegisterMethod() : super(const RegisterPhoneWidget(
      credentialVerificationType: CredentialVerificationType.CREATE));
}

class _EmailRegisterMethod extends RegisterMethod {
  _EmailRegisterMethod() : super(const RegisterEmailWidget(
      credentialVerificationType: CredentialVerificationType.CREATE));
}

class _GoogleRegisterMethod extends RegisterMethod {
  _GoogleRegisterMethod() : super(Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Text('Connexion à votre compte Google...',
          style: TextStyle(fontStyle: FontStyle.italic)),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 3)),
      )
    ],
  ));
}


class _RegisterData with ChangeNotifier {

  RegisterMethod _selectedRegisterMethod;

  _RegisterData(this._selectedRegisterMethod);

  RegisterMethod get selectedRegisterMethod => _selectedRegisterMethod;

  set selectedRegisterMethod(RegisterMethod value) {
    _selectedRegisterMethod = value;
    notifyListeners();
  }
}
