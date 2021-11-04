import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav/constants/constants.dart';
import 'package:sav/functions/showToastFunction.dart';
import 'package:sav/widgets/ModalProgressHudWidget.dart';
import 'package:sav/widgets/uploadFiles.dart';

class EditItemsDetails extends StatefulWidget {
  final String category;
  final List? allInfo;
  final int i;
  EditItemsDetails(
      {required this.category, required this.allInfo, required this.i});

  @override
  _EditItemsDetailsState createState() => _EditItemsDetailsState();
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class _EditItemsDetailsState extends State<EditItemsDetails> {
  String? name, img;
  bool? _showSpinner;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _nameInEnController = TextEditingController();
  bool? checkedValue = false;
  final _formKey = GlobalKey<FormState>();
  UploadFileClass? uploadedFile;

  @override
  void initState() {
    super.initState();
    _showSpinner = false;
    checkedValue = false;
    initFunction();
  }

  void initFunction() {
    Map data = widget.allInfo![widget.i];
    print(data);
    _nameController.text = data['name'];
    _nameInEnController.text = data['name'];
  }

  void callBack() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff36b58b),
          title: Text("Edit"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height - 80,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    new UploadFileClass(callBack,
                                        "${widget.category}", context);
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
                          print('validated');
                          _showSpinner = true;
                          setState(() {});
                          try {
                            List allItems = widget.allInfo!;
                            int i = widget.i;
                            allItems[i]['name'] = _nameController.text;
                            allItems[i]['en'] = _nameInEnController.text;
                            bool isImageUpdated = (uploadedFile != null &&
                                uploadedFile!.url != null &&
                                uploadedFile!.url != '');
                            if (isImageUpdated) {
                              allItems[i]['image'] = uploadedFile!.url;
                            }
                            // await _firestore
                            //     .collection('backUp')
                            //     .doc('${widget.category}')
                            //     .set({'allInfo': widget.allInfo});
                            await _firestore
                                .collection('items')
                                .doc('${widget.category}')
                                .set({'allInfo': allItems});
                            showToast("Saved!!");
                          } catch (e) {}
                          _showSpinner = false;
                          setState(() {});
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
}
