import 'package:flutter/material.dart';
import 'package:sav/functions/showToastFunction.dart';

import 'customersDatabase.dart';

class ManageAreaClass {
  static void show(BuildContext context, List areaList) {
    Size size = MediaQuery.of(context).size;
    List editedAreaList = List.from(areaList);
    TextEditingController _areaController = TextEditingController();
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              padding: EdgeInsets.all(12),
              height: size.height - 100,
              // color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 280,
                      color: Colors.blueGrey.withOpacity(.2),
                      child: ListView.builder(
                        itemCount: editedAreaList.length,
                        itemBuilder: (BuildContext context, int i) {
                          return i == 0
                              ? Container()
                              : Row(
                                  children: [
                                    Text(editedAreaList[i]),
                                    IconButton(
                                        onPressed: () {
                                          editedAreaList.removeAt(i);
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                );
                        },
                      ),
                    ),
                    TextField(
                      controller: _areaController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "enter area",
                          suffix: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              editedAreaList.add(_areaController.text);
                              _areaController.text = '';
                              setState(() {});
                            },
                          )),
                      onSubmitted: (value) {
                        editedAreaList.add(value);
                        _areaController.text = '';
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 15),
                    Spacer(),
                    ElevatedButton(
                      child: Container(
                          width: 260,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text('Save')),
                      onPressed: () async {
                        await CustomersDatabase.updateAreaList(editedAreaList);
                        showToast("Saved");
                        areaList = editedAreaList;
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          });
        });
  }
}
