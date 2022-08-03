import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_list/add_books/add_book_view_model.dart';
import 'package:flutter_book_list/update_books/update_books_view_model.dart';

class UpdateBookScreen extends StatefulWidget {
  const UpdateBookScreen(this.document, {Key? key}) : super(key: key);
  final DocumentSnapshot document;

  @override
  State<UpdateBookScreen> createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final titleTextController = TextEditingController();
  final authorTextController = TextEditingController();
  Map<String, dynamic> data = {};

  @override
  void initState() {
    // TODO: implement initState
    data = widget.document.data()! as Map<String, dynamic>;
    super.initState();
  }

  @override
  void dispose() {
    titleTextController.dispose();
    authorTextController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 수정'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(data['title']),
            subtitle: Text(data['author']),
          ),
          TextField(
            controller: titleTextController,
            decoration: InputDecoration(
              hintText: '제목',
              label: Text(data['title']),
            ),
          ),
          TextField(
            controller: authorTextController,
            decoration: InputDecoration(
              hintText: '저자',
              label: Text(data['author']),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UpdateBookViewModel().UpdateBook(
              document: widget.document,
              title: titleTextController.text,
              author: authorTextController.text);
          Navigator.pop(context);
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
