import 'package:carg/models/player/player.dart';
import 'package:flutter/material.dart';

class ViewHelper {
  final String defaultUrl =
      'https://cdn.icon-icons.com/icons2/1769/PNG/512/4092564-about-mobile-ui-profile-ui-user-website_114033.png';

  Image getImage(Player player) {
    if (player != null && player.profilePicture != null) {
      var profilePicture = Image.network(player.profilePicture);
      final ImageErrorListener onErrorListener =
          (dynamic exception, StackTrace stackTrace) {
        profilePicture = Image.network(defaultUrl);
      };
      final stream = profilePicture.image.resolve(ImageConfiguration.empty);
      stream.addListener(ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {},
          onError: onErrorListener));

      return profilePicture;
    }
    return Image.network(defaultUrl);
  }
}
