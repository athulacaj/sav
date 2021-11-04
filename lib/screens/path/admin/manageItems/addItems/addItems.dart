import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sav/functions/showToastFunction.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';
import 'package:sav/widgets/uploadFiles.dart';
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
  TabController? _tabController;
  bool isUploading = false;
  String? name, img;
  bool? _showSpinner;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _nameInEnController = TextEditingController();
  bool? checkedValue = false;
  final _formKey = GlobalKey<FormState>();
  UploadFileClass? uploadedFile;

  @override
  void initState() {
    _showSpinner = false;
    checkedValue = false;
    _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  void callBack() {
    setState(() {});
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
                                if (value!.isEmpty) {
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
                                        if (value!.isEmpty) {
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
                                        if (checkedValue!) {
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
                            uploadedFile != null
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
                                            image:
                                                FileImage(uploadedFile!.file!),
                                          )),
                                        ),
                                        uploadedFile!.progress == 1.0
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
                                                    value:
                                                        uploadedFile!.progress,
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
                              onPressed: () async {
                                _showSpinner = true;
                                setState(() {});
                                UploadFileClass uploadFileClass =
                                    new UploadFileClass(
                                        callBack, "${widget.title}", context);
                                bool isSelected =
                                    await uploadFileClass.uploadFile("image");
                                if (isSelected) uploadedFile = uploadFileClass;
                                _showSpinner = false;
                                setState(() {});
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
                        if (_formKey.currentState!.validate()) {
                          if (uploadedFile != null &&
                              uploadedFile!.url != null) {
                            print('validated');
                            _showSpinner = true;
                            setState(() {});
                            int? confirm = await showBottomSheet();
                            if (confirm == 1) {
                              try {
                                DocumentSnapshot<Map<String, dynamic>> doc =
                                    await _firestore
                                        .collection('items')
                                        .doc('${widget.title}')
                                        .get();
                                List? allInfo = [];
                                if (doc.exists) {
                                  allInfo = doc.data()!['allInfo'];
                                }
                                Map toAdd = {
                                  'name': '$name',
                                  'en': '${_nameInEnController.text}',
                                  'search': '',
                                  'image': '${uploadedFile!.url}',
                                  'imageType': 'online',
                                  'amount': 45,
                                  'available': true,
                                  'quantity': 500,
                                  'unit': 'g',
                                };
                                allInfo!.add(toAdd);
                                try {
                                  await _firestore
                                      .collection('items')
                                      .doc('${widget.title}')
                                      .set({'allInfo': allInfo});
                                  showToast("Saved!!");
                                } catch (e) {}

                                print(allInfo);
                                img = null;
                              } catch (e) {}
                            }
                            _showSpinner = false;
                            setState(() {});
                          } else {
                            showToast("Please add a image!!");
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

  Future<int?> showBottomSheet() {
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
                      // SizedBox(
                      //     height: 100, width: 100, child: Image.network(img!)),
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
