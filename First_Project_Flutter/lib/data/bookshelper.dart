import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../favoriteScreen.dart';
import 'book.dart';

class BooksHelper {
  final String urlKey = '&key=[ADD YOUR KEY HERE]';
  final String urlQuery = 'volumes?q=';
  final String urlBase = 'https://www.googleapis.com/book/v1/';

  Future<List<dynamic>> getBooks(String query) async {
    final String url = urlBase + urlQuery + query;
    Uri uri = Uri.parse(url);
    Response result = await http.get(uri);
    if (result.statusCode == 200){
      final jsonResponse = json.decode(result.body);
      final List<dynamic> booksMap = jsonResponse['items'];
      List<Book> books = booksMap.map((i) => Book.fromJson(i)).toList();
      return books;
    }
    else {
        return [];
    }
  }

  Future<List<dynamic>> getFavorites() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> favBooks = [];
    Set<String> allKeys = prefs.getKeys().cast<String>();

    if (allKeys.isNotEmpty){
      for (String key in allKeys) {
        String value = prefs.getString(key)!;
        dynamic json = jsonDecode(value);
        Book book = Book(
          json['id'], json['title'], json['authors'], json['description'],
          json['publisher']);
        favBooks.add(book);
      }
    }
    return favBooks;
  }

  Future<void> addToFavorites(Book book) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString(book.id);
    if (id != ''){
      await preferences.setString(book.id, json.encode(book.toJson()));
    }
  }

  Future<void> removeFromFavorites(Book book, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString(book.id);
    if (id != ''){
      await preferences.remove(book.id);
     // books.remove(book);
      Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen()));
    }
  }
  }
