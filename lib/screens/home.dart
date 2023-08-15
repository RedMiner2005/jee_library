import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jee_library/models/subjects.dart';
import 'package:jee_library/services/analytics_consts.dart';
import 'package:jee_library/services/consts.dart';
import 'package:jee_library/services/firestore.dart';
import 'package:jee_library/widgets/aboutDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase_options.dart';

const _colDivider = SizedBox(height: 10);

void redirectToScan(BuildContext context) {
  Navigator.of(context).pushNamed("/scan");
}

class HomeScreen extends StatefulWidget {
  final DatabaseService db;
  // final bool isFirstTime;
  const HomeScreen({super.key, required this.db});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<ConnectivityResult> subscription;
  late Brightness brightness;
  bool connectivityListening = false;
  bool connected = true;

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
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setCurrentScreen(ScreenName.home);
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> sharedPref) {
      // FlutterNativeSplash.remove();

      if (sharedPref.hasData) {
        if (!sharedPref.data!.containsKey(firstTimeKey)) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed("/tnc", arguments: {sharedPrefKey: sharedPref.data, firstTimeKey: true});
          });
        }
        if (!connectivityListening) {
          subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
            if (result == ConnectivityResult.none && connected) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text("Internet disconnected.")));
              connected = false;
            } else if (!connected) {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text("Back online.")));
              connected = true;
            }
          });
          connectivityListening = true;
        }
        DateTime now = DateTime.now();
        int currentHour = now.hour;
        // currentHour = 23;
        String greeting;
        IconData greetIcon;
        MaterialColor greetColor;
        if (currentHour < 12 && currentHour >= 4) {
          greeting = 'morning';
          greetIcon = Icons.wb_twilight_rounded;
          greetColor = Colors.deepOrange;
        } else if (currentHour < 17 && currentHour >= 12) {
          greeting = 'afternoon';
          greetIcon = Icons.wb_sunny_rounded;
          greetColor = Colors.orange;
        } else {
          greeting = 'evening';
          greetIcon = Icons.nights_stay_rounded;
          greetColor = Colors.lightBlue;
        }
        return Scaffold(
          appBar: AppBar(
            // title: appTitleWidget,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/iconTransparent.png", scale: 1.0,),
            ),
            actions: [
              IconButton(
                onPressed: onAboutPressed(context, sharedPref),
                icon: const Icon(Icons.info_outline_rounded),
              )
            ],
          ),
          body: AnimationLimiter(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (BuildContext context, int i) {
                List<Subject> currSubjects = [Subject.invalid, Subject.physics, Subject.chemistry, Subject.math];
                Widget child;
                if (i == 0) {
                  child = createGreeter(context, greetIcon, greetColor, greeting);
                } else {
                  child = createSubjectCard(context, currSubjects[i]);
                }
                return AnimationConfiguration.staggeredList(
                    position: i,
                    duration: appFadeDuration,
                    child: SlideAnimation(
                      verticalOffset: 20.0,
                      child: FadeInAnimation(
                        child: child,
                      )
                    )
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              Navigator.of(context).pushNamed("/scan").then((resultScan) {
                if (!mounted) return;
                if (resultScan == codeNoInternet) {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(const SnackBar(content: Text("No internet.")));
                  return;
                }
                if (resultScan == null) return;
                Navigator.of(context).pushNamed("/bookDetail", arguments: resultScan).then((resultFind) {
                  if (!mounted) return;
                  if (resultFind == null) return;
                  if (resultFind == -1) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(const SnackBar(content: Text("Invalid barcode. Please try again.")));
                  }
                });
              });
            },
            tooltip: 'Scan Book Code',
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: const Text("Scan"),
          ),
        );
      } else {
        return const CircularProgressIndicator();
      }
    });
  }
}

dynamic onAboutPressed(BuildContext context, AsyncSnapshot<SharedPreferences> sharedPref) {
  return () {
    showCustomAboutDialog(
      context: context,
      applicationName: appTitle,
      applicationVersion: appVersion,
      applicationIcon: Image.asset(
        "assets/iconTransparent.png",
        width: 50,
        height: 50,
        fit: BoxFit.fitWidth,
      ),
      applicationLegalese: appShortLegalese,
      sharedPref: sharedPref.data as SharedPreferences,
      children: [
        const SizedBox(height: 20.0,),
        const Text(appCredit),
      ]
    );
  };
}

Widget createGreeter(BuildContext context, IconData greetIcon, MaterialColor greetColor, String greeting) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
    child: Row(
      children: [
        Icon(
          greetIcon,
          color: greetColor,
          size: 60,
          opticalSize: 40,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
          child: Text(
            "Good $greeting,\nAnay!",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ],
    ),
  );
}

Widget createSubjectCard(BuildContext context, Subject curr) {
  return AnimatedOpacity(
    opacity: 1.0,
    duration: const Duration(milliseconds: 500),
    child: Card(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("/subject", arguments: curr);
        },
        splashColor: Theme.of(context).colorScheme.inversePrimary,
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0, 10.0),
            child: ListTile(
              leading: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: subjectToColor(curr),
                        ),
                        child: Icon(subjectToIcon(curr), color: Colors.white, size: 30,),
                      ),
                    ),
                  )
              ),
              title: Text(
                subjectToString(curr),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
