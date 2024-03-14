import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<void> signInUserAnon() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("Lets begin ${userCredential.user?.uid}");
  } catch (e) {
    print(e);
  }
}

Future<bool> uploadFileForUser(File file) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final fileName = file.path.split("/").last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uploadRef = storageRef.child("$userId/uploads/$timestamp-$fileName");
    await uploadRef.putFile(file);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<List<Reference>?> getUserUploadedFiles() async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final storageRef = FirebaseStorage.instance.ref();
    final uploadsRef = storageRef.child("$userId/uploads/");
    final uploads = await uploadsRef.listAll();
    return uploads.items;
  } catch (e) {
    print(e);
    return null;
  }
}
