import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';
import 'uploadImage.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AddAds extends StatefulWidget {
  final String title;
  AddAds(this.title);
  @override
  _AddAdsState createState() => _AddAdsState();
}

class _AddAdsState extends State<AddAds> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool isUploading = false;
  late UploadImage uploadImage;
  String? name, img;
  bool? _showSpinner;
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
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.title}'.toUpperCase()),
                      SizedBox(height: 40),
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
                                      image: FileImage(
                                          File(uploadImage.pickedFile!.path)),
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
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.grey,
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
                  if (_formKey.currentState!.validate()) {
                    if (img != null) {
                      print('validated');
                      _showSpinner = true;
                      setState(() {});
                      int? confirm = await showBottomSheet();
                      if (confirm == 1) {
                        try {
                          DocumentSnapshot<Map<String, dynamic>> doc =
                              await _firestore
                                  .collection('home')
                                  .doc('ads')
                                  .get();
                          List? allInfo = [];
                          if (doc.exists) {
                            allInfo = doc.data()!['ads'];
                          }
                          String? toAdd = img;
                          allInfo!.add(toAdd);
                          await _firestore
                              .collection('home')
                              .doc('ads')
                              .set({'ads': allInfo});
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
              // SizedBox(height: 10),
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
                      SizedBox(height: 15),
                      SizedBox(
                          height: 100, width: 100, child: Image.network(img!)),
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
