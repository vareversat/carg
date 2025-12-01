import 'package:carg/l10n/app_localizations.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/styles/theme/theme_service.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/register/register_screen.dart';
import 'package:carg/views/screens/splash_screen.dart';
import 'package:carg/views/screens/user_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    providerWeb: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    providerAndroid: AndroidPlayIntegrityProvider(),
    providerApple: AppleDeviceCheckProvider(),
  );
  await MobileAds.instance.initialize();
  // Initialize the storage system
  final StorageService storageService = StorageService(
    sharedPreferences: await SharedPreferences.getInstance(),
  );
  runApp(Carg(storageService: storageService));
}

class Carg extends StatefulWidget {
  final StorageService storageService;

  const Carg({super.key, required this.storageService});

  @override
  State<StatefulWidget> createState() {
    return _CargState();
  }
}

class _CargState extends State<Carg> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider.value(value: AuthService()),
        ChangeNotifierProvider.value(
          value: ThemeService(context, widget.storageService),
        ),
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
                  ModalRoute.of(context)!.settings.arguments as int? ?? 0,
            ),
          },
          title: 'Carg',
          theme: Provider.of<ThemeService>(context).getCurrentThemeData(),
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
                  return Provider.of<AuthService>(
                    context,
                    listen: false,
                  ).getCorrectLandingScreen();
                }
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
