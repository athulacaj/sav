import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'manageItems/addItems/addItemsIndex.dart';
import 'manageItems/editItems/editItems.dart';
import 'manageItems/extracted.dart';
import 'orders/AllOders.dart';
import 'print/widgetToImage.dart';
import 'print/test.dart';

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
          child: Column(
            children: [
              HomeBox(
                icon: Icons.menu_book,
                title: 'Orders',
                onclick: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AllOrders()));
                },
              ),
              SizedBox(height: 15),
              FlatButton(
                child: Text('print'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Print()));
                },
                color: Colors.blueAccent,
              ),
              SizedBox(height: 15),
              HomeBox(
                icon: Icons.add,
                title: 'Add items',
                onclick: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddItemsIndex()));
                },
              ),
              SizedBox(height: 25),
              Divider(),
              Text('Edit Items'),
              SizedBox(height: 15),
              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: EditBox(
                          image: 'assets/vegetables.jpg', title: 'Vegetables'),
                      onTap: () async {
                        _showSpinner = true;
                        setState(() {});
                        DocumentSnapshot doc = await _firestore
                            .collection('items')
                            .doc('vegetables')
                            .get();
                        List allInfo = doc.data()['allInfo'];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => EditItems(
                                      allInfo: allInfo,
                                      category: 'vegetables',
                                    )));
                        _showSpinner = false;
                        setState(() {});
                      },
                    ),
                    GestureDetector(
                      child: EditBox(
                          image: 'assets/unakameen.jpg', title: 'Dry Fish '),
                      onTap: () async {
                        _showSpinner = true;
                        setState(() {});
                        DocumentSnapshot doc = await _firestore
                            .collection('items')
                            .doc('driedFish')
                            .get();
                        List allInfo = doc.data()['allInfo'];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => EditItems(
                                      allInfo: allInfo,
                                      category: 'driedFish',
                                    )));
                        _showSpinner = false;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onclick;
  HomeBox({this.icon, this.title, this.onclick});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: InkWell(
        onTap: onclick,
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
