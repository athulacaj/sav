import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav/functions/showToastFunction.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';

import 'editDetails.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class EditItems extends StatefulWidget {
  final List? allInfo;
  final String category;
  EditItems({this.allInfo, required this.category});
  @override
  _EditItemsState createState() => _EditItemsState();
}

class _EditItemsState extends State<EditItems> {
  List selectedItems = [];
  List? allItems = [];
  bool? _showSpinner;
  @override
  void initState() {
    _showSpinner = false;
    selectedItems = [];
    allItems = widget.allInfo;
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
          title: Text('Edit'),
          actions: [
            selectedItems.length > 0
                ? IconButton(
                    icon: Icon(Icons.select_all),
                    onPressed: () {
                      print('${allItems!.length} != ${selectedItems.length}');
                      if (allItems!.length != selectedItems.length) {
                        selectedItems = [];

                        for (int i = 0; i < allItems!.length; i++) {
                          selectedItems.add(i);
                        }
                      } else {
                        selectedItems = [];
                      }
                      setState(() {});
                    },
                  )
                : Container(),
            selectedItems.length > 0
                ? IconButton(
                    icon: Icon(Icons.clear_all),
                    onPressed: () {
                      selectedItems = [];
                      setState(() {});
                    },
                  )
                : Container(),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      itemCount: allItems!.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GestureDetector(
                          onTap: () {
                            print(selectedItems.length);
                            if (selectedItems.indexOf(i) != -1) {
                              selectedItems.remove(i);
                              setState(() {});
                            } else if (selectedItems.length > 0) {
                              selectedItems.add(i);
                              setState(() {});

                              print(selectedItems);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditItemsDetails(
                                            category: widget.category,
                                            allInfo: widget.allInfo,
                                            i: i,
                                          )));
                            }
                          },
                          onLongPress: () {
                            selectedItems.add(i);
                            setState(() {});
                          },
                          child: Material(
                            elevation: 3,
                            child: Container(
                              color: selectedItems.indexOf(i) != -1
                                  ? Colors.blue.withOpacity(0.2)
                                  : null,
                              child: Column(
                                children: [
                                  SizedBox(
                                    child: Stack(
                                      children: [
                                        allItems![i]['imageType'] == 'offline'
                                            ? Image.asset(allItems![i]['image'])
                                            : Image.network(
                                                allItems![i]['image']),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          // width: size.width / 3 - 20,
                                          child: Container(
                                            color: Colors.yellow,
                                            child: allItems![i]['available']
                                                ? Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                    size: 30,
                                                  )
                                                : Icon(
                                                    Icons.close,
                                                    color: Colors.grey,
                                                    size: 30,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    width: size.width / 3 - 20,
                                    height: 80,
                                  ),
                                  Text(
                                    '${allItems![i]['name']}',
                                    style: TextStyle(
                                        color: allItems![i]['available']
                                            ? Colors.black
                                            : Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        childAspectRatio:
                            MediaQuery.of(context).size.width / 3 / 150,
                      ),
                    ),
                  ),
                  FlatButton(
                      minWidth: size.width / 2,
                      height: 40,
                      color: Colors.green,
                      onPressed: () async {
                        _showSpinner = true;
                        setState(() {});
                        try {
                          await _firestore
                              .collection('items')
                              .doc('${widget.category}')
                              .set({'allInfo': allItems});
                          showToast("Saved!!");
                        } catch (e) {}

                        _showSpinner = false;
                        setState(() {});
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: selectedItems.length > 0 ? 55 : 0,
                width: size.width,
                color: Colors.blue.withOpacity(0.6),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    selectedItems.length == 1
                        ? FlatButton(
                            onPressed: () {
                              for (int index in selectedItems) {
                                allItems!.removeAt(index);
                              }
                              selectedItems = [];
                              setState(() {});
                            },
                            height: 35,
                            color: Colors.white,
                            child: Text('Delete'))
                        : Container(),
                    FlatButton(
                      onPressed: () {
                        print(selectedItems);
                        for (int index in selectedItems) {
                          allItems![index]['available'] = true;
                        }
                        selectedItems = [];
                        setState(() {});
                      },
                      height: 35,
                      color: Colors.white,
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        for (int index in selectedItems) {
                          allItems![index]['available'] = false;
                        }
                        selectedItems = [];
                        setState(() {});
                      },
                      height: 35,
                      color: Colors.white,
                      child: Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
