import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../uploadImage.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AddItems extends StatefulWidget {
  final String title;
  AddItems(this.title);
  @override
  _AddItemsState createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool isUploading = false;
  UploadImage uploadImage;
  String name, img;
  bool _showSpinner;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _nameInEnController = TextEditingController();
  bool checkedValue = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _showSpinner = false;
    checkedValue = false;
    _tabController = TabController(vsync: this, length: 2);
    uploadImage = UploadImage(callBack);
    super.initState();
  }

  void callBack() {
    setState(() {});
    print(uploadImage.url);
    img = uploadImage.url;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height - 65,
                child: Column(
                  children: [
                    // TabBar(
                    //   controller: _tabController,
                    //   labelColor: Colors.black,
                    //   unselectedLabelColor: Colors.grey,
                    //   tabs: [
                    //     Tab(
                    //       text: '${widget.title}',
                    //     ),
                    //     Tab(
                    //       text: 'Dry Fish',
                    //     ),
                    //   ],
                    // ),
                    // Expanded(
                    //     child: TabBarView(
                    //   controller: _tabController,
                    //   children: [
                    //     Container(),
                    //   ],
                    // )),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.title}'),
                            SizedBox(height: 30),
                            SizedBox(height: 15),
                            Text(
                              'Name :',
                              style: TextStyle(
                                color: Color(0xff3FD4A2),
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Name cannot be null';
                                }
                                return null;
                              },
                              controller: _nameController,
                              decoration: textFieldDecoration.copyWith(
                                  hintText: 'eg: Carrot'),
                              onChanged: (value) {
                                name = value;
                              },
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Name  in English :',
                              style: TextStyle(
                                color: Color(0xff3FD4A2),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: _nameInEnController,
                                      decoration: textFieldDecoration.copyWith(
                                        hintText: 'eg: Carrot',
                                      ),
                                      onChanged: (value) {
                                        name = value;
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Name in English cannot be null';
                                        } else {
                                          final validCharacters =
                                              RegExp(r'^[a-zA-Z0-9 ]+$');

                                          if (!validCharacters
                                              .hasMatch(value)) {
                                            return 'Enter only english alphabets';
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                    width: size.width - 180),
                                SizedBox(
                                  width: 150,
                                  child: CheckboxListTile(
                                    title: Text("Same"),
                                    value: checkedValue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        checkedValue = newValue;
                                        if (checkedValue) {
                                          _nameInEnController.text =
                                              _nameController.text;
                                        } else {
                                          _nameInEnController.clear();
                                        }
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            uploadImage.pickedFile != null
                                ? Container(
                                    height: 80,
                                    width: 240,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 240,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: FileImage(File(
                                                uploadImage.pickedFile.path)),
                                          )),
                                        ),
                                        uploadImage.progress == 1.0
                                            ? Container()
                                            : Positioned(
                                                left: 105,
                                                top: 25,
                                                child: SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    value: uploadImage.progress,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 10),
                            FlatButton(
                              color: Colors.lightBlueAccent,
                              child: Text(
                                'Upload an Image',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                isUploading = true;
                                uploadImage.uploadImage('${widget.title}');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    FlatButton(
                      color: Colors.green,
                      child: Container(
                        width: size.width,
                        height: 45,
                        alignment: Alignment.center,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (img != null) {
                            print('validated');
                            _showSpinner = true;
                            setState(() {});
                            int confirm = await showBottomSheet();
                            if (confirm == 1) {
                              try {
                                DocumentSnapshot doc = await _firestore
                                    .collection('items')
                                    .doc('${widget.title}')
                                    .get();
                                List allInfo = [];
                                if (doc.exists) {
                                  allInfo = doc.data()['allInfo'];
                                }
                                Map toAdd = {
                                  'name': '$name',
                                  'en': '${_nameInEnController.text}',
                                  'search': '',
                                  'image': '$img',
                                  'imageType': 'online',
                                  'amount': 45,
                                  'available': true,
                                  'quantity': 500,
                                  'unit': 'g',
                                };
                                allInfo.add(toAdd);
                                await _firestore
                                    .collection('items')
                                    .doc('${widget.title}')
                                    .set({'allInfo': allInfo});
                                print(allInfo);
                                img = null;
                              } catch (e) {}
                            }
                            _showSpinner = false;
                            setState(() {});
                          } else {
                            FToast().init(context);
                            FToast().showToast(
                              child: Container(
                                width: size.width,
                                alignment: Alignment.center,
                                height: 35,
                                child: Text('Please add a image'),
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              gravity: ToastGravity.CENTER,
                              toastDuration: Duration(seconds: 2),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> showBottomSheet() {
    return showModalBottomSheet<int>(
      // isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        int selectedDeliveryBoy = -1;
        int selectedShop = -1;
        return StatefulBuilder(builder: (context, StateSetter setState) {
          Size size = MediaQuery.of(context).size;
          return Container(
            height: size.height - 100,
            // color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure ?',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 5),
                      Text(
                        '$name',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                          height: 100, width: 100, child: Image.network(img)),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          FlatButton(
                              color: Colors.grey,
                              onPressed: () {
                                Navigator.pop(context, 0);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              )),
                          Spacer(),
                          FlatButton(
                              color: Colors.green,
                              onPressed: () {
                                Navigator.pop(context, 1);
                              },
                              child: Text(
                                'Confirm',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

InputDecoration textFieldDecoration = InputDecoration(
  hintText: '',
  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 12),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black12),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black12),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black12),
  ),
);
