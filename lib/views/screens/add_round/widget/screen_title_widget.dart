import 'package:carg/styles/text_style.dart';
import 'package:flutter/material.dart';

class ScreenTitleWidget extends StatelessWidget {
  const ScreenTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        padding: const EdgeInsets.all(20),
        child: Text('Nouvelle manche',
            style: CustomTextStyle.screenHeadLine2(context)));
  }
}
