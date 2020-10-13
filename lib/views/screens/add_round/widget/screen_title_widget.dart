import 'package:carg/styles/text_style.dart';
import 'package:flutter/material.dart';

class ScreenTitleWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0))),
        padding: const EdgeInsets.all(20),
        child: Text('Nouvelle manche',
            style: CustomTextStyle.screenHeadLine2(context)));
  }
}
