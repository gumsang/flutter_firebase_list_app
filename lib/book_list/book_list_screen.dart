import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_book_list/add_books/add_book_screen.dart';
import 'package:flutter_book_list/book_list/book_list_view_model.dart';
import 'package:flutter_book_list/update_books/update_books_screen.dart';

class BookListScreen extends StatelessWidget {
  BookListScreen({Key? key}) : super(key: key);
  final viewModel = BookListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 리스트'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: viewModel.booksStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),
                subtitle: Text(data['author']),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateBookScreen(document),
                      ));
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {
                    BookListViewModel().deleteBook(document: document);
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBookScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
