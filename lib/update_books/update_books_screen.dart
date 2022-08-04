import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_list/add_books/add_book_view_model.dart';
import 'package:flutter_book_list/update_books/update_books_view_model.dart';
import 'package:image_picker/image_picker.dart';

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

  final ImagePicker _picker = ImagePicker();

  Uint8List? _bytes;

  @override
  void initState() {
    // TODO: implement initState
    titleTextController.text = widget.document['title'];
    authorTextController.text = widget.document['author'];
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
        title: const Text('도서 추가'),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                    ? Image.network('${widget.document['imageUrl']}',
                        width: 200, height: 200)
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
                  UpdateBookViewModel().updateBook(
                    document: widget.document,
                    title: titleTextController.text,
                    author: authorTextController.text,
                    bytes: _bytes,
                  );
                  Navigator.pop(context);
                },
                child: const Text('도서 수정'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
