import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';
import 'package:addressed_pro/flutter_flow/flutter_flow_drop_down.dart';
import 'package:addressed_pro/flutter_flow/flutter_flow_icon_button.dart';
import 'package:addressed_pro/flutter_flow/flutter_flow_widgets.dart';
import 'package:addressed_pro/flutter_flow/flutter_flow_theme.dart';
import 'package:addressed_pro/index.dart';
import 'package:addressed_pro/main.dart';
import 'package:addressed_pro/flutter_flow/flutter_flow_util.dart';

import 'package:provider/provider.dart';
import 'package:addressed_pro/backend/firebase/firebase_config.dart';
import 'package:addressed_pro/auth/firebase_auth/auth_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initFirebase();
  });

  setUp(() async {
    await authManager.signOut();
    FFAppState.reset();
    final appState = FFAppState();
    await appState.initializePersistedState();
  });

  group('Authentication', () {
    testWidgets('User Login to Dashboard', (WidgetTester tester) async {
      _overrideOnError();

      await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => FFAppState(),
        child: const MyApp(),
      ));
      await GoogleFonts.pendingFonts();

      await tester.pumpAndSettle(const Duration(milliseconds: 5000));
      await tester.enterText(
          find.byKey(const ValueKey('emailAddress_Create_16cu')),
          'nonadmin@aol.com');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.enterText(
          find.byKey(const ValueKey('password_Create_bluj')), 'password');
      await tester.tap(find.byKey(const ValueKey('Button_40te')));
      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      expect(find.byKey(const ValueKey('dashboardWelcome')), findsWidgets);
    });

    testWidgets('Not Signed Agreement', (WidgetTester tester) async {
      _overrideOnError();

      await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => FFAppState(),
        child: const MyApp(),
      ));
      await GoogleFonts.pendingFonts();

      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      await tester.enterText(
          find.byKey(const ValueKey('emailAddress_Create_16cu')),
          'notsignedagreement@aol.com');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.enterText(
          find.byKey(const ValueKey('password_Create_bluj')), 'password');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.tap(find.byKey(const ValueKey('Button_40te')));
      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      expect(
          find.byKey(const ValueKey('signAgreementPageTitle')), findsWidgets);
    });

    testWidgets('Not Entered Retirment Goals', (WidgetTester tester) async {
      _overrideOnError();

      await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => FFAppState(),
        child: const MyApp(),
      ));
      await GoogleFonts.pendingFonts();

      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      await tester.enterText(
          find.byKey(const ValueKey('emailAddress_Create_16cu')),
          'noretirementgoals@aol.com');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.enterText(
          find.byKey(const ValueKey('password_Create_bluj')), 'password');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.tap(find.byKey(const ValueKey('Button_40te')));
      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      expect(find.byKey(const ValueKey('onboardingPageTitle')), findsWidgets);
    });

    testWidgets('Not Signed or Entered Retirement Goals',
        (WidgetTester tester) async {
      _overrideOnError();

      await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => FFAppState(),
        child: const MyApp(),
      ));
      await GoogleFonts.pendingFonts();

      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      await tester.enterText(
          find.byKey(const ValueKey('emailAddress_Create_16cu')),
          'nosignretirement@aol.com');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.enterText(
          find.byKey(const ValueKey('password_Create_bluj')), 'password');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.tap(find.byKey(const ValueKey('Button_40te')));
      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      expect(
          find.byKey(const ValueKey('signAgreementPageTitle')), findsWidgets);
      await tester.tap(find.byKey(const ValueKey('Button_mn0q')));
      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      expect(find.byKey(const ValueKey('onboardingPageTitle')), findsWidgets);
    });

    testWidgets('Change Password', (WidgetTester tester) async {
      _overrideOnError();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'nonadmin@aol.com', password: 'password');
      await tester.pumpWidget(ChangeNotifierProvider(
        create: (context) => FFAppState(),
        child: const MyApp(),
      ));
      await GoogleFonts.pendingFonts();

      await tester.tap(find.byKey(const ValueKey('Container_raul')));
      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      await tester.tap(find.byKey(const ValueKey('Button_2jig')));
      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      await tester.enterText(
          find.byKey(const ValueKey('new_password_akfo')), 'password1');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.enterText(
          find.byKey(const ValueKey('confirm_new_password_e0uv')), 'password1');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.tap(find.byKey(const ValueKey('updatePasswordButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 5000));
      await tester.tap(find.byKey(const ValueKey('logOutButton')));
      await tester.pumpAndSettle(const Duration(milliseconds: 5000));
      await tester.enterText(
          find.byKey(const ValueKey('emailAddress_Create_16cu')),
          'nonadmin@aol.com');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.enterText(
          find.byKey(const ValueKey('password_Create_bluj')), 'password1');
      await tester.tap(find.byKey(const ValueKey('Button_40te')));
      await tester.pumpAndSettle(const Duration(milliseconds: 3000));
      expect(find.byKey(const ValueKey('dashboardWelcome')), findsWidgets);
    });
  });
}

// There are certain types of errors that can happen during tests but
// should not break the test.
void _overrideOnError() {
  final originalOnError = FlutterError.onError!;
  FlutterError.onError = (errorDetails) {
    if (_shouldIgnoreError(errorDetails.toString())) {
      return;
    }
    originalOnError(errorDetails);
  };
}

bool _shouldIgnoreError(String error) {
  // It can fail to decode some SVGs - this should not break the test.
  if (error.contains('ImageCodecException')) {
    return true;
  }
  // Overflows happen all over the place,
  // but they should not break tests.
  if (error.contains('overflowed by')) {
    return true;
  }
  // Sometimes some images fail to load, it generally does not break the test.
  if (error.contains('No host specified in URI') ||
      error.contains('EXCEPTION CAUGHT BY IMAGE RESOURCE SERVICE')) {
    return true;
  }
  // These errors should be avoided, but they should not break the test.
  if (error.contains('setState() called after dispose()')) {
    return true;
  }
  // Web-specific error when interacting with TextInputType.emailAddress
  if (error.contains('setSelectionRange') &&
      error.contains('HTMLInputElement')) {
    return true;
  }

  return false;
}
