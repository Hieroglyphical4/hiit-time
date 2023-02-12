import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Get Settings the User Previously Stored:
Future<Map<String, dynamic>> getSavedUserSettings() async {
  final prefs = await SharedPreferences.getInstance(); // Access Settings from Memory

  // Create string map to hold Settings
  Map<String, dynamic> settings = {};
  settings['workDuration'] = (prefs.getInt('workDuration') ?? defaultWorkDuration).toString();
  settings['restDuration'] = (prefs.getInt('restDuration') ?? defaultRestDuration).toString();

  return settings;
}

// Method to update Start Time
Future<void> setWorkDuration(int value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('workDuration', value);
}

// Method to update Start Time
Future<void> setRestDuration(int value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('restDuration', value);
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