import 'package:carg/services/auth_service.dart';
import 'package:carg/views/screens/home_screen.dart';
import 'package:carg/views/screens/login_screen.dart';
import 'package:carg/views/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() => runApp(Carg());

class Carg extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider.value(value: AuthService())
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, _) => MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('fr', 'FR'),
              const Locale('en', 'US')
            ],
            routes: {
              LoginScreen.routeName: (context) => LoginScreen(),
              UserScreen.routeName: (context) => UserScreen(),
              HomeScreen.routeName: (context) => HomeScreen()
            },
            title: 'Carg',
            theme: ThemeData(
                fontFamily: 'Josefin',
                textTheme: TextTheme(
                  bodyText1: TextStyle(fontSize: 22, color: Colors.white),
                  bodyText2: TextStyle(fontSize: 22),
                  headline1: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  headline2: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                brightness: Brightness.light,
                primarySwatch: mcgpalette0,
                accentColor: mcgpalette0Accent),
            home: FutureBuilder<bool>(
                future: auth.isAlreadyLogin(),
                builder: (context, authResult) {
                  if (authResult.connectionState == ConnectionState.waiting) {
                    return Scaffold(body: Center(child: SpinKitWave(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                          ),
                        );
                      },
                    )));
                  }
                  if (authResult.connectionState == ConnectionState.done) {
                    if (authResult.data) {
                      return HomeScreen();
                    } else {
                      return LoginScreen();
                    }
                  }
                  return Container();
                })),
      ),
    );
  }
}
