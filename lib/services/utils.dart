import 'package:flutter/material.dart';

String getTimeString(TimeOfDay timeOfDay) {
  String timeString = "";
  if (timeOfDay.hour < 10) {
    timeString = "0";
  }
  timeString = timeString + timeOfDay.hour.toString() + ":";

  if (timeOfDay.minute < 10) {
    timeString = timeString + "0";
  }

  timeString = timeString + timeOfDay.minute.toString();

  return timeString;
}
