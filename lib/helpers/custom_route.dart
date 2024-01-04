import 'package:flutter/material.dart';

class CustomRouteBottomToTop<T> extends MaterialPageRoute<T> {
  CustomRouteBottomToTop({required super.builder, super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var begin = const Offset(0.0, 1.0);
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}

class CustomRouteLeftToRight<T> extends MaterialPageRoute<T> {
  CustomRouteLeftToRight({required super.builder, super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-1.0, 0.0),
        ).animate(secondaryAnimation),
        child: child,
      ),
    );
  }
}

class CustomRouteFade<T> extends MaterialPageRoute<T> {
  CustomRouteFade({required super.builder, super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(animation),
      child: child,
    );
  }
}
