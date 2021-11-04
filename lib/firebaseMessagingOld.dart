// final _firestore = FirebaseFirestore.instance;
// String? fcmToken;
//
// FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
// //void navigateToItemDetail=navigateToItemDetail()
//
// class FireBaseMessagingClass {
//   BuildContext homeScontext;
//   FireBaseMessagingClass(this.homeScontext);
//   void firebaseConfigure() {
//     firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         FToast().init(NavKey.navKey.currentContext!);
//         FToast().showToast(
//           child: Container(
//             alignment: Alignment.center,
//             height: 35,
//             child: Column(
//               children: [
//                 Text(
//                   '${message['data']['title']}',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(height: 10),
//                 Text('${message['data']['body']}'),
//               ],
//             ),
//             color: Colors.greenAccent.withOpacity(0.8),
//           ),
//           gravity: ToastGravity.CENTER,
//           toastDuration: Duration(seconds: 2),
//         );
//         print("onMessage: ${message['data']['title']}");
//       },
//       onBackgroundMessage: myBackgroundMessageHandler,
//       onLaunch: (Map<String, dynamic> message) async {
//         firebaseMessaging.onTokenRefresh;
//
//         print("onMessageLaunc: ${message['data']['page']}");
//         String? _route = await message['data']['screen'];
//         print('messaging finished');
//       },
//       onResume: (Map<String, dynamic> message) async {
//         firebaseMessaging.onTokenRefresh;
//
//         print('fcm onResume');
//         String? _route = await message['data']['page'];
//         print('messaging finished');
//       },
//     );
//   }
//
//   void fcmSubscribe() {
//     firebaseMessaging.subscribeToTopic('all');
//   }
//
//   Future<String> getFirebaseToken() async {
//     firebaseMessaging.subscribeToTopic('all');
//     String? token = await firebaseMessaging.getToken();
//     print('tolken $token');
//     return token!;
//   }
//
//   update(String token) {
//     print(token);
// //    new DateTime.now()
//     fcmToken = token;
//
// //    _firestore.collection('tokens').document('$id').setData({
// //      'token': token,
// //    });
//   }
// }
//
// Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   if (message.containsKey('data')) {
//     // Handle data message
// //    final dynamic data = message['data'];
//   }
//
//   if (message.containsKey('notification')) {
//     // Handle notification message
// //    final dynamic notification = message['notification'];
//   }
//
//   // Or do other work.
// }
