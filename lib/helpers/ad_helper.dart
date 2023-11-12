import 'package:carg/const.dart';
import 'package:flutter/material.dart';

class AdHelper {
  // Had to use Theme.of(context).platform instead of Platform.isAndroid for tests purposes
  static String bannerAdUnitId(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android) {
      return Const.androidInlineBanner;
    } else if (platform == TargetPlatform.iOS) {
      return Const.iosInlineBanner;
    } else {
      throw UnsupportedError(
        'Unsupported platform to determine the banner unit ID',
      );
    }
  }
}
