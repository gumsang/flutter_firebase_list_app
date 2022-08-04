import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
              // Map<String, dynamic> data =
              //     document.data()! as Map<String, dynamic>;
              return Dismissible(
                onDismissed: (_) {
                  viewModel.deleteBook(document: document);
                },
                background: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                key: ValueKey(document.id),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateBookScreen(document)),
                    );
                  },
                  title: Text(document['title']),
                  subtitle: Text(document['author']),
                  leading: Image.network(
                    document['imageUrl'],
                    width: 100,
                    height: 100,
                  ),
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
