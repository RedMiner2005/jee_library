import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../services/consts.dart';

final _random = Random();
const List<String> waitMessages = [
  "Great things come to those who wait",
  "Every delay has a purpose; every wait has a meaning",
  "Waiting is the calm before the storm of success",
  "Sometimes the best things in life are worth waiting for",
  "The key to waiting is to stay focused on the goal, even when the path seems long",
  "When you feel like giving up, remember that the best things often come to those who persevere"
];

Widget getLoader() {
  return Center(
    child: AnimationLimiter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: AnimationConfiguration.toStaggeredList(
            childAnimationBuilder: (widget) => FadeInAnimation(child: widget),
            duration: appFadeDuration,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SpinKitSpinningLines(
                    color: appColor
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  waitMessages[_random.nextInt(waitMessages.length)],
                  textAlign: TextAlign.center,
                ),
              )
            ]
        ),
      ),
    ),
  );
}