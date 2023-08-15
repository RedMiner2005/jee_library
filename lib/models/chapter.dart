import 'subjects.dart';
import 'book.dart';

class Chapter {
  String id;
  String name;
  Subject subject;
  List<dynamic> books;

  Chapter({ required this.id, required this.name, required this.subject, required this.books });
}