import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// General Setting Default Values:
int defaultWorkDuration = 45;
int defaultRestDuration = 30;

int defaultTimeModifyValueAdd = 15;
int defaultTimeModifyValueSub = 15;

double defaultVolume = 0.5;

bool appInTimerModeDefault = true;
bool appInDarkModeDefault = true;
bool appMutedDefault = false;

// Advanced Menu Default Settings:
bool timerAlarmEnabledDefault = true;
bool threeTwoOneCountdownEnabledDefault = true;
bool tenSecondWarningEnabledDefault = true;
bool modeSwitchAlertEnabledDefault = true;


// TODO Set defaults and Persist
bool restartButtonAudioEnabled = true;
bool saveButtonAudioEnabled = true;
bool cancelButtonAudioEnabled = true;
bool switchButtonAudioEnabled = true;

// Current settings to be checked during code execution
bool appCurrentlyMuted = appMutedDefault;
bool appCurrentlyInDarkMode = appInDarkModeDefault;
bool appCurrentlyInTimerMode = appInTimerModeDefault;

bool timerAlarmCurrentlyEnabled = timerAlarmEnabledDefault;
bool threeTwoOneCountdownCurrentlyEnabled = threeTwoOneCountdownEnabledDefault;
bool tenSecondWarningCurrentlyEnabled = tenSecondWarningEnabledDefault;
bool modeSwitchAlertCurrentlyEnabled = modeSwitchAlertEnabledDefault;


// Dark mode default colors
var primaryColor = Colors.white;
var secondaryColor = Colors.grey.shade900; // Almost black
var primaryAccentColor = Colors.blue.shade400;
var secondaryAccentColor = Colors.blueGrey;


// Get Settings the User Previously Stored:
Future<Map<String, dynamic>> getSavedUserSettings() async {
  // Access Settings from Memory
  final prefs = await SharedPreferences.getInstance();

  // Create string map to hold Settings
  Map<String, dynamic> settings = {};
  settings['workDuration'] = (prefs.getInt('workDuration') ?? defaultWorkDuration).toString();
  settings['restDuration'] = (prefs.getInt('restDuration') ?? defaultRestDuration).toString();
  settings['timeModifyValueAdd'] = (prefs.getInt('timeModifyValueAdd') ?? defaultTimeModifyValueAdd).toString();
  settings['timeModifyValueSub'] = (prefs.getInt('timeModifyValueSub') ?? defaultTimeModifyValueSub).toString();
  settings['appVolume'] = (prefs.getDouble('appVolume') ?? defaultVolume).toString();

  appCurrentlyMuted = prefs.getBool('appMuted') ?? appMutedDefault;
  appCurrentlyInTimerMode = prefs.getBool('appInTimerMode') ?? appInTimerModeDefault;

  timerAlarmCurrentlyEnabled = prefs.getBool('timerAlarmEnabled') ?? timerAlarmEnabledDefault;
  threeTwoOneCountdownCurrentlyEnabled = prefs.getBool('threeTwoOneCountdownEnabled') ?? threeTwoOneCountdownEnabledDefault;
  tenSecondWarningCurrentlyEnabled = prefs.getBool('tenSecondWarningEnabled') ?? tenSecondWarningEnabledDefault;
  modeSwitchAlertCurrentlyEnabled = prefs.getBool('modeSwitchAlertEnabled') ?? modeSwitchAlertEnabledDefault;


  // Call Method to assign App Colors
  setupDarkOrLightMode(prefs.getBool('appInDarkMode') ?? appInDarkModeDefault);

  return settings;
}

// Method to update Work Time
Future<void> setWorkDuration(int value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('workDuration', value);
}

// Method to update Rest Time
Future<void> setRestDuration(int value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('restDuration', value);
}

// Method to update Time Modifier for Addition Button
Future<void> setTimeModifyValueAdd(int value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('timeModifyValueAdd', value);
}

// Method to update Time Modifier for Subtraction Button
Future<void> setTimeModifyValueSub(int value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('timeModifyValueSub', value);
}

// Method to update Time Modifier for Subtraction Button
Future<void> setAppVolume(double value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setDouble('appVolume', value);
}

// Reusable setter/getter for booleans
Future<void> setBooleanSetting(String setting, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(setting, value);
}

void setupDarkOrLightMode(bool appInDarkMode) {
  if (appInDarkMode) {
    appCurrentlyInDarkMode = true;
    primaryColor = Colors.white;
    secondaryColor = Colors.grey.shade900;
    primaryAccentColor = Colors.blue.shade400;
    secondaryAccentColor = Colors.blueGrey;
  } else {
    appCurrentlyInDarkMode = false;
    primaryColor = Colors.black;
    secondaryColor = Colors.white;
    primaryAccentColor = Colors.blue.shade400;
    secondaryAccentColor = Colors.blueGrey;
  }
}