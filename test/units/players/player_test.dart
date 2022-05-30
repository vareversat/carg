import 'package:carg/models/player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Player', () {
    test('Default username', () {
      final player = Player(owned: false);
      expect(player.userName, '');
    });

    test('Use Gravatar', () {
      final player = Player(owned: false);
      const email = "test@test.fr";
      player.gravatarProfilePicture = email;
      player.useGravatarProfilePicture = true;
      expect(player.profilePicture,
          'https://gravatar.com/avatar/1d2ab164559aaf8a30eebf516d2f63ad?s=200');
    });

    test('Use normal profile picture', () {
      final player = Player(owned: false);
      expect(player.profilePicture,
          'https://firebasestorage.googleapis.com/v0/b/carg-d3732.appspot.com/o/carg_logo.png?alt=media&token=861511da-db26-4216-8ee6-29b20c0a6852');
    });

    test('Hash email for Gravatar', () {
      final player = Player(owned: false);
      const email = "test@test.fr";
      player.gravatarProfilePicture = email;
      expect(player.gravatarProfilePicture,
          'https://gravatar.com/avatar/1d2ab164559aaf8a30eebf516d2f63ad?s=200');
    });
  });
}
