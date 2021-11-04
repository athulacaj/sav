import 'package:flutter/material.dart';

import 'customersDatabase.dart';

class AddCustomerClass {
  static bool _showLoader = false;

  static void show(BuildContext context, List<String> areaList) {
    String _area = 'all';
    _showLoader = false;
    TextEditingController _nameController = new TextEditingController();
    TextEditingController _phoneController = new TextEditingController();
    TextEditingController _shopController = new TextEditingController();
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              padding: EdgeInsets.all(12),
              height: 500,
              // color: Colors.amber,
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(hintText: "enter name"),
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: _shopController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "enter shop name (optional)"),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _phoneController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "enter phone"),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Area      :   "),
                            DropdownButton<String>(
                              value: _area,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _area = newValue!;
                                });
                              },
                              items: areaList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          child: Container(
                              width: 260,
                              height: 50,
                              alignment: Alignment.center,
                              child: const Text('Save')),
                          onPressed: () async {
                            Map<String, dynamic> data = {
                              'name': _nameController.text.toUpperCase(),
                              'phone': _phoneController.text,
                              'shop': _shopController.text.toUpperCase(),
                              "area": _area
                            };
                            _showLoader = true;
                            setState(() {});
                            bool isSaved =
                                await CustomersDatabase.addCustomer(data);
                            _showLoader = false;
                            setState(() {});
                            if (isSaved) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                    _showLoader
                        ? Center(child: CircularProgressIndicator())
                        : Container(),
                  ],
                ),
              ),
            );
          });
        });
  }
}
