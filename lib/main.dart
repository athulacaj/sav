import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/allOrdersProvider.dart';
import 'package:sav/providers/provider.dart';
import 'package:sav/providers/searchProvider.dart';
import 'package:sav/screens/splashscreen.dart';
import 'firebaseMessaging.dart';
import 'screens/path/user/CartPage/autoCompleteName.dart';
import 'screens/path/user/homeScreen/home.dart';
import 'screens/path/admin/adminHomeScreen.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'navigatorKey.dart';

final navKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlareCache.doesPrune = false;
  FcmMain.fcmMain();
  FcmMain.onMessageReceived();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => IsInListProvider()),
    ChangeNotifierProvider(create: (context) => SearchProvider()),
    ChangeNotifierProvider(create: (context) => AllOrdersProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff36b58b),
        statusBarIconBrightness: Brightness.light));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreenWindow.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        SplashScreenWindow.id: (context) => SplashScreenWindow(),
        AdminHomeScreen.id: (context) => AdminHomeScreen(),
      },
      navigatorKey: NavKey.navKey,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // primaryColor: Color(0xff36b58b),
        // appBarTheme: AppBarTheme(
        //     brightness: Brightness.light,
        //     color: Color(0xff36b58b),
        //     iconTheme: IconThemeData(color: Colors.white),
        //     textTheme: TextTheme(
        //         headline6: TextStyle(color: Colors.white, fontSize: 16))),
      ),
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
}

Future<void> preCache() async {
  await cachedActor(
    AssetFlare(bundle: rootBundle, name: 'assets/flare/success.flr'),
  );
}
