import 'package:flutter/material.dart';
import 'package:flutter_book_list/add_books/add_book_view_model.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final titleTextController = TextEditingController();
  final authorTextController = TextEditingController();

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
        title: const Text('도서 추가'),
      ),
      body: Column(
        children: [
          TextField(
            controller: titleTextController,
            decoration: InputDecoration(
              hintText: '제목',
            ),
          ),
          TextField(
            controller: authorTextController,
            decoration: InputDecoration(
              hintText: '저자',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddBookViewModel().addBook(
              title: titleTextController.text,
              author: authorTextController.text);
          Navigator.pop(context);
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
