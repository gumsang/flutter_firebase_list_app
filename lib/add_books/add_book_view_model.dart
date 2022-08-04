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
    bool isValid = title.isNotEmpty && author.isNotEmpty && bytes != null;
    final doc = _db.collection('books').doc();
    if (isValid) {
      String downloadUrl = await uploadImage(doc.id, bytes);
      await _db.collection('books').doc(doc.id).set({
        "title": title,
        "author": author,
        "imageUrl": downloadUrl,
      });
    } else if (author.isEmpty && title.isEmpty) {
      return Future.error('제목과 저자를 입력해 주세요');
    } else if (author.isEmpty && bytes == null) {
      return Future.error('저자와 책표지를 입력해 주세요');
    } else if (title.isEmpty && bytes == null) {
      return Future.error('제목과 책표지를 입력해 주세요');
    } else if (title.isEmpty) {
      return Future.error('제목을 입력해 주세요');
    } else if (author.isEmpty) {
      return Future.error('저자를 입력해 주세요');
    } else {
      return Future.error('모두 입력해 주세요');
    }
  }
}
