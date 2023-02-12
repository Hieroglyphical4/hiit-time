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
int defaultWorkDuration = 45;
int defaultRestDuration = 30;

int defaultTimeModifyValueAdd = 15;
int defaultTimeModifyValueSub = 15;

double defaultVolume = 0.5;
bool appInTimerModeDefault = true;
bool appInDarkModeDefault = true;
bool appMutedDefault = false;

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