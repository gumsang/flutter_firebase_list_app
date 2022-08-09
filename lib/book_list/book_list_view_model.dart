import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_book_list/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class BookListViewModel {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _googleSignIn = GoogleSignIn();

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

  void logout() async {
    if (isGoogle) {
      await _googleSignIn.signOut();
    }
    await FirebaseAuth.instance.signOut();
  }
}
