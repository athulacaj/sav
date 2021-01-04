import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'sendFcm.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SendPushNotification extends StatefulWidget {
  @override
  _SendPushNotificationState createState() => _SendPushNotificationState();
}

class _SendPushNotificationState extends State<SendPushNotification> {
  bool _showSpinner = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showSpinner = false;
  }

  String title, body;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Send Notification'),
                SizedBox(height: 30),
                SizedBox(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: textFieldDecoration.copyWith(
                        hintText: 'title',
                      ),
                      onChanged: (value) {
                        title = value;
                      },
                    ),
                    width: size.width - 20),
                SizedBox(height: 20),
                SizedBox(
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1, //Normal textInputField will be displayed
                      maxLines: 5,
                      decoration: textFieldDecoration.copyWith(
                        hintText: 'enter body of notification',
                      ),
                      onChanged: (value) {
                        body = value;
                      },
                    ),
                    width: size.width - 20),
                Spacer(),
                TextButton(
                  child: Text('Send'),
                  onPressed: () async {
                    print('body $body');
                    _showSpinner = true;
                    setState(() {});
                    bool result =
                        await sendAndRetrieveMessage(title, body, 'all');
                    print(result);

                    await Future.delayed(Duration(seconds: 1));
                    _showSpinner = false;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration textFieldDecoration = InputDecoration(
  hintText: '',
  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 12),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black12),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black12),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black12),
  ),
);
