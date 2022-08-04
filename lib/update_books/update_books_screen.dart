import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book_list/update_books/update_books_view_model.dart';
import 'package:image_picker/image_picker.dart';

class UpdateBookScreen extends StatefulWidget {
  const UpdateBookScreen(this.document, {Key? key}) : super(key: key);
  final DocumentSnapshot document;

  @override
  State<UpdateBookScreen> createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final _titleTextController = TextEditingController();
  final _authorTextController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final viewModel = UpdateBookViewModel();

  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _authorTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 수정'),
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
                controller: _titleTextController,
                decoration: InputDecoration(
                  hintText: widget.document['title'],
                ),
              ),
              TextField(
                controller: _authorTextController,
                decoration: InputDecoration(
                  hintText: widget.document['author'],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 에러가 날 것 같은 코드
                      viewModel
                          .updateBook(
                            document: widget.document,
                            title: _titleTextController.text,
                            author: _authorTextController.text,
                            bytes: _bytes,
                          )
                          .then((_) => Navigator.pop(context))
                          .catchError((e) {
                        // 에러가 났을 때
                        final snackBar = SnackBar(
                          content: Text(e.toString()),
                        );
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    },
                    child: const Text('도서 수정'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('수정 취소'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
