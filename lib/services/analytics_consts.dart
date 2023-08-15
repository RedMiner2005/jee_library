import 'package:firebase_analytics/firebase_analytics.dart';

enum ScanAttemptStatus { valid, invalid, noInternet }

enum ScreenName {
  home, sub_phys, sub_chem, sub_math, sub_invalid,
  book_detail, disclaimer, scanner, about, licenses
}

void setCurrentScreen(ScreenName name) {
  FirebaseAnalytics.instance.setCurrentScreen(screenName: name.name);
}
