import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'package:sav/providers/searchProvider.dart';
import 'package:sav/screens/splashscreen.dart';
import 'screens/path/user/homeScreen/homeScreen.dart';
import 'screens/path/admin/adminHomeScreen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => IsInList()),
    ChangeNotifierProvider(create: (context) => SearchProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff36b58b),
        statusBarIconBrightness: Brightness.dark));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreenWindow.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        SplashScreenWindow.id: (context) => SplashScreenWindow(),
        AdminHomeScreen.id: (context) => AdminHomeScreen(),
      },
    );
  }
}
