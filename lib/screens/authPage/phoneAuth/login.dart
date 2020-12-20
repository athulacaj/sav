import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sav/providers/provider.dart';
import 'package:sav/screens/authPage/auth/ExtractedButton.dart';
import 'package:sav/screens/path/user/homeScreen/homeScreen.dart';
import 'autoVerify.dart';
import 'newUser.dart';

class PhoneLoginScreen extends StatefulWidget {
  static String id = 'Login_Screen';

  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('91');

  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  var _forceCodeResendToken;
  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _showSpinner = true;
    setState(() {});
    await Future.delayed(Duration(milliseconds: 500));

    _auth.verifyPhoneNumber(
      phoneNumber: '+${_selectedDialogCountry.phoneCode}' + phone,
      timeout: Duration(seconds: 100),
      verificationCompleted: (AuthCredential credential) async {
        print(credential);
        var result = await _auth.signInWithCredential(credential);
        var user = result.user;
        if (user != null) {
          Map _userDetails = {
            'name': '${user.phoneNumber}',
            'image': '',
            'email': '${user.phoneNumber}',
            'uid': user.uid
          };
          _showSpinner = false;
          setState(() {});
          afterVerification(context, user.uid, user.phoneNumber);
        }

        //This callback would gets called when verification is done automaticlly
      },
      verificationFailed: (exception) {
        _showSpinner = false;
        setState(() {});
        return Fluttertoast.showToast(
            msg: '${exception.code}', backgroundColor: Colors.black45);
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        print('code send');
        _showSpinner = false;
        setState(() {});

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              String num = _phoneController.text;
              var size = MediaQuery.of(context).size;
              return StatefulBuilder(builder: (context, StateSetter setState) {
                return ModalProgressHUD(
                  inAsyncCall: _showSpinner,
                  child: Material(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Autoverify(
                        size: size,
                        child: Material(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Hero(
                                  tag: 'logo',
                                  child: Container(
                                    child: Image.asset('assets/logo.png'),
                                    height: 70.0,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                    'Enter OTP received on +${_selectedDialogCountry.phoneCode}${_phoneController.text}'),
                                SizedBox(height: 20),

                                Stack(
                                  children: [
                                    Container(
                                      height: 70,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: PinEntryTextField(
                                          fields: 6,
                                          showFieldAsBox: true,
                                          onSubmit: (String pin) {
                                            //end showDialog()
                                            _codeController.text = pin;
                                          }, // end onSubmit
                                        ), // end PinEntryTextField()
                                      ), // end Padding()
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20), // en
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Container(
                                          height: 40,
                                          width: 90,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Color(0xff36b58b),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          child: Text(
                                            "Confirm",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      onTap: () async {
                                        final code =
                                            _codeController.text.trim();
                                        if (code.length == 6) {
                                          _showSpinner = true;
                                          setState(() {});
                                          await Future.delayed(
                                              Duration(milliseconds: 500));
                                        }
                                        try {
                                          AuthCredential credential =
                                              PhoneAuthProvider.credential(
                                                  verificationId:
                                                      verificationId,
                                                  smsCode: code);

                                          var result = await _auth
                                              .signInWithCredential(credential);

                                          if (result == null) {}
                                          var user = result.user;
                                          Map _userDetails = {
                                            'name': '${user.phoneNumber}',
                                            'image': '',
                                            'email': '${user.phoneNumber}',
                                            'uid': user.uid
                                          };

                                          if (user != null) {
                                            afterVerification(context, user.uid,
                                                user.phoneNumber);
                                          } else {
                                            print("Error");
                                          }
                                        } catch (e) {
                                          _showSpinner = false;
                                          setState(() {});
                                          Fluttertoast.showToast(
                                              msg:
                                                  "ERROR: Check your OTP and connection ");
                                        }
                                      },
                                    ),
                                    SizedBox(width: 20),
                                    ArgonTimerButton(
                                      height: 40,
                                      width: 90,
                                      minWidth: 90,
                                      highlightColor: Colors.transparent,
                                      highlightElevation: 0,
                                      roundLoadingShape: false,
                                      onTap: (startTimer, btnState) async {
                                        if (btnState == ButtonState.Idle) {
                                          // Navigator.pop(context);

                                          resendOtp();
                                        }
                                      },
                                      initialTimer: 100,
                                      child: Text(
                                        "Resend",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      loader: (timeLeft) {
                                        return Text(
                                          "Resend $timeLeft",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        );
                                      },
                                      borderRadius: 5.0,
                                      color: Colors.transparent,
                                      elevation: 0,
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
            });
        _forceCodeResendToken = forceResendingToken;
      },
      // forceResendingToken: _forceCodeResendToken,
      codeAutoRetrievalTimeout: (String verificationId) {
        print('i dont know');
        // Auto-resolution timed out...
      },
    );
  }

  void resendOtp() async {
    _showSpinner = true;
    setState(() {});
    Navigator.pop(context);
    await loginUser(_phoneController.text.trim(), context);
    await Future.delayed(Duration(milliseconds: 1000));
    _showSpinner = false;
    setState(() {});
  }

  bool _showSpinner = false;
  @override
  void initState() {
    _showSpinner = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height - 30,
            width: size.width,
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: Container(
                          child: Image.asset('assets/logo.png'),
                          height: 130.0,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 68,
                            child: Stack(
                              children: [
                                FlatButton(
                                  onPressed: _openCountryPickerDialog,
                                  child: Text(
                                      '+${_selectedDialogCountry.phoneCode}'),
                                ),
                                Positioned(
                                    bottom: 15,
                                    right: 0,
                                    child: Icon(Icons.arrow_drop_down)),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (size.width - 92) - 70,
                            child: Container(
                              height: 50,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: "Mobile Number"),
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: 1,
                          width: (size.width - 92) - 70 + 68,
                          color: Colors.black12),
                      SizedBox(
                        height: 5,
                      ),
                      ExtractedButton(
                        text: 'Login',
                        colour: Color(0xff36b58b),
                        onclick: () async {
                          final phone = _phoneController.text.trim();
                          print(phone);
                          loginUser(phone, context);
                        },
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Color(0xff36b58b)),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(10.0),
            searchCursorColor: Color(0xff36b58b),
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            // title: Text('Select your phone code'),
            onValuePicked: (Country country) =>
                setState(() => _selectedDialogCountry = country),
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('IN'),
              CountryPickerUtils.getCountryByIsoCode('AE'),
              CountryPickerUtils.getCountryByIsoCode('SA'),
              CountryPickerUtils.getCountryByIsoCode('QA'),
            ],
          ),
        ),
      );
  Widget _buildDialogItem(Country country) => SizedBox(
        height: 35,
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            // SizedBox(width: 8.0),
            // Text("+${country.phoneCode}"),
            SizedBox(width: 8.0),
            Flexible(child: Text(country.name))
          ],
        ),
      );
}

void afterVerification(BuildContext context, String uid, String phoneNo) async {
  // Provider.of<IsInList>(context,
  //     listen: false)
  //     .addUser(_userDetails);
  // _showSpinner = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot snap = await firestore.collection('users').doc(uid).get();
  print('exists ${snap.exists}');
  if (!snap.exists) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => NewUser(
                  uid: uid,
                  phoneNo: phoneNo,
                )));
  } else {
    Map userData = snap.data();
    Map _userDetails = {
      'phone': userData['phone'],
      'name': userData['name'],
      'town': userData['town'],
      'shopName': userData['shopName'],
      'email': userData['phone'],
      'uid': userData['uid'],
      'isAdmin': userData['isAdmin'],
    };
    Provider.of<IsInList>(context, listen: false).addUser(_userDetails);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
