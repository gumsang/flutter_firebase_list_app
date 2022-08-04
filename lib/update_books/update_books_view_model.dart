import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateBookViewModel {
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

  void updateBook({
    required DocumentSnapshot document,
    required String title,
    required String author,
    required Uint8List? bytes,
  }) async {
    String downloadUrl = await uploadImage(document.id, bytes!);
    bool isValid = title.isNotEmpty && author.isNotEmpty;
    if (isValid) {
      await _db.collection('books').doc(document.id).set({
        "title": title,
        "author": author,
        "imageUrl": downloadUrl,
      });
    } else if (author.isEmpty && title.isEmpty) {
      throw '제목과 저자를 입력해 주세요';
    } else if (author.isEmpty && downloadUrl.isNotEmpty) {
      throw '저자와 책표지를 입력해 주세요';
    } else if (title.isEmpty && downloadUrl.isNotEmpty) {
      throw '제목과 책표지를 입력해 주세요';
    } else if (title.isEmpty) {
      throw '제목을 입력해 주세요';
    } else if (author.isEmpty) {
      throw '저자를 입력해 주세요';
    } else {
      throw '모두 입력해 주세요';
    }
  }
}
