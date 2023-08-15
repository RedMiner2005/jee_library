import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jee_library/models/user.dart';
import 'package:jee_library/services/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/book.dart';
import '../models/chapter.dart';
import '../models/subjects.dart';


class DatabaseService {
  CustomUser user = CustomUser(uuid: "", firstLogin: DateTime.now(), isEnabled: true);
  late SharedPreferences sharedPref;

  DatabaseService();

  // Collection Reference
  final CollectionReference booksCollection = FirebaseFirestore.instance.collection("books");
  final CollectionReference chaptersCollection = FirebaseFirestore.instance.collection("chapters");

  // Future<bool> verifyEnabledFirstTime() async {
  //   sharedPref = await SharedPreferences.getInstance();
  //   return !sharedPref.containsKey(firstTimeKey);
  // }
  //
  // void setFirstTime() {
  //   sharedPref.setBool(firstTimeKey, false);
  // }

  // Custom book from snapshot
  Iterable<Book> _bookListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return _bookFromSnapshot(e);
    });
  }

  Book _bookFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return Book(
      id: snapshot.id,
      chapters: List.from(data?["chapters"]),
      subjects: data?["subjects"].map((e) => subjectFromString(e)).toList(),
    );
  }

  // Custom chapter from snapshot
  Iterable<Chapter> _chapterListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return _chapterFromSnapshot(e);
    });
  }

  Chapter _chapterFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    return Chapter(
        id: snapshot.id,
        name: data?["name"] ?? "",
        subject: subjectFromString(data?["subject"] ?? ""),
        books: List.from(data?["books"])
    );
  }

  Future<bool> bookDoesExist(String id) async {
    DocumentSnapshot snapshot = await booksCollection.doc(id).get();
    return snapshot.exists;
  }

  Future<bool> chapDoesExist(String id) async {
    DocumentSnapshot snapshot = await chaptersCollection.doc(id).get();
    return snapshot.exists;
  }

  Future<Book> getBook(String id) async {
    return await booksCollection.doc(id).get().then(_bookFromSnapshot);
  }

  Future<Chapter> getChapter(String id) async {
    return await booksCollection.doc(id).get().then(_chapterFromSnapshot);
  }

  Future getNumberOfBooks() async {
    QuerySnapshot docs = await booksCollection.get();
    return docs.docs.length;
  }

  Future getNumberOfChapters() async {
    QuerySnapshot docs = await chaptersCollection.get();
    return docs.docs.length;
  }

  // Get Book Stream
  Stream<QuerySnapshot<Map<String, dynamic>>> get books {
    return booksCollection.snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  Stream<Iterable<Book>> get booksList {
    return booksCollection.snapshots().map(_bookListFromSnapshot);
  }

  // Get Chapter Stream
  Stream<QuerySnapshot<Map<String, dynamic>>> get chapters {
    return chaptersCollection.snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  Stream<Iterable<Chapter>> get chaptersList {
    return chaptersCollection.snapshots().map(_chapterListFromSnapshot);
  }

  Future<Map<String, dynamic>> getBookData(String id) async {
    return (await booksCollection.doc(id).get()).data() as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getChapterData(String id) async {
    return (await chaptersCollection.doc(id).get()).data() as Map<String, dynamic>;
  }

  Future<List<Chapter>> getChaptersOfSubject(Subject subject) async {
    return List.from(_chapterListFromSnapshot(await chaptersCollection.where("subject", isEqualTo: subjectToString(subject)).get()));
  }
}
