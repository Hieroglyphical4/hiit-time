import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// General Setting Default Values:
int defaultWorkDuration = 45;
int defaultRestDuration = 30;

int defaultTimeModifyValueAdd = 15;
int defaultTimeModifyValueSub = 15;

double defaultVolume = 0.5;

bool appInTimerModeDefault = true;
bool appInDarkModeDefault = true;
bool appMutedDefault = false;

/// Advanced Menu Default Settings:
bool timerAlarmEnabledDefault = true;
bool threeTwoOneCountdownEnabledDefault = true;
bool tenSecondWarningEnabledDefault = true;
bool alertWorkModeStartedEnabledDefault = true;
bool alertRestModeStartedEnabledDefault = true;

bool restartButtonAudioEnabledDefault = true;
bool saveButtonAudioEnabledDefault = true;
bool cancelButtonAudioEnabledDefault = true;
bool switchButtonAudioEnabledDefault = true;

/// Audio Related Default Settings:
var audioAlertWorkModeStartedDefault = assetSalliWork;
var audioAlertRestModeStartedDefault = assetSalliRest;
var audioTimerAlarmDefault = assetAlarmPiano;
var audioTimerCountdownAtTenDefault = assetJoeyTen;
var audioTimerCountdownAtThreeDefault = assetSalliThree;
var audioTimerCountdownAtTwoDefault = assetSalliTwo;
var audioTimerCountdownAtOneDefault = assetSalliOne;
var audioAssembledCountdownDefault = assembledAssetSalliCountdown;

// buttons:
var audioSaveButtonDefault = assetCorrect;
var audioCancelButtonDefault = assetWoosh;
var audioRestartButtonDefault = assetSelectionReversed;
var audioSwitchButtonEnabledDefault = assetSwitchAndBeep;
var audioSwitchButtonDisabledDefault = assetSwitch;


/// Current settings to be checked during code execution
bool appCurrentlyMuted = appMutedDefault;
bool appCurrentlyInDarkMode = appInDarkModeDefault;
bool appCurrentlyInTimerMode = appInTimerModeDefault;

bool timerAlarmCurrentlyEnabled = timerAlarmEnabledDefault;
bool threeTwoOneCountdownCurrentlyEnabled = threeTwoOneCountdownEnabledDefault;
bool tenSecondWarningCurrentlyEnabled = tenSecondWarningEnabledDefault;
bool alertWorkModeStartedCurrentlyEnabled = alertWorkModeStartedEnabledDefault;
bool alertRestModeStartedCurrentlyEnabled = alertRestModeStartedEnabledDefault;

bool restartButtonAudioCurrentlyEnabled = restartButtonAudioEnabledDefault;
bool saveButtonAudioCurrentlyEnabled = saveButtonAudioEnabledDefault;
bool cancelButtonAudioCurrentlyEnabled = cancelButtonAudioEnabledDefault;
bool switchButtonAudioCurrentlyEnabled = switchButtonAudioEnabledDefault;

double appCurrentVolume = defaultVolume;

var audioForAlertWorkModeStarted = audioAlertWorkModeStartedDefault;
var audioForAlertRestModeStarted = audioAlertRestModeStartedDefault;
var audioForTimerAlarm = audioTimerAlarmDefault;
var audioForTimerCountdownAtTen = audioTimerCountdownAtTenDefault;
var audioForTimerCountdownAtThree = audioTimerCountdownAtThreeDefault;
var audioForTimerCountdownAtTwo = audioTimerCountdownAtTwoDefault;
var audioForTimerCountdownAtOne = audioTimerCountdownAtOneDefault;
var audioForAssembledCountdown = audioAssembledCountdownDefault;

var audioForRestartButton = audioRestartButtonDefault;
var audioForSaveButton = audioSaveButtonDefault;
var audioForCancelButton = audioCancelButtonDefault;
var audioForSwitchButtonEnabled = audioSwitchButtonEnabledDefault;
var audioForSwitchButtonDisabled = audioSwitchButtonDisabledDefault;


// Dark mode default colors
var primaryColor = Colors.white;
var secondaryColor = Colors.grey.shade900; // Almost black
var primaryAccentColor = Colors.blue.shade400;
var secondaryAccentColor = Colors.blueGrey;


/// Get Settings the User Previously Stored:
/// If none are found, return default settings
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

  appCurrentVolume = prefs.getDouble('appVolume') ?? defaultVolume;

  appCurrentlyMuted = prefs.getBool('appMuted') ?? appMutedDefault;
  appCurrentlyInTimerMode = prefs.getBool('appInTimerMode') ?? appInTimerModeDefault;

  timerAlarmCurrentlyEnabled = prefs.getBool('timerAlarmEnabled') ?? timerAlarmEnabledDefault;
  threeTwoOneCountdownCurrentlyEnabled = prefs.getBool('threeTwoOneCountdownEnabled') ?? threeTwoOneCountdownEnabledDefault;
  tenSecondWarningCurrentlyEnabled = prefs.getBool('tenSecondWarningEnabled') ?? tenSecondWarningEnabledDefault;
  alertWorkModeStartedCurrentlyEnabled = prefs.getBool('alertWorkModeStartedEnabled') ?? alertWorkModeStartedEnabledDefault;
  alertRestModeStartedCurrentlyEnabled = prefs.getBool('alertRestModeStartedEnabled') ?? alertRestModeStartedEnabledDefault;

  restartButtonAudioCurrentlyEnabled = prefs.getBool('restartButtonAudioEnabled') ?? restartButtonAudioEnabledDefault;
  saveButtonAudioCurrentlyEnabled = prefs.getBool('saveButtonAudioEnabled') ?? saveButtonAudioEnabledDefault;
  cancelButtonAudioCurrentlyEnabled = prefs.getBool('cancelButtonAudioEnabled') ?? cancelButtonAudioEnabledDefault;
  switchButtonAudioCurrentlyEnabled = prefs.getBool('switchButtonAudioEnabled') ?? switchButtonAudioEnabledDefault;

  audioForAlertWorkModeStarted = prefs.getString('audioAlertWorkModeStarted') ?? audioAlertWorkModeStartedDefault;
  audioForAlertRestModeStarted = prefs.getString('audioAlertRestModeStarted') ?? audioAlertRestModeStartedDefault;
  audioForTimerAlarm = prefs.getString('audioTimerAlarm') ?? audioTimerAlarmDefault;

  audioForTimerCountdownAtTen = prefs.getString('audioTimerCountdownAtTen') ?? audioTimerCountdownAtTenDefault;
  audioForTimerCountdownAtThree = prefs.getString('audioTimerCountdownAtThree') ?? audioTimerCountdownAtThreeDefault;
  audioForTimerCountdownAtTwo = prefs.getString('audioTimerCountdownAtTwo') ?? audioTimerCountdownAtTwoDefault;
  audioForTimerCountdownAtOne = prefs.getString('audioTimerCountdownAtOne') ?? audioTimerCountdownAtOneDefault;
  audioForAssembledCountdown = prefs.getString('audioAssembledCountdown') ?? audioAssembledCountdownDefault;

  audioForRestartButton = prefs.getString('audioRestartButton') ?? audioRestartButtonDefault;
  audioForSaveButton = prefs.getString('audioSaveButton') ?? audioSaveButtonDefault;
  audioForCancelButton = prefs.getString('audioCancelButton') ?? audioCancelButtonDefault;
  audioForSwitchButtonEnabled = prefs.getString('audioModeSwitchAlertEnabled') ?? audioSwitchButtonEnabledDefault;
  audioForSwitchButtonDisabled = prefs.getString('audioModeSwitchAlertDisabled') ?? audioSwitchButtonDisabledDefault;


  // Call Method to assign App Colors
  setupDarkOrLightMode(prefs.getBool('appInDarkMode') ?? appInDarkModeDefault);

  return settings;
}

// Remove all user saved settings
void clearUserSettings() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('workDuration');
  prefs.remove('restDuration');
  prefs.remove('timeModifyValueAdd');
  prefs.remove('timeModifyValueSub');
  prefs.remove('appVolume');
  prefs.remove('appMuted');
  prefs.remove('appInTimerMode');
  prefs.remove('timerAlarmEnabled');
  prefs.remove('threeTwoOneCountdownEnabled');
  prefs.remove('tenSecondWarningEnabled');
  prefs.remove('modeSwitchAlertEnabled');
  prefs.remove('restartButtonAudioEnabled');
  prefs.remove('saveButtonAudioEnabled');
  prefs.remove('cancelButtonAudioEnabled');
  prefs.remove('switchButtonAudioEnabled');
  prefs.remove('appInDarkMode');

  prefs.remove('audioModeSwitchAlertRest');
  prefs.remove('audioModeSwitchAlertWork');
  prefs.remove('audioTimerAlarm');
  prefs.remove('audioTimerCountdownAtTen');
  prefs.remove('audioTimerCountdownAtThree');
  prefs.remove('audioTimerCountdownAtTwo');
  prefs.remove('audioTimerCountdownAtOne');
  prefs.remove('audioRestartButton');
  prefs.remove('audioSaveButton');
  prefs.remove('audioCancelButton');
  prefs.remove('audioModeSwitchAlertEnabled');
  prefs.remove('audioModeSwitchAlertDisabled');
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
  appCurrentVolume = value;
}

// Reusable setter/getter for booleans
Future<void> setBooleanSetting(String setting, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(setting, value);
}

// Reusable setter/getter for strings
Future<void> setStringSetting(String setting, String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(setting, value);
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

/// Audio Assets:

// Alarms
var assetAlarmPiano = 'sounds/Amplified/PianoAlarmAmped.mp3';
var assetAlarmBeepBeep = 'sounds/alarm-beep-beep-1.mp3';
var assetAlarmStandard = 'sounds/alarm-standard-1.mp3';

// AI Voices
var assetSalliRest = 'sounds/Amplified/Rest-Voice-salli-Amped2.mp3';
var assetSalliWork = 'sounds/Amplified/Work-Voice-salli-Amped2.mp3';
var assetJoeyTen = 'sounds/Amplified/JoeyTenAmped2.mp3';
var assetSalliThree = 'sounds/Amplified/SalliThree.mp3';
var assetSalliTwo = 'sounds/Amplified/SalliTwo.mp3';
var assetSalliOne = 'sounds/Amplified/SalliOne1.mp3';

// Effects:
var assetCorrect = 'sounds/Correct1.mp3';
var assetWoosh = 'sounds/Woosh-spaced.mp3';
var assetSelectionReversed = 'sounds/Selection1Reversed.mp3';
var assetSwitchAndBeep = 'sounds/SwitchAndBeep1.mp3';
var assetSwitch = 'sounds/Switch1.mp3';
var assetPongUp = 'sounds/PongUp.mp3';

var assetShopOpenBell = 'sounds/ShopOpenBellv2.mp3';
var assetShopCloseBell = 'sounds/ShopCloseBell.mp3';

// 3-2-1 Countdowns Assembled:
// Three asset strings delimited with commas for later transformation
var assembledAssetSalliCountdown = "$assetSalliThree,$assetSalliTwo,$assetSalliOne";
var assembledAssetPongUpCountdown = "$assetPongUp,$assetPongUp,$assetPongUp";

/// Maps Between Audio Assets and Descriptive text displayed to User
Map<String, String> timerAlarmAssetMap = {
  assetAlarmPiano: 'Piano Alarm',
  assetAlarmBeepBeep: 'Beep Beep Alarm',
  assetAlarmStandard: 'Standard Alarm'
};

Map<String, String> threeTwoOneCountdownAssetMap = {
  assembledAssetSalliCountdown: 'Salli Countdown',
  assembledAssetPongUpCountdown: 'Pong Up'
};

Map<String, String> tenSecondWarningAssetMap = {
  assetJoeyTen: "Joey: 'Ten'",
  assetShopOpenBell: 'Shop Open Bell',
  assetShopCloseBell: 'Shop Close Bell'
};

Map<String, String> alertWorkModeStartedAssetMap = {
  assetSalliWork: "Salli: 'Work'",
  assetShopOpenBell: 'Shop Open Bell',
  assetShopCloseBell: 'Shop Close Bell'
};

Map<String, String> alertRestModeStartedAssetMap = {
  assetSalliRest: "Salli: 'Rest'",
  assetShopOpenBell: 'Shop Open Bell',
  assetShopCloseBell: 'Shop Close Bell'
};