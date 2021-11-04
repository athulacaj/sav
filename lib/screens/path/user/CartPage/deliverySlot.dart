import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sav/functions/showToastFunction.dart';
import 'package:sav/providers/provider.dart';
import 'package:sav/widgets/AutoCompleteTextField.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';
import 'autoCompleteName.dart';
import 'cartDatabase.dart';
import 'orderSucessFulPage.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sav/sendFcm.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DeliverySlot extends StatefulWidget {
  static String id = 'DeliverySlot';

  final List<DocumentSnapshot<Map<String, dynamic>>>? customerDatabaseList;
  DeliverySlot({this.customerDatabaseList});
  @override
  _DeliverySlotState createState() => _DeliverySlotState();
}

class _DeliverySlotState extends State<DeliverySlot> {
  int selected = -1;
  DateTime? _whichDay;
  DateTime? selectedDate;
  bool _showSpinner = false;
  late IsInListProvider isInListProvider;
  late var _allDetailsList;
  late Map _userDetails;
  late TextEditingController _nameController,
      _shopController,
      _areaController,
      _phoneController;
  AutoCompleteNameClass? autoCompleteNameClass;
  GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>> _key =
      new GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>>();
  bool _isNameTextFieldClicked = false;
  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController();
    _shopController = new TextEditingController();
    _areaController = new TextEditingController();
    _phoneController = new TextEditingController();
    selected = -1;
    _showSpinner = false;
    DateTime now = DateTime.now();
    _whichDay = new DateTime(now.year, now.month, now.day + 2);
    _isNameTextFieldClicked = false;
    initFunctions();
  }

  void initFunctions() {
    isInListProvider = Provider.of<IsInListProvider>(context, listen: false);
    _allDetailsList = isInListProvider.allDetails;
    _userDetails = isInListProvider.userDetails!;
    if (isInListProvider.isReOrder) {
      _nameController.text = _userDetails['name'];
      _shopController.text = _userDetails['shopName'];
      _areaController.text = _userDetails['area'];
      _phoneController.text = _userDetails['phone'];
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _whichDay!,
        firstDate: DateTime(now.year, now.month, now.day + 2),
        lastDate: DateTime(now.year, now.month + 1, now.day - 1));
    if (picked != null && picked != _whichDay) _whichDay = picked;
    print('date changed $picked');
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userDetails['isAdmin'] != null && _userDetails['isAdmin']) {
      autoCompleteNameClass = new AutoCompleteNameClass(
          customerDatabaseList: widget.customerDatabaseList!, key: _key);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(_allDetailsList[0]);
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: !_isNameTextFieldClicked
            ? AppBar(
                backgroundColor: Color(0xff36b58b),
                title: Text('Select Delivery Date'),
              )
            : null,
        body: Column(
          children: [
            SizedBox(height: 6),
            _userDetails['isAdmin'] != null && _userDetails['isAdmin']
                ? Column(
                    children: [
                      Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          child: autoCompleteNameClass!.textField(
                              nameController: _nameController,
                              shopController: _shopController,
                              areaController: _areaController,
                              phoneController: _phoneController,
                              focusChange: (bool isFocusChanged) {
                                // print(isFocusChanged);
                                _isNameTextFieldClicked = isFocusChanged;
                                setState(() {});
                              })),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: size.width * .6,
                              child: TextField(
                                enabled: false,
                                controller: _shopController,
                                decoration:
                                    InputDecoration(hintText: "shop name "),
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: size.width * .3,
                              child: TextField(
                                controller: _areaController,
                                enabled: false,
                                decoration: InputDecoration(hintText: "area"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                  // 1.0
                  // 2.0
                  //3.0
                  stream: _firestore.collection('app').doc('3.0').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {}
                    return snapshot.data!['update'] == false
                        ? _isNameTextFieldClicked
                            ? Container()
                            : Column(
                                children: [
                                  SizedBox(height: 3),
                                  GestureDetector(
                                    onTap: () {
                                      selectedDate = DateTime.now();
                                      selected = 1;
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 7),
                                      child: Material(
                                          color: selected == 1
                                              ? Color(0xff36b58b)
                                                  .withOpacity(0.5)
                                              : Colors.white,
                                          elevation: 4,
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 45,
                                              width: size.width,
                                              child: Text('Today'))),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      selected = 2;
                                      DateTime now = DateTime.now();
                                      selectedDate = new DateTime(
                                          now.year,
                                          now.month,
                                          now.day + 1,
                                          now.hour,
                                          now.minute,
                                          now.second,
                                          now.millisecond);

                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 7),
                                      child: Material(
                                          color: selected == 2
                                              ? Color(0xff36b58b)
                                                  .withOpacity(0.5)
                                              : Colors.white,
                                          elevation: 4,
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 45,
                                              width: size.width,
                                              child: Text('Tomorrow'))),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await _selectDate(context);
                                      DateTime now = DateTime.now();
                                      selectedDate = new DateTime(
                                          _whichDay!.year,
                                          _whichDay!.month,
                                          _whichDay!.day,
                                          now.hour,
                                          now.minute,
                                          now.second,
                                          now.millisecond);
                                      selected = 3;

                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 7),
                                      child: Material(
                                          color: selected == 3
                                              ? Color(0xff36b58b)
                                                  .withOpacity(0.5)
                                              : Colors.white,
                                          elevation: 4,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 45,
                                            width: size.width,
                                            child: Text("Select Date (" +
                                                "${_whichDay!.toLocal()}"
                                                    .split(' ')[0] +
                                                ")"),
                                          )),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      print('order button clicked');
                                      bool _isAdmin =
                                          _userDetails['isAdmin'] != null &&
                                              _userDetails['isAdmin'];
                                      if (_isAdmin &&
                                          _nameController.text == '') {
                                        showToast("Give a customer name");
                                      } else if (selectedDate == null) {
                                        showToast("Select a delivery date");
                                      } else {
                                        _showSpinner = true;
                                        setState(() {});
                                        print(selectedDate);
                                        if (_isAdmin) {
                                          isInListProvider
                                                  .userDetails!['name'] =
                                              _nameController.text;
                                          isInListProvider
                                                  .userDetails!['shopName'] =
                                              _shopController.text;
                                          isInListProvider
                                                  .userDetails!['phone'] =
                                              _phoneController.text;
                                          isInListProvider
                                                  .userDetails!['area'] =
                                              _areaController.text;
                                        }
                                        OrderManage oderManage = OrderManage(
                                            uid: isInListProvider
                                                .userDetails!['uid'],
                                            userData:
                                                isInListProvider.userDetails,
                                            deliveryDate: selectedDate);
                                        print(_allDetailsList);
                                        try {
                                          await oderManage.saveOrder(
                                              orderData: _allDetailsList,
                                              successFunction: () async {
                                                sendAndRetrieveMessage(
                                                    'Sav Admin',
                                                    'There is a new Order for date ${selectedDate.toString().substring(0, 10)}',
                                                    'admin');
                                                await Future.delayed(Duration(
                                                    milliseconds: 800));
                                                Provider.of<IsInListProvider>(
                                                        context,
                                                        listen: false)
                                                    .removeAllDetails();
                                                await Future.delayed(Duration(
                                                    milliseconds: 500));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SuccessfulPage()));
                                              },
                                              failedFunction: () {
                                                showToast(
                                                    "failed to Save Order");
                                              });

                                          // Navigator.of(context).push(
                                          //     PageRouteBuilder(pageBuilder:
                                          //         (context, animation,
                                          //             secondaryAnimation) {
                                          //   return SuccessfulPage();
                                          // }, transitionsBuilder: (context,
                                          //         animation,
                                          //         secondaryAnimation,
                                          //         child) {
                                          //   var begin = Offset(1.0, 0.0);
                                          //   var end = Offset(0.0, 0.0);
                                          //   var tween =
                                          //       Tween(begin: begin, end: end);
                                          //   var offsetAnimation =
                                          //       animation.drive(tween);
                                          //   return SlideTransition(
                                          //     position: offsetAnimation,
                                          //     child: child,
                                          //   );
                                          // }));
                                        } catch (e) {
                                          print("error $e");
                                        }

                                        _showSpinner = false;
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      height: 55,
                                      width: double.infinity,
                                      color: Color(0xff36b58b),
                                      alignment: Alignment.center,
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Place Order',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Update the app to Continue',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 40),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Material(
                                    elevation: 4,
                                    // color: Color(0xff36b58b),
                                    child: InkWell(
                                      onTap: () {
                                        // print(snapshot.data['link']);
                                        _launchURL(snapshot.data!['link']);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              child: Image.asset(
                                                  'assets/playstore.png'),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Update App',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _key.currentState!.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    // _key.currentState!.clear();
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
