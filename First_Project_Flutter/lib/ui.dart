import 'package:flutter/material.dart';
import 'data/bookshelper.dart';

class BooksTable extends StatelessWidget {
  final List<dynamic> books;
  final bool isFavorite;
  final BooksHelper helper = BooksHelper();

  BooksTable(this.books, this.isFavorite);

  @override
  Widget build(BuildContext context) {
    books.forEach((book) {
      print('Book ID: ${book.id}');
      print('Book Title: ${book.title}');
      print('Book Publish Year: ${book.firstPublishYear}');
    });

    return Table(
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.blueGrey),
      children: books.map((book) {
        return TableRow(children: [
          TableCell(child: TableText(book.id)),
          TableCell(child: TableText(book.title)),
          TableCell(child: TableText(book.firstPublishYear.toString())),
          TableCell( // Убираем TableCell, связанный с loggedDate
            child: IconButton(
              color: (isFavorite) ? Colors.red : Colors.amber,
              tooltip: (isFavorite) ? 'Remove from favorites' : 'Add to favorites',
              icon: Icon(Icons.star),
              onPressed: () {
                if (isFavorite) {
                  helper.removeFromFavorites(book, context);
                } else {
                  helper.addToFavorites(book);
                }
              },
            ),
          )
        ]);
      }).toList(),
    );
  }
}

class TableText extends StatelessWidget {
  final String text;

  TableText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).primaryColorDark),
      ),
    );
  }
}
