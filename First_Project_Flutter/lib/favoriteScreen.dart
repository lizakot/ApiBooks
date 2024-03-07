import 'package:flutter/material.dart';
import 'ui.dart';
import 'data/bookshelper.dart';
import 'main.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late BooksHelper helper;
  List<dynamic> books = [];
  int booksCount = 0;

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Books'),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: (isSmall) ? Icon(Icons.home) : Text('Home'),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: (isSmall) ? Icon(Icons.star) : Text('Favorite'),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text('My Favorite Books'),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: (isSmall) ? BooksList(books, true) : BooksTable(books, true),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    helper = BooksHelper();
    initialize();
  }

  Future<void> initialize() async {
    print('Initializing...');
    books = await helper.getFavorites();
    print('Favorites received: $books');
    setState(() {
      booksCount = books.length;
    });
  }

  Widget BooksList(List<dynamic> books, bool isFavorite) {
    print('Building BooksList...');
    if (books.isEmpty) {
      return Text('No books found'); // Вывод сообщения, если список книг пуст
    }
    // код для отображения списка книг
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(books[index].title),
          subtitle: Text(books[index].firstPublishYear.toString()), // Используем год первой публикации вместо loggedDate
        );
      },
    );
  }
}
