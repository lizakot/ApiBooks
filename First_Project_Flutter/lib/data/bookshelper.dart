import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../favoriteScreen.dart';
import 'book.dart';

class BooksHelper {
  final String urlBase = 'https://openlibrary.org/search.json?q=';

  Future<List<Book>> getBooks(String query) async {
    final String url = urlBase + query;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> booksData = jsonResponse['docs'];
      List<Book> books = booksData.map((data) => Book.fromJson(data)).toList();
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<dynamic>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> favBooks = [];
    Set<String> allKeys = prefs.getKeys().cast<String>();

    if (allKeys.isNotEmpty) {
      for (String key in allKeys) {
        String value = prefs.getString(key)!;
        dynamic json = jsonDecode(value);

        favBooks.add(Book(
          id: json['id'],
          title: json['title'],
          firstPublishYear: json['firstPublishYear'],
        ));
      }
    }
    return favBooks;
  }


  Future<void> addToFavorites(Book book) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString(book.id);
    print('Adding book to favorites. Book id: ${book.id}, Stored id: $id');
    if (id == null) {
      await preferences.setString(book.id, json.encode(book.toJson()));
    }
  }



  Future<void> removeFromFavorites(Book book, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString(book.id);
    print('Removing book with id: $id');
    if (id != null && id.isNotEmpty) { // Проверяем, что id не равен null и не является пустой строкой
      await preferences.remove(book.id);
      Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen()));
    }
  }

}



