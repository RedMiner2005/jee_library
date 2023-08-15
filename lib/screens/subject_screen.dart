import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jee_library/models/chapter.dart';
import 'package:jee_library/models/subjects.dart';
import 'package:jee_library/services/analytics_consts.dart';
import 'package:jee_library/services/consts.dart';
import 'package:jee_library/services/firestore.dart';
import 'package:jee_library/widgets/appbar_title.dart';
import 'package:jee_library/widgets/loader.dart';

import '../models/book.dart';

class SubjectScreen extends StatefulWidget {
  final DatabaseService db;

  const SubjectScreen({super.key, required this.db});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  late Brightness brightness;
  Subject? subject;
  List<Chapter>? chapters;

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
    if (subject == null) {
      try {
        final currSubject = ModalRoute.of(context)!.settings.arguments as Subject;
        switch (currSubject) {
          case Subject.physics:
            setCurrentScreen(ScreenName.sub_phys);
            break;
          case Subject.chemistry:
            setCurrentScreen(ScreenName.sub_chem);
            break;
          case Subject.math:
            setCurrentScreen(ScreenName.sub_math);
            break;
          case Subject.invalid:
            setCurrentScreen(ScreenName.sub_invalid);
            break;
        }
        widget.db.getChaptersOfSubject(currSubject).then((currChapters) {
          setState(() {
            subject = currSubject;
            chapters = currChapters;
          });
        });
      } catch (e) {
        setCurrentScreen(ScreenName.sub_invalid);
        FirebaseAnalytics.instance.logEvent(name: "subject_error", parameters: {"error": e.toString()});
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          text: subjectToString(subject ?? Subject.invalid),
          isUpward: false,
        ),
        surfaceTintColor: subjectToColor(subject ?? Subject.invalid),
      ),
      body: subject != null ? AnimationLimiter(
        child: ListView.builder(itemCount: chapters?.length, itemBuilder: (BuildContext context, int i) {
          return AnimationConfiguration.staggeredList(
            position: i,
            duration: Duration(milliseconds: appFadeDuration.inMilliseconds ~/ 1.5),
            child: FadeInAnimation(
              child: ListTile(
                  onTap: () {
                    FirebaseAnalytics.instance.logEvent(
                        name: "view_chapter",
                        parameters: {
                          "subject": subjectToString(subject ?? Subject.invalid),
                          "chapter": chapters?[i].name ?? "",
                        }
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext contextDialog) => AlertDialog(
                          title: Text(chapters![i].name),
                          content: ListView.builder(
                              itemCount: chapters?[i].books.length,
                              itemBuilder: (BuildContext contextListView, int j) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: Text(
                                      chapters?[i].books[j],
                                    style: const TextStyle(
                                      fontSize: 16.0
                                    ),
                                  ),
                                );
                              }
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(contextDialog).pop();
                              },
                              child: const Text("Okay", style: TextStyle(fontSize: 16),),
                            ),
                          ],
                        )
                    );
                  },
                  // tileColor: Colors.white,
                  title: Text(chapters?[i].name ?? ""),
              ),
            ),
          );
        }),
      ) : getLoader()
    );
  }
}
