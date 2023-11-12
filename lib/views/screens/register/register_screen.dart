import 'package:carg/const.dart';
import 'package:carg/exceptions/custom_exception.dart';
import 'package:carg/routes/custom_route_fade.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/styles/custom_properties.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:carg/views/widgets/register/register_email_widget.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';
  late final FirebaseDynamicLinks linkProvider;

  RegisterScreen({super.key, FirebaseDynamicLinks? linkProvider}) {
    this.linkProvider = linkProvider ?? FirebaseDynamicLinks.instance;
  }

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Future<void> _googleSigIn(
    _RegisterData registerData,
    BuildContext context,
  ) async {
    try {
      registerData.selectedRegisterMethod = _GoogleRegisterMethod(context);
      await Provider.of<AuthService>(context, listen: false).googleLogIn().then(
            (value) => Navigator.pushReplacement(
              context,
              CustomRouteFade(
                builder: (context) =>
                    Provider.of<AuthService>(context, listen: false)
                        .getCorrectLandingScreen(),
              ),
            ),
          );
    } on CustomException catch (e) {
      InfoSnackBar.showErrorSnackBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;
    final shape = MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        side: BorderSide(width: 2, color: primaryColor),
        borderRadius: BorderRadius.circular(
          CustomProperties.borderRadius,
        ),
      ),
    );

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
                          Const.svgLogoPath,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        Const.appName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.signInAndUp,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChangeNotifierProvider.value(
                    value: _RegisterData(
                      _EmailRegisterMethod(
                        linkProvider: widget.linkProvider,
                      ),
                    ),
                    child: Consumer<_RegisterData>(
                      builder: (context, registerData, _) => Column(
                        children: [
                          AnimatedSize(
                            key: const ValueKey('placeholderContainer'),
                            curve: Curves.ease,
                            duration: const Duration(milliseconds: 500),
                            child: registerData
                                .selectedRegisterMethod.registrationWidget,
                          ),
                          SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              key: const ValueKey('emailButton'),
                              icon: const Icon(Icons.mail_outline),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  registerData.selectedRegisterMethod
                                          is _EmailRegisterMethod
                                      ? primaryColor
                                      : cardColor,
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  registerData.selectedRegisterMethod
                                          is _EmailRegisterMethod
                                      ? cardColor
                                      : primaryColor,
                                ),
                                shape: shape,
                              ),
                              onPressed: () {
                                registerData.selectedRegisterMethod =
                                    _EmailRegisterMethod(
                                  linkProvider: widget.linkProvider,
                                );
                              },
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .continueWithEmail,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
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
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  registerData.selectedRegisterMethod
                                          is _PhoneRegisterMethod
                                      ? primaryColor
                                      : cardColor,
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  registerData.selectedRegisterMethod
                                          is _PhoneRegisterMethod
                                      ? cardColor
                                      : primaryColor,
                                ),
                                shape: shape,
                              ),
                              onPressed: () {
                                registerData.selectedRegisterMethod =
                                    _PhoneRegisterMethod();
                              },
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .continueWithPhone,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
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
                                FontAwesomeIcons.google,
                                size: 22,
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  registerData.selectedRegisterMethod
                                          is _GoogleRegisterMethod
                                      ? primaryColor
                                      : cardColor,
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  registerData.selectedRegisterMethod
                                          is _GoogleRegisterMethod
                                      ? cardColor
                                      : Theme.of(context).primaryColor,
                                ),
                                shape: shape,
                              ),
                              onPressed: () {
                                _googleSigIn(registerData, context);
                              },
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .continueWithGoogle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
  _PhoneRegisterMethod()
      : super(
          const RegisterPhoneWidget(
            credentialVerificationType: CredentialVerificationType.CREATE,
          ),
        );
}

class _EmailRegisterMethod extends RegisterMethod {
  _EmailRegisterMethod({required FirebaseDynamicLinks linkProvider})
      : super(
          RegisterEmailWidget(
            credentialVerificationType: CredentialVerificationType.CREATE,
            linkProvider: linkProvider,
          ),
        );
}

class _GoogleRegisterMethod extends RegisterMethod {
  _GoogleRegisterMethod(BuildContext context)
      : super(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.logInToGoogle}...',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
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
