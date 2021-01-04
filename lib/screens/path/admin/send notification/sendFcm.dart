import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

final String serverToken =
    'AAAA3KXyubU:APA91bF7sVQUR2X8ivi1L2qSDe9meXZPLRZkiMX4KAIHv-myUeI6Wqj9CPTc9pXe7Ahtoc56-sM6VGhLDPR9J1HdNn7LFyCR013gJK48bpDRU8bC-MVJKGGewOiTsBH6VExHrT_asy51';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future<bool> sendAndRetrieveMessage(
    String title, String body, String topic) async {
  String toParams = "/topics/" + topic;
  // String toParams = "/topics/" + 'ad min';

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
          'body': '$body',
          'title': '$title',
          "sound": "default"
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          "sound": "default",
          'id': '1',
          // "screen": "orders",
          'status': 'done'
        },
        "to": "$toParams",
        // 'to':
        //     'cE6oR4S5QUuv39PAv-mjif:APA91bFfNnGRDNjvy-CKo4m4DEkAmWj7O7yAMXCg6hfw1pNsOukgBFsd3iDH1u6HhFLd9Rx-X2eQbqeaufY5Wa1rk4QYlRgNQ_fPCbalFNurpCJgCgE7nn3kUmzyKwhF-ppA7_Ixk-H-'
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

  return completer.isCompleted;
}
