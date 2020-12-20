// import 'package:flutter/material.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// // Future<int>.delayed(
// //   Duration(seconds: 2),
// //   () => 4,
// // );
//
// Widget checkShopClosed(String open, String close, String shopName,
//     bool automatic, BuildContext context) {
//   tz.initializeTimeZones();
//   var detroit = tz.getLocation('Asia/Kolkata');
//   DateTime now = tz.TZDateTime.now(detroit);
//   int nowHour = now.hour;
//
//   int weekDay = new DateTime.now().weekday;
//
// //  automatic = false;
// //  weekDay = 6;
//   int nowMinute = new DateTime.now().minute;
//   int closingHour = int.parse(close.split(':')[0]);
// //  closingHour = 18;
//   int openingHour = int.parse(open.split(':')[0]);
//
// //checking automatic close on monday
//   if (automatic == true) {
//     if (weekDay == 6 && nowHour > closingHour) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text('$shopName -',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//               SizedBox(width: 6),
//               Text(
//                 'Closed',
//                 style: TextStyle(color: Colors.redAccent),
//               ),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Icon(Icons.access_time, color: Colors.black54, size: 15),
//               Text(
//                 ' Opens at Monday ${openingHour + 0}:00 AM',
//                 style: TextStyle(color: Colors.black54),
//               ),
//             ],
//           ),
//         ],
//       );
//     }
//     if (weekDay == 7) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text('$shopName -',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//               SizedBox(width: 6),
//               Text(
//                 'Closed',
//                 style: TextStyle(color: Colors.redAccent),
//               ),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Icon(Icons.access_time, color: Colors.black54, size: 15),
//               Text(
//                 ' Opens at Monday ${openingHour + 0}:00 AM',
//                 style: TextStyle(color: Colors.black54),
//               ),
//             ],
//           ),
//         ],
//       );
//     }
//   }
//   if (nowHour < openingHour) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text('$shopName -',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//             SizedBox(width: 6),
//             Text(
//               'Closed',
//               style: TextStyle(color: Colors.redAccent),
//             ),
//           ],
//         ),
//         SizedBox(height: 2),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Icon(Icons.access_time, color: Colors.black54, size: 15),
//             Text(
//               ' Opens at today ${openingHour + 0}:00 AM',
//               style: TextStyle(color: Colors.black54),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//   if (nowHour >= closingHour) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text('$shopName -',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//             SizedBox(width: 6),
//             Text(
//               'Closed',
//               style: TextStyle(color: Colors.redAccent),
//             ),
//           ],
//         ),
//         SizedBox(height: 2),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Icon(Icons.access_time, color: Colors.black54, size: 15),
//             Text(
//               ' Opens at tomorrow ${openingHour + 0}:00 AM',
//               style: TextStyle(color: Colors.black54),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         children: [
//           Text('$shopName -',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//           SizedBox(width: 6),
//           Text(
//             'Opened',
//             style: TextStyle(color: Colors.green),
//           ),
//         ],
//       ),
//       SizedBox(height: 2),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Icon(Icons.access_time, color: Colors.black54, size: 15),
//           Text(
//             ' Closes at ${closingHour - 12}:00 PM',
//             style: TextStyle(color: Colors.black54),
//           ),
//         ],
//       ),
//     ],
//   );
// }
//
// bool isClosed(String open, String close, String shopName, bool automatic) {
//   tz.initializeTimeZones();
//   var detroit = tz.getLocation('Asia/Kolkata');
//   DateTime now = tz.TZDateTime.now(detroit);
//   int nowHour = now.hour;
//
//   int weekDay = new DateTime.now().weekday;
//   int nowMinute = new DateTime.now().minute;
//   int closingHour = int.parse(close.split(':')[0]);
// //  closingHour = 18;
//   int openingHour = int.parse(open.split(':')[0]);
//   bool isClosed = false;
//   if (automatic == true) {
//     if (weekDay == 6 && nowHour > closingHour) {
//       return true;
//     }
//     if (weekDay == 7) {
//       return true;
//     }
//   }
//   if (nowHour >= closingHour || nowHour < openingHour) {
//     return true;
//   }
//   return false;
// }
