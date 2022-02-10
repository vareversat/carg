import 'package:carg/services/auth_service.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/register/register_screen.dart';
import 'package:carg/views/screens/splash_screen.dart';
import 'package:carg/views/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() => runApp(const Carg());

class Carg extends StatefulWidget {
  const Carg({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CargState();
  }
}

class _CargState extends State<Carg> {
  static const MaterialColor mcgpalette0 =
      MaterialColor(_mcgpalette0PrimaryValue, <int, Color>{
    50: Color(0xFFE7EFE4),
    100: Color(0xFFC3D6BB),
    200: Color(0xFF9CBB8E),
    300: Color(0xFF749F61),
    400: Color(0xFF568B3F),
    500: Color(_mcgpalette0PrimaryValue),
    600: Color(0xFF326E1A),
    700: Color(0xFF2B6315),
    800: Color(0xFF245911),
    900: Color(0xFF17460A),
  });
  static const int _mcgpalette0PrimaryValue = 0xFF38761D;

  static const MaterialColor mcgpalette0Accent =
      MaterialColor(_mcgpalette0AccentValue, <int, Color>{
    100: Color(0xFFFFCCB8),
    200: Color(_mcgpalette0AccentValue),
    400: Color(0xFFFF8252),
    700: Color(0xFFFF7039),
  });
  static const int _mcgpalette0AccentValue = 0xFFFFA785;

  final theme = ThemeData(
      fontFamily: 'Josefin',
      textTheme: const TextTheme(
        bodyText1: TextStyle(fontSize: 18, color: Colors.white),
        bodyText2: TextStyle(fontSize: 18),
      ),
      brightness: Brightness.light,
      primarySwatch: mcgpalette0);

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
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fr', 'FR'),
              Locale('en', 'US')
            ],
            routes: {
              UserScreen.routeName: (context) => const UserScreen(),
              RegisterScreen.routeName: (context) => const RegisterScreen(),
              HomeScreen.routeName: (context) => HomeScreen(
                  requestedIndex:
                      ModalRoute.of(context)!.settings.arguments as int? ?? 0)
            },
            title: 'Carg',
            theme: theme.copyWith(
                colorScheme:
                    theme.colorScheme.copyWith(secondary: mcgpalette0Accent)),
            home: FutureBuilder<bool>(
                future: auth.isAlreadyLogin(),
                builder: (context, authResult) {
                  if (authResult.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  }
                  if (authResult.connectionState == ConnectionState.done) {
                    if (authResult.data == null || !authResult.data!) {
                      // User is not logged
                      return const RegisterScreen();
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
