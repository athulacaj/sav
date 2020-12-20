import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

String toParams = "/topics/" + 'admin';
final String serverToken =
    'AAAAjPSnzwY:APA91bHxxk95LhD2Mb_-pRFpbDgUOLjokec8bcI7d7hdvmqSmrm4gqq3tk308U1pCWIImLHj47x5_i29NuFsMe0mArSj9l1qtiZHxfzKNcRxSineKm3i1SCOEkhojX1G2HW_iePJ-1l0';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future<Map<String, dynamic>> sendAndRetrieveMessage(
    String fcmId, String message, String title) async {
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false),
  );

  await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': '$message',
          'title': title,
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'screen': 'orders'
        },
        // "to": "$toParams"
        'to': fcmId,
        // 'cE6oR4S5QUuv39PAv-mjif:APA91bFfNnGRDNjvy-CKo4m4DEkAmWj7O7yAMXCg6hfw1pNsOukgBFsd3iDH1u6HhFLd9Rx-X2eQbqeaufY5Wa1rk4QYlRgNQ_fPCbalFNurpCJgCgE7nn3kUmzyKwhF-ppA7_Ixk-H-'
      },
    ),
  );

  final Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      completer.complete(message);
    },
  );

  return completer.future;
}
