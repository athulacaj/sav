import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav/providers/allOrdersProvider.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';
import 'customers/viewCoustomersIndex.dart';
import 'manageItems/addItems/addItemsIndex.dart';
import 'manageItems/editItems/editItemsIndex.dart';
import 'manageItems/extracted.dart';
import 'orders/AllOders.dart';
import 'package:sav/screens/path/admin/addAds/addAds.dart';
import 'package:sav/screens/path/admin/addAds/manageAds.dart';
import 'package:sav/screens/path/admin/send notification/sendNotification.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AdminHomeScreen extends StatefulWidget {
  static String id = 'AdminHomeScreen';

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool _showSpinner = false;
  @override
  void initState() {
    _showSpinner = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff36b58b),
          title: Text('Admin Pannel'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeBox(
                  icon: Icons.menu_book,
                  width: double.infinity,
                  title: 'Orders',
                  onclick: () async {
                    _showSpinner = true;
                    setState(() {});
                    await AllOrdersProvider.getOnce();
                    _showSpinner = false;
                    setState(() {});
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AllOrders()));
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    HomeBox(
                      icon: Icons.add,
                      width: (size.width / 2) - 20,
                      title: 'Add items',
                      onclick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddItemsIndex()));
                      },
                    ),
                    SizedBox(width: 16),
                    HomeBox(
                      icon: Icons.business,
                      title: 'Customers',
                      width: (size.width / 2) - 20,
                      onclick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewCustomers()));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                Text('Edit Items'),
                SizedBox(height: 15),
                SizedBox(
                  width: size.width,
                  height: size.width / 3,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      editItemBox("vegetables.jpg", "Vegetables", "vegetables"),
                      SizedBox(width: 13),
                      editItemBox("unakameen.jpg", "Dry Fish", "driedFish"),
                      SizedBox(width: 13),
                      editItemBox("fruits.jpg", "Fruits", "fruits"),
                      SizedBox(width: 13),
                      editItemBox("other.png", "Other Items", "others"),
                      SizedBox(width: 13),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(),
                Row(
                  children: [
                    FlatButton(
                      color: Colors.lightBlue,
                      child: Text(
                        'Add ads',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAds('add ads')));
                      },
                    ),
                    Spacer(),
                    FlatButton(
                      color: Colors.lightBlue,
                      child: Text(
                        'Manage Ads',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ManageAds('Manage Ads')));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15),
                FlatButton(
                  color: Colors.lightBlue,
                  child: Text(
                    'Send notification',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SendPushNotification()));
                  },
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editItemBox(String image, String title, String docId) {
    return GestureDetector(
      child: EditBox(image: 'assets/$image', title: '$title'),
      onTap: () async {
        _showSpinner = true;
        setState(() {});
        DocumentSnapshot<Map> doc =
            await _firestore.collection('items').doc('$docId').get();
        List? allInfo = doc.data()!['allInfo'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => EditItems(
                      allInfo: allInfo,
                      category: '$docId',
                    )));
        _showSpinner = false;
        setState(() {});
      },
    );
  }
}

class HomeBox extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final Function? onclick;
  final double width;
  HomeBox({this.icon, this.title, this.onclick, required this.width});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: width,
      child: InkWell(
        onTap: onclick as void Function()?,
        child: Material(
          elevation: 4,
          color: Colors.white,
          child: SizedBox(
              height: 100,
              child: Container(
                  child: Column(
                children: [
                  Icon(
                    icon,
                    size: 50,
                  ),
                  Text('$title'),
                ],
              ))),
        ),
      ),
    );
  }
}
