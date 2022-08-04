import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddBookViewModel {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> uploadImage(
    String documentId,
    Uint8List bytes,
  ) async {
    final storageRef = _storage.ref().child('book_cover/$documentId.jpg');
    await storageRef.putData(bytes);
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  }

  Future addBook({
    required String title,
    required String author,
    required Uint8List? bytes,
  }) async {
    final doc = _db.collection('books').doc();
    String downloadUrl = await uploadImage(doc.id, bytes!);

    await _db.collection('books').doc(doc.id).set({
      "title": title,
      "author": author,
      "imageUrl": downloadUrl,
    });
  }
}
