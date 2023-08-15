import 'package:flutter/material.dart';
import 'package:jee_library/services/consts.dart';

class AppBarTitle extends StatefulWidget {
  final String text;
  final bool isUpward;

  const AppBarTitle({super.key, required this.text, required this.isUpward});

  @override
  State<AppBarTitle> createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: appFadeDuration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      layoutBuilder: layoutBuilder,
      transitionBuilder:
          (Widget child, Animation<double> animation) {
        const double distance = 1.5;
        final inAnimation = Tween<Offset>(
            begin: const Offset(0.0, -distance),
            end: const Offset(0.0, 0.0)
        ).animate(animation);
        final outAnimation = Tween<Offset>(
            begin: const Offset(0.0, distance),
            end: const Offset(0.0, 0.0)
        ).animate(animation);
        bool isIn = (child.key == ValueKey<String>(widget.text));
        if (widget.isUpward) isIn = !isIn;
        return ClipRect(
          clipBehavior: Clip.antiAlias,
          child: SlideTransition(
            position: isIn ? inAnimation : outAnimation,
            child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: child
            ),
          ),
        );
      },
      child: Text(
        widget.text,
        key: ValueKey<String>(widget.text),
        textAlign: TextAlign.left,
      ),
    );
  }
}

Widget layoutBuilder(Widget? currentChild, List<Widget> previousChildren) {
  List<Widget> children = previousChildren;
  if (currentChild != null) {
    children = children.toList()..add(currentChild);
  }
  return Stack(
    alignment: Alignment.centerLeft,
    children: children,
  );
}
