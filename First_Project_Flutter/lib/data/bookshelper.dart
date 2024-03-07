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

        // Проверяем, содержит ли JSON-ответ поле "work"
        if (json.containsKey('work')) {
          dynamic work = json['work'];

          // Извлекаем данные книги из JSON-ответа
          String id = work['key'] ?? '';
          String title = work['title'] ?? '';
          int firstPublishYear = work['first_publish_year'] ?? 0;

          // Создаем экземпляр класса Book и добавляем его в список favBooks
          Book book = Book(
            id: id,
            title: title,
            firstPublishYear: firstPublishYear,
          );
          favBooks.add(book);
        }
      }
    }
    return favBooks;
  }

  Future<void> addToFavorites(Book book) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString(book.id);
    if (id != null && id.isNotEmpty) { // Проверяем, что id не равен null и не является пустой строкой
      await preferences.setString(book.id, json.encode(book.toJson()));
    }
  }

  Future<void> removeFromFavorites(Book book, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString(book.id);
    if (id != null && id.isNotEmpty) { // Проверяем, что id не равен null и не является пустой строкой
      await preferences.remove(book.id);
      Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen()));
    }
  }
}



