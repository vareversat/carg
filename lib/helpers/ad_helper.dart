import 'dart:io';

import 'package:carg/const.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return Const.androidInlineBanner;
    } else if (Platform.isIOS) {
      return Const.iosInlineBanner;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
