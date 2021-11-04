import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImage {
  UploadImage(this.callBack);
  Function callBack;
  double progress = 0.4;
  XFile? pickedFile;
  late File image;
  String? url;
  uploadImage(String item) async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile == null) {
      return;
    }
    image = File(pickedFile!.path);
    int dateInMs = DateTime.now().millisecondsSinceEpoch;
    int year = DateTime.now().year;
    firebase_storage.Reference ref =
        FirebaseStorage.instance.ref().child('$item').child("$dateInMs.jpg");

    firebase_storage.UploadTask uploadTask = ref.putFile(image);
    uploadTask.snapshotEvents.listen((event) {
      progress =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      callBack();
      // set state is called using callback function
    }).onError((error) {
      // do something to handle error
    });

    // await uploadTask.whenComplete(() => null).then((value) => print(value.ref.getDownloadURL()));
    url =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    callBack();
  }
}
