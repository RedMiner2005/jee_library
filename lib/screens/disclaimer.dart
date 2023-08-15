import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:jee_library/services/analytics_consts.dart';
import 'package:jee_library/services/consts.dart';
import 'package:jee_library/services/firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final DatabaseService db;

  const TermsAndConditionsScreen({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final sharedPref = args[sharedPrefKey] as SharedPreferences;
    final isFirstTime = args[firstTimeKey] as bool;
    setCurrentScreen(ScreenName.disclaimer);
    if (!isFirstTime) {
      FirebaseAnalytics.instance.logEvent(name: "voluntary_disclaimer_view");
    }
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                  childAnimationBuilder: (widget) => FadeInAnimation(duration: appFadeDuration, child: widget,),
                  children: isFirstTime ? _getFirstWidgets(context) : _getOtherWidgets(context),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: isFirstTime ? FloatingActionButton.extended(
          onPressed: () {
            sharedPref.setBool(firstTimeKey, false);
            Navigator.of(context).pushReplacementNamed("/");
          },
          label: const Text("Agree and Continue"),
          icon: const Icon(Icons.done_rounded),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

List<Widget> _getFirstWidgets(BuildContext context) {
  return <Widget> [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Hi, Anay! 👋",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Before we begin, please read the following disclaimer:",
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    ),
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(appLegalese),
    ),
    const SizedBox(
      height: 100.0,
    )
  ];
}

List<Widget> _getOtherWidgets(BuildContext context) {
  return <Widget> [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Disclaimer",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    ),
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(appLegalese),
    ),
    const SizedBox(
      height: 100.0,
    )
  ];
}
