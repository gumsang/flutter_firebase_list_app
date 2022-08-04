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
  final AddBookViewModel viewModel = AddBookViewModel();
  Uint8List? _bytes;

  @override
  void dispose() {
    titleTextController.dispose();
    authorTextController.dispose();

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

            //ShowDialog로 빈칸방지
            ElevatedButton(
              onPressed: () {
                if (titleTextController.text.isNotEmpty &&
                    authorTextController.text.isNotEmpty &&
                    _bytes != null) {
                  viewModel.addBook(
                    title: titleTextController.text,
                    author: authorTextController.text,
                    bytes: _bytes,
                  );
                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('에러!'),
                      content: const Text('표지,제목,저자를 입력하세요'),
                      actions: [
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('넵')),
                        ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('넵')),
                      ],
                    ),
                  );
                }
              },
              child: const Text('도서 추가'),
            ),
            const SizedBox(
              height: 20,
            ),

            //에러 캐치로 스낵바 생성....안됨
            ElevatedButton(
              onPressed: () {
                AddBookViewModel()
                    .addBook(
                  title: titleTextController.text,
                  author: authorTextController.text,
                  bytes: _bytes,
                )
                    .then((_) {
                  Navigator.pop(context);
                }).catchError((e) {
                  final snackBar = SnackBar(
                    content: Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
              child: const Text('도서 추가 캐치에러 동작안함'),
            ),
          ],
        ),
      ),
    );
  }
}
