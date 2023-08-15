import 'subjects.dart';
import 'chapter.dart';

class Book {
  String id;
  List<dynamic> chapters;
  List<dynamic> subjects;

  Book({ required this.id, required this.chapters, required this.subjects });
}