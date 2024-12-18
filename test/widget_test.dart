// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sav/main.dart';
import 'package:sav/screens/authPage/phoneAuth/login.dart';
import 'package:sav/screens/path/user/homeScreen/home.dart';

void main() {
  testWidgets('Testing app', (WidgetTester tester) async {
    // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()

    await tester.pumpWidget(MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new PhoneLoginScreen()),
    ));

    expect(find.text('Login'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '9061647045');
    await tester.tap(find.text("Login"));

    // expect(find.text('SAV Online'), findsOneWidget);

    Widget home = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new HomeScreen()));

    // Create the Finders.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');
  });
  //
  // Widget testWidget = new MediaQuery(
  //     data: new MediaQueryData(),
  //     child: new MaterialApp(home: new PhoneLoginScreen()));

  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {

  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());
  //   // Verify that our counter starts at 0.
  //   expect(find.text('Login'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}
