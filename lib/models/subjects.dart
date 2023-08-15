import 'package:flutter/material.dart';

enum Subject { physics, chemistry, math, invalid }

Subject subjectFromString(String name) {
  switch (name) {
    case "Physics":
      return Subject.physics;
    case "Chemistry":
      return Subject.chemistry;
    case "Mathematics":
      return Subject.math;
  }
  return Subject.invalid;
}

String subjectToString(Subject subject) {
  switch (subject) {

    case Subject.physics:
      return "Physics";
    case Subject.chemistry:
      return "Chemistry";
    case Subject.math:
      return "Mathematics";
    case Subject.invalid:
      return "Loading...";
  }
}

IconData subjectToIcon(Subject subject) {
  switch (subject) {
    case Subject.physics:
      return Icons.rocket_launch_outlined;
    case Subject.chemistry:
      return Icons.science_rounded;
    case Subject.math:
      return Icons.architecture_rounded;
    case Subject.invalid:
      return Icons.error_rounded;
  }
}

MaterialColor subjectToColor(Subject subject) {
  switch (subject) {
    case Subject.physics:
      return Colors.red;
    case Subject.chemistry:
      return Colors.lightBlue;
    case Subject.math:
      return Colors.orange;
    case Subject.invalid:
      return Colors.blueGrey;
  }
}