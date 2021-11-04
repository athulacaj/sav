import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

final String serverToken =
    'AAAA3KXyubU:APA91bF7sVQUR2X8ivi1L2qSDe9meXZPLRZkiMX4KAIHv-myUeI6Wqj9CPTc9pXe7Ahtoc56-sM6VGhLDPR9J1HdNn7LFyCR013gJK48bpDRU8bC-MVJKGGewOiTsBH6VExHrT_asy51';

// Future<void> sendAndRetrieveMessage(
//     String title, String body, String topic) async {
//   String toParams = "/topics/" + topic;
//
//   await http.post(
//     Uri.parse('https://fcm.googleapis.com/fcm/send'),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverToken',
//     },
//     body: jsonEncode(
//       <String, dynamic>{
//         'notification': <String, dynamic>{
//           'body': '$body',
//           'title': '$title',
//           "sound": "default"
//         },
//         'priority': 'high',
//         'data': <String, dynamic>{
//           'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//           "sound": "default",
//           'id': '1',
//           // "screen": "orders",
//           'status': 'done'
//         },
//         "to": "$toParams",
//         // 'to':
//         //     'cE6oR4S5QUuv39PAv-mjif:APA91bFfNnGRDNjvy-CKo4m4DEkAmWj7O7yAMXCg6hfw1pNsOukgBFsd3iDH1u6HhFLd9Rx-X2eQbqeaufY5Wa1rk4QYlRgNQ_fPCbalFNurpCJgCgE7nn3kUmzyKwhF-ppA7_Ixk-H-'
//       },
//     ),
//   );
// }

Future<void> sendAndRetrieveMessage(
    String title, String body, String topic) async {
  String toParams = "/topics/" + topic;

  String api =
      "AAAA3KXyubU:APA91bF7sVQUR2X8ivi1L2qSDe9meXZPLRZkiMX4KAIHv-myUeI6Wqj9CPTc9pXe7Ahtoc56-sM6VGhLDPR9J1HdNn7LFyCR013gJK48bpDRU8bC-MVJKGGewOiTsBH6VExHrT_asy51";

  try {
    http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$api',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          // 'to': _token,
          "to": "$toParams",
        },
      ),
    );
    print("msg send successfully " + response.body);
  } catch (e) {
    print("error push notification");
  }
}
