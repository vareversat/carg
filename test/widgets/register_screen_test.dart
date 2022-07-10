import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/views/screens/register/register_screen.dart';
import 'package:carg/views/widgets/register/register_email_widget.dart';
import 'package:carg/views/widgets/register/register_phone_widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'register_screen_test.mocks.dart';

Widget testableWidget(MockFirebaseDynamicLinks linkProvider,
        MockAuthService mockAuthService) =>
    MaterialApp(
      home: ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          builder: (context, _) => RegisterScreen(linkProvider: linkProvider)),
    );

final mockFirebaseDynamicLinks = MockFirebaseDynamicLinks();
final mockPendingDynamicLinkData = MockPendingDynamicLinkData();
final mockAuthService = MockAuthService();

@GenerateMocks([FirebaseDynamicLinks, PendingDynamicLinkData, AuthService])
void main() {
  group('Press button', () {
    testWidgets('Email', (WidgetTester tester) async {
      when(mockFirebaseDynamicLinks.getInitialLink()).thenAnswer((_) async =>
          Future<MockPendingDynamicLinkData>(() => mockPendingDynamicLinkData));
      when(mockPendingDynamicLinkData.link).thenReturn(Uri(host: 'toto.fr'));
      when(mockAuthService.isAlreadyLogin())
          .thenAnswer((_) async => Future<bool>(() => false));

      await tester.pumpWidget(
          testableWidget(mockFirebaseDynamicLinks, mockAuthService));
      final BuildContext context =
          tester.element(find.byKey(const ValueKey('emailButton')));
      await tester.tap(find.byKey(const ValueKey('emailButton')));
      await tester.pumpAndSettle();

      expect(
          tester
              .widget<AnimatedSize>(
                  find.byKey(const ValueKey('placeholderContainer')))
              .child
              .toString(),
          RegisterEmailWidget(
                  credentialVerificationType: CredentialVerificationType.CREATE,
                  linkProvider: mockFirebaseDynamicLinks)
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
      await tester.pumpWidget(
          testableWidget(mockFirebaseDynamicLinks, mockAuthService));

      final BuildContext context =
          tester.element(find.byKey(const ValueKey('phoneButton')));
      await tester.tap(find.byKey(const ValueKey('phoneButton')));
      await tester.pumpAndSettle();

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
