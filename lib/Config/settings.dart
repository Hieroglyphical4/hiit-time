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


/// Theme Related defaults
var defaultTheme = 'Default';
var appCurrentTheme = defaultTheme;

// In some cases text/icon symbols needs to be altered to be legible with a theme
// this boolean supports that behavior
bool textColorOverwrite = false;
bool alternateColorOverwrite = false;


// Dark mode default colors
var primaryColorDarkMode;
var secondaryColorDarkMode;
var primaryAccentColorDarkMode;
var secondaryAccentColorDarkMode;
var runningClockColorDarkMode;

// Light mode Default colors
var primaryColorLightMode;
var secondaryColorLightMode;
var primaryAccentColorLightMode;
var secondaryAccentColorLightMode;
var runningClockColorLightMode;

// Setup current app colors to Default Dark Mode
var primaryColor;
var secondaryColor;
var primaryAccentColor;
var secondaryAccentColor;
var runningClockColor;


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


  // Call Methods to assign App Colors
  appCurrentTheme = prefs.getString('appTheme') ?? defaultTheme;
  setupAppTheme(appCurrentTheme);
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
  prefs.remove('alertWorkModeStartedEnabled');
  prefs.remove('alertRestModeStartedEnabled');
  prefs.remove('modeSwitchAlertEnabled');
  prefs.remove('restartButtonAudioEnabled');
  prefs.remove('saveButtonAudioEnabled');
  prefs.remove('cancelButtonAudioEnabled');
  prefs.remove('switchButtonAudioEnabled');
  prefs.remove('appInDarkMode');
  prefs.remove('appTheme');

  prefs.remove('audioModeSwitchAlertRest');
  prefs.remove('audioModeSwitchAlertWork');
  prefs.remove('audioTimerAlarm');
  prefs.remove('audioAlertWorkModeStarted');
  prefs.remove('audioAlertRestModeStarted');
  prefs.remove('audioTimerCountdownAtTen');
  prefs.remove('audioTimerCountdownAtThree');
  prefs.remove('audioTimerCountdownAtTwo');
  prefs.remove('audioTimerCountdownAtOne');
  prefs.remove('audioAssembledCountdown');
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

/// App Theme related settings
List<String> appPossibleThemes = ['Default', 'Bubblegum', 'Pumpkin'];

void setupAppTheme(String theme) {
  switch (theme) {
    case "Default":
      textColorOverwrite = false;
      alternateColorOverwrite = false;

      // Dark mode
      primaryColorDarkMode = Colors.white;
      secondaryColorDarkMode = Colors.grey.shade900; // Almost black
      primaryAccentColorDarkMode = Colors.blue.shade400;
      secondaryAccentColorDarkMode = Colors.blueGrey;
      runningClockColorDarkMode = Colors.lightGreenAccent.shade700;

      // Light mode
      primaryColorLightMode = Colors.black;
      secondaryColorLightMode = Colors.white;
      primaryAccentColorLightMode = Colors.blue.shade400;
      secondaryAccentColorLightMode = Colors.blueGrey;
      runningClockColorLightMode = Colors.lightGreenAccent.shade700;
      break;

    case "Bubblegum":
      textColorOverwrite = true;
      alternateColorOverwrite = false;

      // Dark mode
      primaryColorDarkMode = Colors.white;
      secondaryColorDarkMode = Colors.pink.shade600;
      primaryAccentColorDarkMode = Colors.tealAccent;
      secondaryAccentColorDarkMode = Colors.yellow;
      runningClockColorDarkMode = secondaryAccentColorDarkMode;

      // Light mode
      primaryColorLightMode = Colors.black;
      secondaryColorLightMode = Colors.pink.shade200;
      primaryAccentColorLightMode = Colors.teal;
      secondaryAccentColorLightMode = Colors.yellow;
      runningClockColorLightMode = secondaryAccentColorLightMode;
      break;

    case "Pumpkin":
      textColorOverwrite = false;
      alternateColorOverwrite = true;

      // Dark mode
      primaryColorDarkMode = Colors.white;
      secondaryColorDarkMode = Colors.deepOrange.shade900;
      primaryAccentColorDarkMode = Colors.yellow.shade600;
      secondaryAccentColorDarkMode = Colors.green.shade700;
      runningClockColorDarkMode = secondaryAccentColorDarkMode;

      // Light mode
      primaryColorLightMode = Colors.black;
      secondaryColorLightMode = Colors.deepOrangeAccent.shade200;
      primaryAccentColorLightMode = Colors.yellowAccent;
      secondaryAccentColorLightMode = Colors.green.shade700;
      runningClockColorLightMode = secondaryAccentColorLightMode;
      break;
  }
}

void setupDarkOrLightMode(bool appInDarkMode) {
    if (appInDarkMode) {
      appCurrentlyInDarkMode = true;
      primaryColor = primaryColorDarkMode;
      secondaryColor = secondaryColorDarkMode;
      primaryAccentColor = primaryAccentColorDarkMode;
      secondaryAccentColor = secondaryAccentColorDarkMode;
      runningClockColor = runningClockColorDarkMode;
    } else {
      appCurrentlyInDarkMode = false;
      primaryColor = primaryColorLightMode;
      secondaryColor = secondaryColorLightMode;
      primaryAccentColor = primaryAccentColorLightMode;
      secondaryAccentColor = secondaryAccentColorLightMode;
      runningClockColor = runningClockColorLightMode;
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
var assetSalliThree = 'sounds/Amplified/SalliThree3.mp3';
var assetSalliTwo = 'sounds/Amplified/SalliTwo2.mp3';
var assetSalliOne = 'sounds/Amplified/SalliOne2.mp3';

// Effects:
var assetCorrect = 'sounds/Correct1.mp3';
var assetWoosh = 'sounds/Woosh-spaced.mp3';
var assetSelectionReversed = 'sounds/Selection1Reversed.mp3';
var assetSwitchAndBeep = 'sounds/SwitchAndBeep1.mp3';
var assetSwitch = 'sounds/Switch1.mp3';
var assetPongUp = 'sounds/Amplified/PongUpAmped3.mp3';
var assetPongUpExtended = 'sounds/Amplified/PongUpExtended2.mp3';
var assetPongDown = 'sounds/Amplified/PongDownAmped.mp3';
var assetShopOpenBell = 'sounds/ShopOpenBellv2.mp3';
var assetShopCloseBell = 'sounds/ShopCloseBell.mp3';
var assetFlourish = 'sounds/Flourish.mp3';
var assetFlourishDelayed = 'sounds/FlourishDelayed2.mp3';

// 3-2-1 Countdowns Assembled:
// Three asset strings delimited with commas for later transformation
var assembledAssetSalliCountdown = "$assetSalliThree,$assetSalliTwo,$assetSalliOne";
var assembledAssetPongUpCountdown = "$assetPongUp,$assetPongUpExtended,$assetPongUp";


/// Maps Between Audio Assets and Descriptive text displayed to User
Map<String, String> timerAlarmAssetMap = {
  assetAlarmPiano: 'Piano Alarm',
  assetAlarmBeepBeep: 'Beep Beep Alarm',
  assetAlarmStandard: 'Standard Alarm',
  // 'test': 'Standard Alarm',
  // 'test2': 'Standard Alarm',
  // 'test3': 'Standard Alarm',
  // 'test4': 'Standard Alarm',
  // 'test5': 'Standard Alarm',
  // 'test6': 'Standard Alarm',
  // 'test7': 'Standard Alarm'
};

Map<String, String> threeTwoOneCountdownAssetMap = {
  assembledAssetSalliCountdown: 'Salli Countdown',
  assembledAssetPongUpCountdown: 'Pong Up',
};

Map<String, String> tenSecondWarningAssetMap = {
  assetJoeyTen: "Joey: 'Ten'",
  assetFlourishDelayed: "Flourish"
};

Map<String, String> alertWorkModeStartedAssetMap = {
  assetSalliWork: "Salli: 'Work'",
  assetShopOpenBell: 'Shop Open Bell',
  assetShopCloseBell: 'Shop Close Bell',
  assetFlourish: "Flourish"
};

Map<String, String> alertRestModeStartedAssetMap = {
  assetSalliRest: "Salli: 'Rest'",
  assetShopOpenBell: 'Shop Open Bell',
  assetShopCloseBell: 'Shop Close Bell',
  assetFlourish: "Flourish"
};