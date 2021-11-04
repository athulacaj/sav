import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';

class UploadFileClass {
  UploadFileClass(this.callBack, this.whichContext, this.context);
  Function callBack;
  String whichContext;
  BuildContext context;
  double progress = 0.4;
  PickedFile? pickedFile;
  File? file;
  String? url;
  String? type;
  bool isUploaded = false;

  Future<bool> uploadFile(String type) async {
    this.type = type;
    FilePickerResult? result;
    if (type == 'image') {
      print('selected image');
      result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
    } else if (type == 'pdf') {
      print('selected pdf');

      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
    } else if (type == 'audio') {
      print('audio selected uknown');
      result = await FilePicker.platform.pickFiles(type: FileType.audio);
    }
    if (result != null) {
      file = File(result.files.single.path);
      upload(whichContext);
      return true;
    } else {
      return false;
    }
  }

  upload(String whichContext) async {
    String fileName = file!.path.split('/').last;
    int dateInMs = DateTime.now().millisecondsSinceEpoch;
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref('$whichContext/$year/$month/${dateInMs % 1000}_$fileName')
        .putFile(file!);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      progress =
          snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble();
      callBack();
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    // We can still optionally use the Future alongside the stream.
    try {
      await task;
      url = await (await task.whenComplete(() => null)).ref.getDownloadURL();
      isUploaded = true;
      callBack();
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
      // ...
    }
  }
}
