import 'package:flutter/material.dart';
import 'data/bookshelper.dart';

class BooksTable extends StatefulWidget {
  final List<dynamic> books;
  final bool isFavorite;
  final BooksHelper helper = BooksHelper();

  BooksTable(this.books, this.isFavorite);

  @override
  _BooksTableState createState() => _BooksTableState();
}

class _BooksTableState extends State<BooksTable> {
  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.blueGrey),
      children: widget.books.map((book) {
        return TableRow(children: [
          TableCell(child: TableText(book.id)),
          TableCell(child: TableText(book.title)),
          TableCell(child: TableText(book.firstPublishYear.toString())),
          TableCell( // Убираем TableCell, связанный с loggedDate
            child: IconButton(
              color: (widget.isFavorite) ? Colors.red : Colors.amber,
              tooltip: (widget.isFavorite) ? 'Remove from favorites' : 'Add to favorites',
              icon: Icon(Icons.star),
              onPressed: () {
                setState(() {
                  if (widget.isFavorite) {
                    widget.helper.removeFromFavorites(book, context);
                  } else {
                    widget.helper.addToFavorites(book);
                  }
                  // Обновляем список книг в зависимости от того, добавляем ли мы в избранное или удаляем из него
                  widget.books.remove(book);
                });
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
