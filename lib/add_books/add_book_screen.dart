import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_book_list/add_books/add_book_view_model.dart';
import 'package:image_picker/image_picker.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final titleTextController = TextEditingController();
  final authorTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Uint8List? _bytes;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  // byte array
                  _bytes = await image.readAsBytes();

                  setState(() {});
                }
              },
              child: _bytes == null
                  ? Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey,
                    )
                  : Image.memory(_bytes!, width: 200, height: 200),
            ),
            TextField(
              controller: titleTextController,
              decoration: const InputDecoration(
                hintText: '제목',
              ),
            ),
            TextField(
              controller: authorTextController,
              decoration: const InputDecoration(
                hintText: '저자',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                AddBookViewModel().addBook(
                  title: titleTextController.text,
                  author: authorTextController.text,
                  bytes: _bytes,
                );
                Navigator.pop(context);
              },
              child: const Text('도서 추가'),
            )
          ],
        ),
      ),
    );
  }
}
