import 'package:carg/services/auth_service.dart';
import 'package:carg/services/player_service.dart';
import 'package:carg/views/screens/register/register_screen.dart';
import 'package:carg/views/widgets/register/register_email_widget.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

Widget testableWidget() => const MaterialApp(
      home: RegisterScreen(),
    );

@GenerateMocks([PlayerService])
void main() {
  group('Press button', () {
    testWidgets('Email', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget());

      final BuildContext context =
          tester.element(find.byKey(const ValueKey('emailButton')));
      await tester.tap(find.byKey(const ValueKey('emailButton')));
      await tester.pump();

      expect(
          tester
              .widget<AnimatedSize>(
                  find.byKey(const ValueKey('placeholderContainer')))
              .child
              .toString(),
          const RegisterEmailWidget(
                  credentialVerificationType: CredentialVerificationType.CREATE)
              .toString());

      expect(
          tester
              .widget<ElevatedButton>(find.byKey(const ValueKey('emailButton')))
              .style!
              .backgroundColor
              .toString(),
          MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)
              .toString());

      expect(
          tester
              .widget<ElevatedButton>(find.byKey(const ValueKey('phoneButton')))
              .style!
              .backgroundColor
              .toString(),
          MaterialStateProperty.all<Color>(Theme.of(context).cardColor)
              .toString());

      expect(
          tester
              .widget<ElevatedButton>(
                  find.byKey(const ValueKey('googleButton')))
              .style!
              .backgroundColor
              .toString(),
          MaterialStateProperty.all<Color>(Theme.of(context).cardColor)
              .toString());
    });

    testWidgets('Phone', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget());

      final BuildContext context =
          tester.element(find.byKey(const ValueKey('phoneButton')));
      await tester.tap(find.byKey(const ValueKey('phoneButton')));
      await tester.pump();

      expect(
          tester
              .widget<AnimatedSize>(
                  find.byKey(const ValueKey('placeholderContainer')))
              .child
              .toString(),
          const RegisterPhoneWidget(
                  credentialVerificationType: CredentialVerificationType.CREATE)
              .toString());

      expect(
          tester
              .widget<ElevatedButton>(find.byKey(const ValueKey('emailButton')))
              .style!
              .backgroundColor
              .toString(),
          MaterialStateProperty.all<Color>(Theme.of(context).cardColor)
              .toString());

      expect(
          tester
              .widget<ElevatedButton>(find.byKey(const ValueKey('phoneButton')))
              .style!
              .backgroundColor
              .toString(),
          MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)
              .toString());

      expect(
          tester
              .widget<ElevatedButton>(
                  find.byKey(const ValueKey('googleButton')))
              .style!
              .backgroundColor
              .toString(),
          MaterialStateProperty.all<Color>(Theme.of(context).cardColor)
              .toString());
    });
  });
}
