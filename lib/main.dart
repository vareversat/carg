import 'package:carg/app_theme.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/register/register_screen.dart';
import 'package:carg/views/screens/splash_screen.dart';
import 'package:carg/views/screens/user_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );
  await MobileAds.instance.initialize();
  runApp(const Carg());
}

class Carg extends StatefulWidget {
  const Carg({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CargState();
  }
}

class _CargState extends State<Carg> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider.value(value: AuthService())
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, _) => MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (var locale in supportedLocales) {
                if (locale.languageCode == deviceLocale!.languageCode) {
                  return deviceLocale;
                }
              }
              return const Locale('en', '');
            },
            supportedLocales: const [Locale('en', ''), Locale('fr', '')],
            routes: {
              UserScreen.routeName: (context) => const UserScreen(),
              RegisterScreen.routeName: (context) => RegisterScreen(),
              HomeScreen.routeName: (context) => HomeScreen(
                  requestedIndex:
                      ModalRoute.of(context)!.settings.arguments as int? ?? 0)
            },
            title: 'Carg',
            theme: AppTheme.theme,
            home: FutureBuilder<bool>(
                future: auth.isAlreadyLogin(),
                builder: (context, authResult) {
                  if (authResult.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  }
                  if (authResult.connectionState == ConnectionState.done) {
                    if (authResult.data == null || !authResult.data!) {
                      // User is not logged
                      return RegisterScreen();
                    } else if (authResult.data != null && authResult.data!) {
                      // User is already logged
                      return Provider.of<AuthService>(context, listen: false)
                          .getCorrectLandingScreen();
                    }
                  }
                  return Container();
                })),
      ),
    );
  }
}
