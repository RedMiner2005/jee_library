import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const String codeNoInternet = "ERR";
const int codeDoesNotExist = -1;
const String deviceUUIDKey = "device_uuid";
const String firstTimeKey = "first_time";
const String sharedPrefKey = "shared_pref";

const String appTitle = "JEE Library";
const String appVersion = "1.1.0";
String appShortLegalese = "© Pratyush Nair, ${DateTime.now().year.toString()}";
const String appCredit = "An app built to help find any chapter from the JEE syllabus, in the 45 notebooks.\nBuilt by Pratyush Nair.";
const String appLegalese = "The '$appTitle' mobile application (\"the App\") is provided as is, without any representation or warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and non-infringement.\n\n"
    "The App's developer, Pratyush Nair, assumes no responsibility for errors or omissions in the contents of the App. Pratyush Nair shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of the use or inability to use the App, even if advised of the possibility of such damages. The user of the App assumes all responsibility and risk for the use of this App.\n\n"
    "The App may contain links to external websites or resources that are not owned or controlled by Pratyush Nair. Pratyush Nair has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third-party websites or resources. The inclusion of any such links does not imply endorsement by Pratyush Nair.\n\n"
    "Please note that the App uses Google Analytics, a web analytics service provided by Alphabet, Inc. (\"Google\"). Google Analytics collects and processes data about how the App is used and shares it with Pratyush Nair. This data includes, but is not limited to, information about your device, operating system, IP address, and usage patterns within the App. By using the App, you consent to the processing of data about you by Google in the manner and for the purposes set out in Google's Privacy Policy.\n\n"
    "It is important to review Google's Privacy Policy to understand how your data is collected, used, and protected by Google when using the App. You can find Google's Privacy Policy at https://policies.google.com/technologies/partner-sites.\n\n"
    "By using the App, you hereby consent to this disclaimer, agree to its terms, and acknowledge the usage of Google Analytics and the collection of data by Google as described above.\n";
const Color appColor = Color(0xff6750a4);
const Duration appFadeDuration = Duration(milliseconds: 350);
const Widget appTitleWidget = Padding(
  padding: EdgeInsets.fromLTRB(0, 8.0, 8.0, 8.0),
  child:   Text(
    appTitle,
    style: TextStyle(
      fontSize: 22,
    ),
  ),
);




