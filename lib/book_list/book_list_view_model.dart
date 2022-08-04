import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookListViewModel {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Stream<QuerySnapshot> get booksStream => _db.collection("books").snapshots();
  Future deleteBook({required DocumentSnapshot document}) async {
    await _db.collection('books').doc(document.id).delete();
    await deleteImage(document.id);
  }

  Future deleteImage(
    String documentId,
  ) async {
    await _storage.ref().child('book_cover/$documentId.jpg').delete();
  }
}
