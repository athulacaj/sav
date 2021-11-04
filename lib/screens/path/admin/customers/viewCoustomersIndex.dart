import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav/screens/path/admin/customers/manageArea.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';
import 'package:sav/widgets/bottomNavButton.dart';
import 'package:url_launcher/url_launcher.dart';

import 'addCoustomer.dart';
import 'customersDatabase.dart';

class ViewCustomers extends StatefulWidget {
  @override
  _ViewCustomersState createState() => _ViewCustomersState();
}

String _area = 'all';
List<String> _areaList = [];
int selectedCustomerIndex = -1;
int selectedAreaIndex = -1;
bool _showSpinner = false;

class _ViewCustomersState extends State<ViewCustomers> {
  @override
  void initState() {
    super.initState();
    _area = 'all';
    selectedCustomerIndex = -1;
    selectedAreaIndex = 0;
    _showSpinner = false;
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> customersList = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(_area);
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff36b58b),
          title: Text('Customers'),
        ),
        body: StreamBuilder(
          stream: _area == 'all'
              ? FirebaseFirestore.instance
                  .collection("customers")
                  .orderBy("name", descending: false)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection("customers")
                  .where("area", isEqualTo: _area)
                  .orderBy("name", descending: false)
                  .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            customersList = snapshot.data!.docs;
            if (customersList.isNotEmpty &&
                customersList[0].data().containsKey("areaList")) {
              _areaList = [];
              for (String area in customersList[0]['areaList']) {
                _areaList.add(area);
              }
            } else {}
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                      height: 30,
                      child: ListView.builder(
                        itemCount: _areaList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int i) {
                          return MaterialButton(
                              color: selectedAreaIndex == i
                                  ? Colors.greenAccent
                                  : Colors.white,
                              onPressed: () {
                                selectedAreaIndex = i;
                                _area = _areaList[i];
                                customersList = [];
                                setState(() {});
                              },
                              child: Text(_areaList[i]));
                        },
                      )),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: customersList.length,
                        itemBuilder: (BuildContext context, int i) {
                          return _area == "all" && i == 0
                              ? Container() // at index 0 the area list
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      selectedCustomerIndex = i;
                                      setState(() {});
                                    },
                                    child: Container(
                                      color: selectedCustomerIndex == i
                                          ? Colors.blue
                                          : Colors.grey.withOpacity(.1),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: AutoSizeText(
                                                customersList[i]["name"],
                                                maxLines: 2),
                                          ),
                                          SizedBox(width: 6),
                                          Text(customersList[i]["area"]),
                                          SizedBox(width: 12),
                                          IconButton(
                                              onPressed: () async {
                                                String url =
                                                    "tel:${customersList[i]["phone"]}";
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                              icon: Icon(
                                                Icons.phone,
                                                size: 30,
                                                color: Colors.blueAccent,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        }),
                  ),
                  SizedBox(
                    height: 50,
                    child: selectedCustomerIndex == -1
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BottomNavButton(
                                  title: "Manage Area",
                                  icon: Icons.add_location,
                                  onClick: () {
                                    ManageAreaClass.show(context, _areaList);
                                  }),
                              BottomNavButton(
                                  title: "Add Customer",
                                  icon: Icons.add_business_outlined,
                                  onClick: () {
                                    AddCustomerClass.show(context, _areaList);
                                  }),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BottomNavButton(
                                  title: "cancel",
                                  icon: Icons.cancel_outlined,
                                  onClick: () {
                                    selectedCustomerIndex = -1;
                                    setState(() {});
                                  }),
                              BottomNavButton(
                                  title: "Delete",
                                  icon: Icons.delete_forever,
                                  onClick: () async {
                                    _showSpinner = true;
                                    setState(() {});
                                    CustomersDatabase.deleteCustomer(
                                        customersList[selectedCustomerIndex]
                                            .id);
                                    selectedCustomerIndex = -1;
                                    _showSpinner = false;
                                    setState(() {});
                                  }),
                            ],
                          ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
