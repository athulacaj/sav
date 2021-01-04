import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'uploadImage.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ManageAds extends StatefulWidget {
  final String title;
  ManageAds(this.title);
  @override
  _ManageAdsState createState() => _ManageAdsState();
}

class _ManageAdsState extends State<ManageAds>
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

  List allInfo = [];
  int selected = -1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        body: SafeArea(
          child: StreamBuilder(
            stream: _firestore.collection('home').doc('ads').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              allInfo = snapshot.data['ads'];
              print(allInfo.length);

              print('allInfo $allInfo');
              return Column(
                children: [
                  SizedBox(height: 10),

                  Text('${widget.title}'.toUpperCase()),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allInfo.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GestureDetector(
                          onTap: () {
                            selected = i;
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              child: Container(
                                  color: selected == i
                                      ? Colors.blue.withOpacity(.1)
                                      : Colors.white,
                                  height: 100,
                                  width: 100,
                                  child: Image.network(allInfo[i])),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  FlatButton(
                    color: Colors.green,
                    child: Container(
                      width: size.width,
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      if (selected != -1 && allInfo.length != 0) {
                        List temp = allInfo;
                        temp.removeAt(selected);
                        print(temp);
                        _showSpinner = true;
                        setState(() {});

                        await _firestore
                            .collection('home')
                            .doc('ads')
                            .set({'ads': temp});
                        _showSpinner = false;
                        setState(() {});
                      }
                    },
                  ),
                  // SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
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
