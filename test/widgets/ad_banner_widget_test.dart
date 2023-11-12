import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/views/widgets/ad_banner_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'ad_banner_widget_test.mocks.dart';

Widget testableWidget(AuthService mockAuthService) => MaterialApp(
    home: ChangeNotifierProvider<AuthService>.value(
        value: mockAuthService,
        builder: (context, _) => const AdBannerWidget(),),);

@GenerateMocks([AuthService])
void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  testWidgets('Display no ad - Android', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    when(mockAuthService.isAdFreeUser()).thenAnswer((_) => Future(() => true));
    await tester.pumpWidget(testableWidget(mockAuthService));
    await tester.pump(const Duration(seconds: 20));
    expect(find.byKey(const ValueKey('adContent')), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('Display no ad - iOS', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    when(mockAuthService.isAdFreeUser()).thenAnswer((_) => Future(() => true));
    await tester.pumpWidget(testableWidget(mockAuthService));
    await tester.pump(const Duration(seconds: 20));
    expect(find.byKey(const ValueKey('adContent')), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });
}
