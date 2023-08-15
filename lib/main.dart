import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:jee_library/screens/barcode_scanner.dart';
import 'package:jee_library/screens/book_detail.dart';
import 'package:jee_library/screens/home.dart';
import 'package:jee_library/screens/subject_screen.dart';
import 'package:jee_library/screens/disclaimer.dart';
import 'package:jee_library/services/consts.dart';
import 'package:jee_library/services/firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const JEELibraryApp());
}

class JEELibraryApp extends StatefulWidget {
  const JEELibraryApp({Key? key}) : super(key: key);

  @override
  State<JEELibraryApp> createState() => _JEELibraryAppState();
}

class _JEELibraryAppState extends State<JEELibraryApp> {
  late DatabaseService db;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    db = DatabaseService();
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    dynamic routes = {
      '/': (context) => HomeScreen(db: db),
      '/scan': (context) => const BarcodeScanner(),
      '/bookDetail': (context) => BookDetail(db: db),
      '/subject': (context) => SubjectScreen(db: db),
      '/tnc': (context) => TermsAndConditionsScreen(db: db),
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorSchemeSeed: appColor,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: appColor,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeAnimationDuration: const Duration(milliseconds: 500),
      routes: routes,
    );
  }
}
