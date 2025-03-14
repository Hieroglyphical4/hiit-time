import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'advanced_settings_menu.dart';
import 'Config/settings.dart';

class SettingsMenu extends StatefulWidget {
  final audio;
  final int? workTime;
  final int? restTime;
  final int? timeModAdd;
  final int? timeModSub;
  final double? appVolume;
  final GlobalKey<AdvancedSettingsMenuState> advancedSettingsKey;

  const SettingsMenu({
    Key? key,
    this.audio,
    this.workTime,
    this.restTime,
    this.timeModAdd,
    this.timeModSub,
    this.appVolume,
    required this.advancedSettingsKey,
  }) : super(key: key);

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  final _formKey = GlobalKey<FormState>();
  late int _workTime;
  late int _restTime;
  late int _timeModAdd;
  late int _timeModSub;
  late double _appVolume;

  // Booleans to track changes to Settings
  bool _settingsChanged = false;
  bool _restSettingChanged = false;
  bool _workSettingChanged = false;
  bool _subTimeSettingChanged = false;
  bool _addTimeSettingChanged = false;

  // Shows and Hides the Hint text for fields you type into
  bool _restTimeHintTextShowing = true;
  bool _workTimeHintTextShowing = true;
  bool _subTimeHintTextShowing = true;
  bool _addTimeHintTextShowing = true;

  FocusNode _restTimeFocusNode = FocusNode();
  FocusNode _workTimeFocusNode = FocusNode();
  FocusNode _subTimeFocusNode = FocusNode();
  FocusNode _addTimeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _workTime = widget.workTime ?? defaultWorkDuration;
    _restTime = widget.restTime ?? defaultRestDuration;
    _timeModAdd = widget.timeModAdd ?? defaultTimeModifyValueAdd;
    _timeModSub = widget.timeModSub ?? defaultTimeModifyValueSub;
    _appVolume = widget.appVolume ?? defaultVolume;

    _restTimeFocusNode.addListener(() => _handleFocusChange(_restTimeFocusNode, 'restTime'));
    _workTimeFocusNode.addListener(() => _handleFocusChange(_workTimeFocusNode, 'workTime'));
    _subTimeFocusNode.addListener(() => _handleFocusChange(_subTimeFocusNode, 'subTime'));
    _addTimeFocusNode.addListener(() => _handleFocusChange(_addTimeFocusNode, 'addTime'));
  }

  @override
  void dispose() {
    _restTimeFocusNode.dispose();
    _workTimeFocusNode.dispose();
    _subTimeFocusNode.dispose();
    _addTimeFocusNode.dispose();
    restTextEditController.dispose();
    workTextEditController.dispose();
    subTimetextEditController.dispose();
    addTimeTextEditController.dispose();
    super.dispose();
  }

  _handleFocusChange(FocusNode focusNode, String textField) {
    if (!focusNode.hasFocus) {
      setState(() {
        textField == 'restTime' ? _restTimeHintTextShowing = true : null;
        textField == 'workTime' ? _workTimeHintTextShowing = true : null;
        textField == 'subTime' ? _subTimeHintTextShowing = true : null;
        textField == 'addTime' ? _addTimeHintTextShowing = true : null;
      });
    }
  }

  void recordSettingsChanged(String setting) {
    setState(() {
      _settingsChanged = true;
      setting == 'rest' ? _restSettingChanged = true : null;
      setting == 'work' ? _workSettingChanged = true : null;
      setting == 'subTime' ? _subTimeSettingChanged = true : null;
      setting == 'addTime' ? _addTimeSettingChanged = true : null;
    });
  }

  void clearSettingsChanged(String setting) {
    setState(() {
      _settingsChanged = false;
      setting == 'rest' ? _restSettingChanged = false : null;
      setting == 'work' ? _workSettingChanged = false : null;
      setting == 'subTime' ? _subTimeSettingChanged = false : null;
      setting == 'addTime' ? _addTimeSettingChanged = false : null;
    });
  }

  // If a string is longer than 3 chars, we assume we are in Minutes
  // Convert given string to reflect that
  String formatDuration(String minutesRaw) {
    var string = minutesRaw;
    var length = string.length;

    // Check if string is still in seconds
    if (length == 2) {
      return string;
    }

    final insertIndex = string.length == 3 ? 1 : 2;
    final substring = string.substring(insertIndex);
    final timeFormatted = insertIndex == 1
        ? "${string[0]}:$substring"
        : "${string[0]}${string[1]}:$substring";

    return timeFormatted;
  }

  convertMinutesToSeconds(String time) {
    int minutes = 0;
    int seconds = 0;
    if (time.length == 4) {
      minutes = int.parse(time.substring(0, 1));
      seconds = int.parse(time.substring(2));
    } else if (time.length == 5) {
      minutes = int.parse(time.substring(0, 2));
      seconds = int.parse(time.substring(3));
    }
    Duration duration = Duration(minutes: minutes, seconds: seconds);
    return duration.inSeconds;
  }

  // Convert from seconds to mm:ss
  String changeDurationFromSecondsToMinutes(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  void _onTimerModeChanged(bool value) {
    setState(() {
      if (appCurrentlyInTimerMode) {
        widget.audio.setReleaseMode(ReleaseMode.stop);
        if (!appCurrentlyMuted && switchButtonAudioCurrentlyEnabled) {
          widget.audio.play(AssetSource(audioForSwitchButtonEnabled));
      }
        // Call Settings.dart Setter
        setBooleanSetting('appInTimerMode', false);
        appCurrentlyInTimerMode = false;
      } else {
        widget.audio.setReleaseMode(ReleaseMode.stop);
        if (!appCurrentlyMuted && switchButtonAudioCurrentlyEnabled) {
          widget.audio.play(AssetSource(audioForSwitchButtonDisabled));
        }
        // Call Settings.dart Setter
        setBooleanSetting('appInTimerMode', true);
        appCurrentlyInTimerMode = true;
      }
    });
  }

  void _setTimerMode(String value) {
    setState(() {
      if (appCurrentlyInTimerMode && value == 'Interval') {
        widget.audio.setReleaseMode(ReleaseMode.stop);
        if (!appCurrentlyMuted && switchButtonAudioCurrentlyEnabled) {
          widget.audio.play(AssetSource(audioForSwitchButtonEnabled));
        }

        // Call Settings.dart Setter
        setBooleanSetting('appInTimerMode', false);
        appCurrentlyInTimerMode = false;
      } else if (!appCurrentlyInTimerMode && value == 'Timer') {
        widget.audio.setReleaseMode(ReleaseMode.stop);
        if (!appCurrentlyMuted && switchButtonAudioCurrentlyEnabled) {
          widget.audio.play(AssetSource(audioForSwitchButtonDisabled));
        }
        // Call Settings.dart Setter
        setBooleanSetting('appInTimerMode', true);
        appCurrentlyInTimerMode = true;
      }
    });
  }

  void _onMuteModeChanged () {
    setState(() {
      if (appCurrentlyMuted) {
        // Call settings.dart Setter
        setBooleanSetting('appMuted', false);
        appCurrentlyMuted = false;
      } else {
        // Call settings.dart Setter
        setBooleanSetting('appMuted', true);
        appCurrentlyMuted = true;
        widget.audio.stop();
      }
    });
  }

  void _onDarkModeChanged() {
    setState(() {
      if (appCurrentlyInDarkMode) {
        // Call settings.dart Setter:
        setBooleanSetting('appInDarkMode', false);
        setupDarkOrLightMode(false);

      } else {
        // Call settings.dart Setter:
        setBooleanSetting('appInDarkMode', true);
        setupDarkOrLightMode(true);
      }
    });
  }

  // TextFormField Variables
  String _desiredRestTimeDuration = '';
  String _desiredWorkTimeDuration = '';
  String _desiredSubTimeMod = '';
  String _desiredAddTimeMod = '';
  bool _changesRequiringRestartOccured = false;

  final restTextEditController = TextEditingController();
  final workTextEditController = TextEditingController();
  final subTimetextEditController = TextEditingController();
  final addTimeTextEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: secondaryColor,
        statusBarIconBrightness: appCurrentlyInDarkMode ? Brightness.light : Brightness.dark
    ));
    return Scaffold(
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Align(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 35),
                      ////////////////////////////////
                      // Settings Header           ///
                      ////////////////////////////////
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 10),

                            //////////////////////////
                            // Settings Header Text
                            //////////////////////////
                            Container(
                              height: 60,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Settings',
                                    style: TextStyle(
                                        color: primaryAccentColor,
                                        fontFamily: 'AstroSpace',
                                        fontSize: 35,
                                        height: 1.1),
                                    textAlign: TextAlign.center),
                              )
                            ),

                            const Spacer(flex: 4),


                            ////////////////////////////////
                            // Advanced Settings Button
                            ////////////////////////////////
                            IconButton(
                              iconSize: 45,
                              color: primaryColor,
                              icon: const Icon(Icons.rule),
                              onPressed: () {
                                HapticFeedback.mediumImpact();

                                // Launch settings menu
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: MaterialLocalizations.of(context)
                                      .modalBarrierDismissLabel,
                                  barrierColor: Colors.black45,
                                  transitionDuration: const Duration(milliseconds: 200),

                                  // ANY Widget can be passed here
                                  pageBuilder: (BuildContext buildContext,
                                      Animation animation,
                                      Animation secondaryAnimation) {
                                    return Center(
                                      child: AdvancedSettingsMenu(
                                        key: widget.advancedSettingsKey
                                      ),
                                    );
                                  },
                                ).then((restartRequired) {
                                  setState(() {
                                    if (restartRequired == true) {
                                      _changesRequiringRestartOccured = true;
                                      Navigator.pop(context, _changesRequiringRestartOccured);
                                    }
                                  });
                                });
                              },
                            ),

                            const Spacer(flex: 1),
                        ]
            ),

                      const SizedBox(height: 20),

                      ///////////////////////////
                      // Rest and Work Settings
                      ///////////////////////////
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ////////////////////////
                            // Rest Input field  ///
                            ////////////////////////
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 115,
                                  child: (TextFormField(
                                    focusNode: _restTimeFocusNode,
                                    controller: restTextEditController,
                                    style: TextStyle(
                                        color: primaryAccentColor,
                                        fontSize: 30),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      setState(() {
                                        _restTimeHintTextShowing = false;
                                      });
                                    },
                                    onChanged: (value) {
                                      if (value != '') {
                                        recordSettingsChanged('rest');
                                        if (value.length > 2) {
                                          // Prevent user from pushing 0 into minute section
                                          if (value[0] == '0') {
                                            value = value.substring(1,3);
                                          }

                                          restTextEditController.text = formatDuration(value);
                                          restTextEditController.selection =
                                              TextSelection.collapsed(
                                                  offset: restTextEditController
                                                      .text.length);
                                        }
                                      }
                                      if (value == '') {
                                        // Useful if the text field was added to and deleted
                                        clearSettingsChanged('rest');
                                      }
                                      _desiredRestTimeDuration = value;
                                    },
                                    onFieldSubmitted: (value) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    decoration: InputDecoration(
                                      hintText: _restTimeHintTextShowing
                                        ? _restTime > 59
                                          ? changeDurationFromSecondsToMinutes(_restTime)
                                          : _restTime.toString()
                                        : '', // Hide Hint Text when selected
                                      hintStyle: TextStyle(
                                        fontSize: 30,
                                        color: appCurrentlyInTimerMode
                                            ? Colors.grey
                                            : primaryColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                          color: _restSettingChanged
                                              ? primaryAccentColor
                                              : appCurrentlyInTimerMode
                                              ? Colors.grey
                                              : primaryColor,
                                          width: 3,
                                        ),
                                        gapPadding: 1.0,
                                      ),
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                      // FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                      LengthLimitingTextInputFormatter(4),
                                      // 4 digits at most
                                      // _TextInputFormatter(), // WIP: Formatting in the form of a custom function
                                    ],
                                  )),
                                ),

                                const SizedBox(height: 4),

                                // Rest Text Description
                                Text(
                                  'Rest Time',
                                  style: TextStyle(
                                    color: appCurrentlyInTimerMode
                                        ? Colors.grey
                                        : primaryColor,
                                    fontSize: 15,
                                    fontFamily: 'AstroSpace',
                                  ),
                                ),
                              ],
                            ),

                            ////////////////////////////////
                            // Spacer between Rest and Work
                            ////////////////////////////////
                            const SizedBox(height: 25),

                            ///////////////////////
                            // Work input Field  //
                            ///////////////////////
                            SizedBox(
                              width: 115,
                              child: (TextFormField(
                                focusNode: _workTimeFocusNode,
                                controller: workTextEditController,
                                style: TextStyle(
                                    color: primaryAccentColor, fontSize: 30),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                keyboardType: TextInputType.number,
                                onTap: () {
                                  setState(() {
                                    _workTimeHintTextShowing = false;
                                    });
                                },
                                onChanged: (value) {
                                  if (value != '') {
                                    // Only record changes if not filtered (leading 0)
                                    recordSettingsChanged('work');
                                    if (value.length > 2) {
                                      workTextEditController.text =
                                          formatDuration(value);
                                      workTextEditController.selection =
                                          TextSelection.collapsed(
                                              offset: workTextEditController
                                                  .text.length);
                                    }
                                  }
                                  if (value == '') {
                                    // Useful if the text field was added to and deleted
                                    clearSettingsChanged('work');
                                  }
                                  _desiredWorkTimeDuration = value;
                                },
                                onFieldSubmitted: (value) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                decoration: InputDecoration(
                                  hintText: _workTimeHintTextShowing
                                    ? _workTime > 59
                                        ? changeDurationFromSecondsToMinutes(
                                        _workTime)
                                        : _workTime.toString()
                                    : '',
                                  hintStyle: TextStyle(
                                      fontSize: 30, color: primaryColor),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      color: _workSettingChanged
                                          ? primaryAccentColor
                                          : primaryColor,
                                      width: 3,
                                    ),
                                    gapPadding: 1.0,
                                  ),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  // Only numbers can be entered
                                  FilteringTextInputFormatter.deny(RegExp('^0+')),
                                  // Filter leading 0s
                                  LengthLimitingTextInputFormatter(4),
                                  // 4 digits at most
                                  // _TextInputFormatter(), // WIP: Formatting in the form of a custom function
                                ],
                              )),
                            ),

                            const SizedBox(height: 4),

                            // Work Text Description
                            Text(
                              'Work Time',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 15,
                                fontFamily: 'AstroSpace',
                              ),
                            ),

                          ],
                    ),

                      ////////////////////////////////
                      // Spacer between switch and timer settings
                      ////////////////////////////////
                      const SizedBox(height: 20),

                      //////////////////////////////
                      // Timer and Interval Switch
                      //////////////////////////////
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(flex: 5),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              padding: const EdgeInsets.all(4),
                              elevation: 0,
                            ),
                            child: Column(children: [
                              Text(
                                'Timer',
                                style: TextStyle(
                                  color:
                                  appCurrentlyInTimerMode ? primaryColor : Colors.grey,
                                  fontSize: 17,
                                  fontFamily: 'AstroSpace',
                                ),
                              ),
                              Text(
                                'Mode',
                                style: TextStyle(
                                  color:
                                  appCurrentlyInTimerMode ? primaryColor : Colors.grey,
                                  fontSize: 17,
                                  fontFamily: 'AstroSpace',
                                ),
                              ),
                            ]),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _setTimerMode('Timer');
                            },
                          ),
                          // Timer Mode Text Column


                          Spacer(flex: 1),

                          ////////////////////////////////////
                          // Switch/Toggle Between App Modes
                          ////////////////////////////////////
                          Switch(
                            value: !appCurrentlyInTimerMode,
                            onChanged: _onTimerModeChanged,
                          ),

                          Spacer(flex: 1),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              padding: const EdgeInsets.all(4),
                              elevation: 0,
                            ),
                            child: Column(children: [
                              // Interval Mode Text Column
                              Column(
                                children: [
                                  Text(
                                    'Interval',
                                    style: TextStyle(
                                      color: appCurrentlyInTimerMode
                                          ? Colors.grey
                                          : primaryAccentColor,
                                      fontSize: 17,
                                      fontFamily: 'AstroSpace',
                                    ),
                                  ),
                                  Text(
                                    'Mode',
                                    style: TextStyle(
                                      color: appCurrentlyInTimerMode
                                          ? Colors.grey
                                          : primaryAccentColor,
                                      fontSize: 17,
                                      fontFamily: 'AstroSpace',
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _setTimerMode('Interval');
                            },
                          ),



                          Spacer(flex: 3),
                        ],
                      ),

                      SizedBox(height: 10),

                      /////////////////
                      // Volume Slider
                      /////////////////
                      Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                              // overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                              thumbColor: appCurrentlyMuted
                                  ? Colors.grey
                                  : primaryAccentColor,
                              // overlayColor: primaryAccentColor,
                              activeTrackColor: appCurrentlyMuted
                                  ? secondaryAccentColor
                                  : primaryAccentColor,
                              inactiveTrackColor: appCurrentlyMuted
                                  ? Colors.grey
                                  : secondaryAccentColor,
                            ),
                            child: FractionallySizedBox(
                              widthFactor: .9,
                                child: Slider(
                                  value: _appVolume,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _appVolume = newValue;
                                      widget.audio.setVolume(_appVolume);
                                      appCurrentVolume = newValue;

                                      // Save the Stored Volume for next Startup
                                      // Method lives in settings.dart
                                      setDoubleSetting('appVolume', _appVolume);
                                    });
                                  },
                                )
                            ),
                          ),
                          Text(
                            'Volume',
                            style: TextStyle(
                              color: appCurrentlyMuted
                                ? Colors.grey
                                : primaryColor,
                              fontSize: 15,
                              fontFamily: 'AstroSpace',
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      ////////////////////
                      // Bottom Settings
                      ///////////////////
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(flex: 1),
                            /////////////////////////////////////
                            // - Time Settings and Theme Button
                            /////////////////////////////////////
                            Column(
                                children: [
                                  ///////////////////////
                                  // - Time Input Field
                                  ///////////////////////
                                  SizedBox(
                                    width: 100,
                                    child: (TextFormField(
                                      focusNode: _subTimeFocusNode,
                                      controller: subTimetextEditController,
                                      style: TextStyle(
                                          color: primaryAccentColor,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      keyboardType: TextInputType.number,
                                      onTap: () {
                                        setState(() {
                                          _subTimeHintTextShowing = false;
                                        });
                                      },
                                      onChanged: (value) {
                                        if (value != '') {
                                          // Only record changes if not filtered (leading 0)
                                          recordSettingsChanged('subTime');
                                          if (value.length > 2) {
                                            subTimetextEditController.text =
                                                formatDuration(value);
                                            subTimetextEditController
                                                    .selection =
                                                TextSelection.collapsed(
                                                    offset:
                                                        subTimetextEditController
                                                            .text.length);
                                          }
                                        }
                                        if (value == '') {
                                          // Useful if the text field was added to and deleted
                                          clearSettingsChanged('subTime');
                                        }
                                        _desiredSubTimeMod = value;
                                      },
                                      onFieldSubmitted: (value) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      decoration: InputDecoration(
                                        hintText: _subTimeHintTextShowing
                                          ? _timeModSub > 59
                                              ? changeDurationFromSecondsToMinutes(
                                              _timeModSub)
                                              : _timeModSub.toString()
                                          : '',
                                        hintStyle: TextStyle(
                                            fontSize: 20, color: primaryColor),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                            color: _subTimeSettingChanged
                                                ? primaryAccentColor
                                                : primaryColor,
                                            width: 3,
                                          ),
                                          gapPadding: 1.0,
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        // Only numbers can be entered
                                        FilteringTextInputFormatter.deny(
                                            RegExp('^0+')),
                                        // Filter leading 0s
                                        LengthLimitingTextInputFormatter(4),
                                        // 4 digits at most
                                        // _TextInputFormatter(), // WIP: Formatting in the form of a custom function
                                      ],
                                    )),
                                  ),
                                  const SizedBox(height: 4),
                                  // - Time Text Description
                                  Text(
                                    '-Time',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),

                                  SizedBox(height: 40),

                                  ////////////////////////////////
                                  // Dark Mode/Light Mode Button
                                  ////////////////////////////////
                                  IconButton(
                                    iconSize: 45,
                                    color: primaryColor,
                                    icon: appCurrentlyInDarkMode
                                      ? const Icon(Icons.dark_mode)
                                      : const Icon(Icons.light_mode),
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      _onDarkModeChanged();
                                    },
                                  ),

                                  // Dark Mode/Light Mode Text Description
                                  Text(
                                    appCurrentlyInDarkMode
                                      ? 'Dark'
                                      : 'Light',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Mode',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ]),

                            Spacer(flex: 1),

                            //////////////////////////////
                            // Save and close buttons
                            //////////////////////////////
                            Column(
                                children: [
                                  ////////////////
                                  // Save Button
                                  ////////////////
                                  IconButton(
                                    iconSize: 75,
                                    color: primaryAccentColor,
                                    disabledColor: Colors.grey,
                                    icon: const Icon(Icons.check_circle),
                                    onPressed: _settingsChanged
                                        ? () {
                                      // widget.audio.setVolume(_appVolume);
                                      widget.audio.setReleaseMode(ReleaseMode.stop);
                                      if (!appCurrentlyMuted && saveButtonAudioCurrentlyEnabled) {
                                        widget.audio.play(AssetSource(audioForSaveButton));
                                        widget.audio.setReleaseMode(ReleaseMode.stop);
                                      }
                                      // Check if settings have changed
                                      HapticFeedback.mediumImpact();

                                      ///////////////////////////////////////////////////
                                      // Check if changes were made to any Time settings
                                      ///////////////////////////////////////////////////
                                      // Check for Changes to Rest Time
                                      if (_desiredRestTimeDuration != '') {
                                        _changesRequiringRestartOccured = true;
                                        _restTime = int.parse(_desiredRestTimeDuration);
                                        // Prevent errors from numbers above 59:59
                                        if (_restTime > 5959) {
                                          _restTime = 5959;
                                        }
                                        if (_desiredRestTimeDuration.length > 2) {
                                          var timeFormatted = formatDuration(
                                              _restTime.toString());
                                          var timeInSeconds =
                                              convertMinutesToSeconds(
                                                  timeFormatted);
                                          _restTime = timeInSeconds;
                                        }
                                        // Save the Stored Time for next Startup
                                        // Method lives in settings.dart
                                        setIntSetting('restDuration', _restTime);
                                      }

                                      // Check for Changes to Work Time
                                      if (_desiredWorkTimeDuration != '') {
                                        _changesRequiringRestartOccured =
                                            true;
                                        // Prevent errors from negative numbers
                                        _workTime = int.parse(_desiredWorkTimeDuration); // works if <2
                                        if (_workTime < 1) {
                                          _workTime = 1;
                                        }
                                        // Prevent errors from numbers above 59:59
                                        if (_workTime > 5959) {
                                          _workTime = 5959;
                                        }
                                        if (_desiredWorkTimeDuration.length > 2) {
                                          var timeFormatted = formatDuration(_workTime.toString());
                                          var timeInSeconds = convertMinutesToSeconds(
                                                  timeFormatted);
                                          _workTime = timeInSeconds;
                                        }
                                        // Save the Stored Time for next Startup
                                        // Method lives in settings.dart
                                        setIntSetting('workDuration', _workTime);
                                      }

                                      // Check for Changes to Subtract Modifier
                                      if (_desiredSubTimeMod != '') {
                                        _timeModSub =
                                            int.parse(_desiredSubTimeMod);
                                        if (_timeModSub > 5959) {
                                          _timeModSub = 5959;
                                        }
                                        if (_desiredSubTimeMod.length > 2) {
                                          var timeFormatted = formatDuration(
                                              _timeModSub
                                                  .toString());
                                          var timeInSeconds =
                                              convertMinutesToSeconds(
                                                  timeFormatted);
                                          _timeModSub =
                                              timeInSeconds;
                                        }
                                        // Save the Stored Time for next Startup
                                        // Method lives in settings.dart
                                        setIntSetting('timeModifyValueSub', _timeModSub);
                                      }

                                      // Check for Changes to Addition Modifier
                                      if (_desiredAddTimeMod != '') {
                                        _timeModAdd =
                                            int.parse(_desiredAddTimeMod);
                                        if (_timeModAdd > 5959) {
                                          _timeModAdd = 5959;
                                        }
                                        if (_desiredAddTimeMod.length > 2) {
                                          var timeFormatted = formatDuration(
                                              _timeModAdd
                                                  .toString());
                                          var timeInSeconds =
                                              convertMinutesToSeconds(
                                                  timeFormatted);
                                          _timeModAdd =
                                              timeInSeconds;
                                        }
                                        // Save the Stored Time for next Startup
                                        // Method lives in settings.dart
                                        setIntSetting('timeModifyValueAdd', _timeModAdd);
                                      }

                                      Navigator.pop(context,
                                          _changesRequiringRestartOccured); // Close Settings menu
                                    }
                                  : null, // If settings haven't changed, Disable Save Button
                                  ),

                                  // Save Text Description
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: _settingsChanged
                                          ? primaryAccentColor
                                          : Colors.grey,
                                      fontSize: 17,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Cancel Button
                                  IconButton(
                                    iconSize: 45,
                                    color: _settingsChanged
                                        ? Colors.red.shade400
                                        : primaryColor,
                                    icon: const Icon(Icons.highlight_off),
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      if (_settingsChanged) {
                                        // widget.audio.setVolume(_appVolume);
                                        if (!appCurrentlyMuted && cancelButtonAudioCurrentlyEnabled) {
                                          widget.audio.play(AssetSource(audioForCancelButton));
                                          widget.audio.setReleaseMode(ReleaseMode.stop);
                                        }
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),

                                  // Close/Cancel Text Description
                                  Text(
                                _settingsChanged ? 'Cancel' : 'Close',
                                style: TextStyle(
                                  fontFamily: 'AstroSpace',
                                  color: _settingsChanged
                                      ? Colors.red.shade400
                                      : primaryColor,
                                  fontSize: 15,
                                ),
                              ),

                                  SizedBox(height: 10)
                            ]),

                            // SizedBox(width: 25),
                            Spacer(flex: 1),


                            //////////////////////
                            // + time settings and Audio Settings
                            /////////////////////
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ///////////////////////
                                  // + Time Input Field
                                  ///////////////////////
                                  SizedBox(
                                    width: 100,
                                    child: (TextFormField(
                                      focusNode: _addTimeFocusNode,
                                      controller: addTimeTextEditController,
                                      style: TextStyle(
                                          color: primaryAccentColor,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      keyboardType: TextInputType.number,
                                      onTap: () {
                                        setState(() {
                                          _addTimeHintTextShowing = false;
                                        });
                                      },
                                      onChanged: (value) {
                                        if (value != '') {
                                          // Only record changes if not filtered (leading 0)
                                          recordSettingsChanged('addTime');
                                          if (value.length > 2) {
                                            addTimeTextEditController.text =
                                                formatDuration(value);
                                            addTimeTextEditController.selection =
                                                TextSelection.collapsed(
                                                    offset:
                                                        addTimeTextEditController
                                                            .text.length);
                                          }
                                        }
                                        if (value == '') {
                                          // Useful if the text field was added to and deleted
                                          clearSettingsChanged('addTime');
                                        }
                                        _desiredAddTimeMod = value;
                                      },
                                      onFieldSubmitted: (value) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      decoration: InputDecoration(
                                        hintText: _addTimeHintTextShowing
                                          ? _timeModAdd > 59
                                              ? changeDurationFromSecondsToMinutes(
                                              _timeModAdd)
                                              : _timeModAdd.toString()
                                          : '',
                                        hintStyle: TextStyle(
                                            fontSize: 20, color: primaryColor),
                                        iconColor: primaryColor,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                            color: _addTimeSettingChanged
                                                ? primaryAccentColor
                                                : primaryColor,
                                            width: 3,
                                          ),
                                          gapPadding: 1.0,
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                        FilteringTextInputFormatter.deny(
                                            RegExp('^0+')),  // Filter leading 0s
                                        LengthLimitingTextInputFormatter(4), // 4 digits at most
                                        // _TextInputFormatter(), // WIP: Formatting in the form of a custom function
                                      ],
                                    )),
                                  ),

                                  const SizedBox(height: 4),

                                  // + Time Text Description
                                  Text(
                                    '+Time',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),

                                  SizedBox(height: 40),


                                  ////////////////////////////////
                                  // Sound Mute Button
                                  ////////////////////////////////
                                  IconButton(
                                    iconSize: 45,
                                    color: appCurrentlyMuted
                                    ? Colors.grey
                                    : primaryColor,
                                    icon: appCurrentlyMuted
                                      ? const Icon(Icons.volume_off)
                                      : const Icon(Icons.volume_up),
                                    onPressed: () {
                                      _onMuteModeChanged();
                                      HapticFeedback.mediumImpact();
                                    },
                                  ),

                                  // Sound Settings Text Description
                                  Text(
                                    'Sound',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: appCurrentlyMuted
                                          ? Colors.grey
                                          : primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(appCurrentlyMuted
                                    ? 'Off'
                                    : 'On',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: appCurrentlyMuted
                                          ? Colors.grey
                                          : primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),

                              // SizedBox(height: 100),
                            ]),

                            Spacer(flex: 1),
                          ]),

                      const SizedBox(height: 25),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
