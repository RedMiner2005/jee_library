import 'package:flutter/material.dart';
import 'package:jee_library/services/analytics_consts.dart';
import 'package:jee_library/services/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showCustomAboutDialog({
  required BuildContext context,
  String? applicationName,
  String? applicationVersion,
  Widget? applicationIcon,
  String? applicationLegalese,
  List<Widget>? children,
  SharedPreferences? sharedPref,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  setCurrentScreen(ScreenName.about);
  showDialog<void>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return CustomAboutDialog(
        applicationName: applicationName,
        applicationVersion: applicationVersion,
        applicationIcon: applicationIcon,
        applicationLegalese: applicationLegalese,
        sharedPref: sharedPref,
        children: children,
      );
    },
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
  );
}

class CustomAboutDialog extends StatelessWidget {
  /// Creates an about box.
  ///
  /// The arguments are all optional. The application name, if omitted, will be
  /// derived from the nearest [Title] widget. The version, icon, and legalese
  /// values default to the empty string.
  const CustomAboutDialog({
    super.key,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
    this.children,
    this.sharedPref,
  });

  /// The name of the application.
  ///
  /// Defaults to the value of [Title.title], if a [Title] widget can be found.
  /// Otherwise, defaults to [Platform.resolvedExecutable].
  final String? applicationName;

  /// The version of this build of the application.
  ///
  /// This string is shown under the application name.
  ///
  /// Defaults to the empty string.
  final String? applicationVersion;

  /// The icon to show next to the application name.
  ///
  /// By default no icon is shown.
  ///
  /// Typically this will be an [ImageIcon] widget. It should honor the
  /// [IconTheme]'s [IconThemeData.size].
  final Widget? applicationIcon;

  /// A string to show in small print.
  ///
  /// Typically this is a copyright notice.
  ///
  /// Defaults to the empty string.
  final String? applicationLegalese;

  /// Widgets to add to the dialog box after the name, version, and legalese.
  ///
  /// This could include a link to a Web site, some descriptive text, credits,
  /// or other information to show in the about box.
  ///
  /// Defaults to nothing.
  final List<Widget>? children;

  /// Shared Preferences Instance
  /// Required for the TNC screen
  final SharedPreferences? sharedPref;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final String name = applicationName ?? appTitle;
    final String version = applicationVersion ?? appVersion;
    final Widget? icon = applicationIcon;
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return AlertDialog(
      content: ListBody(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (icon != null) IconTheme(data: themeData.iconTheme, child: icon),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ListBody(
                    children: <Widget>[
                      Text(name, style: themeData.textTheme.headlineSmall),
                      Text(version, style: themeData.textTheme.bodyMedium),
                      const SizedBox(height: 18.0),
                      Text(applicationLegalese ?? '', style: themeData.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ...?children,
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
              themeData.useMaterial3
                  ? "Disclaimer"
                  : "Disclaimer".toUpperCase()
          ),
          onPressed: () {
            Navigator.of(context).pushNamed("/tnc", arguments: {sharedPrefKey: sharedPref, firstTimeKey: false});
          },
        ),
        TextButton(
          child: Text(
              themeData.useMaterial3
                  ? "Licenses"
                  : "Licenses".toUpperCase()
          ),
          onPressed: () {
            setCurrentScreen(ScreenName.licenses);
            showLicensePage(
              context: context,
              applicationName: applicationName,
              applicationVersion: applicationVersion,
              applicationIcon: applicationIcon,
              applicationLegalese: applicationLegalese,
            );
          },
        ),
        TextButton(
          child: Text(
              themeData.useMaterial3
                  ? localizations.closeButtonLabel
                  : localizations.closeButtonLabel.toUpperCase()
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      scrollable: true,
    );
  }
}
