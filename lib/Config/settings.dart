import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Get Previously Stored Settings:
Future<int> getDuration() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('duration') ?? 45; // 45 is default value
}

// Method to update Start Time
Future<void> setDuration(int value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('duration', value);
}


// General Settings:
int setStartTime = 45;
int setRestDuration = 30;
int setTimeModifyValueAdd = 15;
int setTimeModifyValueSub = 15;
double setVolume = 0.5;
bool appInTimerMode = true;
bool appInDarkMode = true;
bool appMuted = false;

// Advanced Menu Settings:
bool timerAlarmEnabled = true;
bool threeTwoOneCountdownEnabled = true;
bool tenSecondWarningEnabled = true;
bool modeSwitchAlertEnabled = true;
bool restartButtonAudioEnabled = true;
bool saveButtonAudioEnabled = true;
bool cancelButtonAudioEnabled = true;
bool switchButtonAudioEnabled = true;



// Dark mode default colors
var primaryColor = Colors.white;
var secondaryColor = Colors.grey.shade900; // Almost black
var primaryAccentColor = Colors.blue.shade400;
var secondaryAccentColor = Colors.blueGrey;