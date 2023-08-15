import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jee_library/models/subjects.dart';
import 'package:jee_library/services/analytics_consts.dart';
import 'package:jee_library/services/consts.dart';
import 'package:jee_library/services/firestore.dart';
import 'package:jee_library/widgets/appbar_title.dart';
import 'package:jee_library/widgets/loader.dart';

import '../models/book.dart';

class BookDetail extends StatefulWidget {
  final DatabaseService db;

  const BookDetail({super.key, required this.db});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  Book? book;
  late Brightness brightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      brightness = Theme.of(context).brightness;
      var window = WidgetsBinding.instance.window;
      window.onPlatformBrightnessChanged = () {
        WidgetsBinding.instance.handlePlatformBrightnessChanged();
        setState(() {
          brightness = window.platformBrightness;
        });
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    if (book == null) {
      final bookId = ModalRoute.of(context)!.settings.arguments as String;
      widget.db.bookDoesExist(bookId).then((value) async {
        if (value) {
          Book temp = await widget.db.getBook(bookId);
          FirebaseAnalytics.instance.logEvent(name: "scan_attempt", parameters: {"status": ScanAttemptStatus.valid.name, "id": temp.id});
          setCurrentScreen(ScreenName.book_detail);
          setState(() {
            book = temp;
          });
        } else {
          FirebaseAnalytics.instance.logEvent(name: "scan_attempt", parameters: {"status": ScanAttemptStatus.invalid.name, "id": bookId});
          Navigator.of(context).pop(codeDoesNotExist);
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          text: book?.id ?? "Loading...",
          isUpward: true,
        ),
      ),
      body: book != null ? AnimationLimiter(
        child: ListView.builder(itemCount: book?.chapters.length, itemBuilder: (BuildContext context, int i) {
          IconData? icon = subjectToIcon(book?.subjects[i] ?? Subject.invalid);
          MaterialColor? iconColor = subjectToColor(book?.subjects[i] ?? Subject.invalid);
          return AnimationConfiguration.staggeredList(
            position: i,
            duration: appFadeDuration,
            child: SlideAnimation(
              verticalOffset: 44.0,
              child: FadeInAnimation(
                child: ListTile(
                    leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: SizedBox(
                            height: 70.0,
                            width: 70.0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: iconColor
                              ),
                              child: Icon(icon, color: Colors.white,),
                            ),
                          ),
                        )
                    ),
                    title: Text(book?.chapters[i] ?? ""),
                    subtitle: Text(subjectToString(book?.subjects[i] ?? Subject.invalid)),
                ),
              ),
            ),
          );
        }),
      ) : getLoader()
    );
  }
}
