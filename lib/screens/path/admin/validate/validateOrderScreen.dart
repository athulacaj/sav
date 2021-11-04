import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sav/providers/provider.dart';
import 'package:sav/screens/path/admin/validate/validationFunction.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';

import 'indivdualValidationOders.dart';

class ValidateOrderScreen extends StatefulWidget {
  const ValidateOrderScreen({Key? key}) : super(key: key);

  @override
  _ValidateOrderScreenState createState() => _ValidateOrderScreenState();
}

List savedDataList = [];
bool _showSpinner = false;

class _ValidateOrderScreenState extends State<ValidateOrderScreen> {
  @override
  void initState() {
    super.initState();
    _showSpinner = false;
    getData();
  }

  void getData() async {
    savedDataList = await ValidationClass.getSavedData();
    savedDataList = savedDataList.reversed.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff36b58b),
          title: Text('Validate'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: savedDataList.length,
                  itemBuilder: (BuildContext context, int i) {
                    Map userData = savedDataList[i]['userData'];
                    return MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    IndividualValidationOrders(
                                      singleOrderList: savedDataList[i],
                                      name: userData['name'],
                                    )));
                      },
                      child: Container(
                        // height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userData['name'],
                                  style: TextStyle(fontSize: 18),
                                ),
                                // Icon(Icons.check_box_outline_blank),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(_dateFormat(savedDataList[i]['deliveryDate'])),
                            Divider(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 8),
              // FlatButton(
              //     color: Colors.orangeAccent,
              //     minWidth: 250,
              //     onPressed: () async {
              //       _showSpinner = true;
              //       setState(() {});
              //       Map _userDetails =
              //           Provider.of<IsInListProvider>(context, listen: false)
              //               .userDetails!;
              //       List dbDataList = await ValidationClass.getDataFromDatabase(
              //           _userDetails['uid']);
              //       print(dbDataList);
              //       _showSpinner = false;
              //       setState(() {});
              //     },
              //     child: Text("Validate")),
            ],
          ),
        ),
      ),
    );
  }
}

String _dateFormat(String dt) {
  final DateFormat formatter = DateFormat();
  DateTime parsedDate = DateTime.parse(dt);

  return formatter.format(parsedDate);
  // return dt.substring(8, 10) + " / " + dt.substring(5, 7);
}
