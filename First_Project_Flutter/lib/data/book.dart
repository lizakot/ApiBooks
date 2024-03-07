import 'package:first_project_flutter/data/bookshelper.dart';

class Book {
  String id;
  String title;
  int firstPublishYear;

  Book({
    required this.id,
    required this.title,
    required this.firstPublishYear,
  });

  factory Book.fromJson(Map<String, dynamic> parsedJson) {
    try {
      final String id = parsedJson['key'] ?? '';
      final String title = parsedJson['title'] ?? '';
      final int firstPublishYear = parsedJson['first_publish_year'] ?? 0;

      return Book(
        id: id,
        title: title,
        firstPublishYear: firstPublishYear,
      );
    } catch (e) {
      print('Error parsing JSON data: $e');
      return Book(
        id: '',
        title: '',
        firstPublishYear: 0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'firstPublishYear': firstPublishYear,
    };
  }
}

