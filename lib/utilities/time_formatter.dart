import 'package:flutter/material.dart';

class TimeFormatter {
  static String durationToString(Duration duration) {
    return duration.toString().split(".")[0];
  }

  static Duration stringToDuration(String string) {
    string = string.padLeft(5, "0");

    int seconds = int.parse(string.substring(string.length - 2));
    int minutes = int.parse(string.substring(string.length - 4, string.length - 2));
    int hours = int.parse(string.substring(0, string.length - 4));

    Duration duration = Duration(seconds: seconds, minutes: minutes, hours: hours);

    return duration;
  }
}