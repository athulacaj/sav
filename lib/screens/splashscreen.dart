import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authPage/phoneAuth/login.dart';
import 'package:sav/screens/path/user/homeScreen/home.dart';

import 'path/admin/adminHomeScreen.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
List homeAdsFromSplash = [];
List meatAdsFromSplash = [];
bool _showSpinner = true;
final FirebaseAuth auth = FirebaseAuth.instance;

class SplashScreenWindow extends StatefulWidget {
  static String id = 'Splash_Screen';

  @override
  _SplashScreenWindowState createState() => _SplashScreenWindowState();
}

class _SplashScreenWindowState extends State<SplashScreenWindow> {
  @override
  void initState() {
    initFunctions();
    super.initState();
  }

  initFunctions() {
    firebaseFunctions();
  }

  Future<bool> getUserDataAndNotifications() async {
    final localData = await SharedPreferences.getInstance();
    String userData = localData.getString('userNew') ?? '';
    print('splash scren: $userData');
    if (userData == "null" || userData == '') {
      return false;
    } else {
      Map? user = jsonDecode(userData);
      Provider.of<IsInListProvider>(context, listen: false).addUser(user);
      return true;
    }
  }

  firebaseFunctions() async {
    await Firebase.initializeApp();
    // FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
    // await FirebaseFirestore.instance.clearPersistence();
    bool _isLogined = await getUserDataAndNotifications();
    await Future.delayed(Duration(seconds: 1));
    if (_isLogined == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PhoneLoginScreen()));
    } else {
      try {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: RouteSettings(name: HomeScreen.id),
            builder: (context) => HomeScreen(),
          ),
        );
      } catch (e) {}
    }

    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => HomeScreen(
    //               meatAds: meatAdsFromSplash,
    //               homeAds: homeAdsFromSplash,
    //             )));
    _showSpinner = false;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        backgroundColor: Color(0xff36b58b),
        body: Center(
          child: Image.asset('assets/splash.png'),
        ),
      ),
    );
  }
}
