import 'package:flutter/material.dart';

class CustomRouteFade<T> extends MaterialPageRoute<T> {
  CustomRouteFade({required super.builder, super.settings});

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(animation),
      child: child,
    );
  }
}
