import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'advanced_settings_menu.dart';
import 'Config/settings.dart';

void main() {
  runApp(MaterialApp(
      home: SettingsMenu(
    key: UniqueKey(),
  )));
}

// class _TextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     // Code here
//
//     return newValue;
//   }
// }


class SettingsMenu extends StatefulWidget {
  final audio;

  SettingsMenu({
    required Key key,
    this.audio,
  }) : super(key: key);

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  final _formKey = GlobalKey<FormState>();
  bool _settingsChanged = false;
  bool _restSettingChanged = false;
  bool _workSettingChanged = false;
  bool _subTimeSettingChanged = false;
  bool _addTimeSettingChanged = false;

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
      if (appInTimerMode) {
        widget.audio.setVolume(setVolume);
        widget.audio.setReleaseMode(ReleaseMode.stop);
        if (!appMuted && switchButtonAudioEnabled) {
          widget.audio.play(AssetSource('sounds/SwitchAndBeep1.mp3'));
      }
        appInTimerMode = false;
      } else {
        widget.audio.setVolume(setVolume);
        widget.audio.setReleaseMode(ReleaseMode.stop);
        if (!appMuted && switchButtonAudioEnabled) {
          widget.audio.play(AssetSource('sounds/Switch1.mp3'));
        }
        appInTimerMode = true;
      }
    });
  }

  void _onMuteModeChanged () {
    setState(() {
      if (appMuted) {
        appMuted = false;
      } else {
        appMuted = true;
        widget.audio.stop();
      }
    });
  }

  void _onDarkModeChanged() {
    setState(() {
      if (appInDarkMode) {
        appInDarkMode = false;
        primaryColor = Colors.black;
        secondaryColor = Colors.white;
        primaryAccentColor = Colors.blue.shade400;
        secondaryAccentColor = Colors.blueGrey;
      } else {
        appInDarkMode = true;
        primaryColor = Colors.white;
        secondaryColor = Colors.grey.shade900;
        primaryAccentColor = Colors.blue.shade400;
        secondaryAccentColor = Colors.blueGrey;
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

  Widget build(BuildContext context) {
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
                      // Settings Text Header      ///
                      ////////////////////////////////
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
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
                                        key: UniqueKey(),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                            const Spacer(flex: 1),
                            Container(
                              height: 60,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Settings',
                                    style: TextStyle(
                                        color: primaryAccentColor,
                                        fontFamily: 'AstroSpace',
                                        fontSize: 40,
                                        height: 1.1),
                                    textAlign: TextAlign.center),
                              )
                            ),
                            const SizedBox(width: 70),
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
                                    controller: restTextEditController,
                                    style: TextStyle(
                                        color: primaryAccentColor,
                                        fontSize: 30),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value != '') {
                                        // Only record changes if not filtered (leading 0)
                                        recordSettingsChanged('rest');
                                        if (value.length > 2) {
                                          restTextEditController.text =
                                              formatDuration(value);
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
                                      hintText: setRestDuration > 59
                                          ? changeDurationFromSecondsToMinutes(
                                          setRestDuration)
                                          : setRestDuration.toString(),
                                      hintStyle: TextStyle(
                                        fontSize: 30,
                                        color: appInTimerMode
                                            ? Colors.grey
                                            : primaryColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                          color: _restSettingChanged
                                              ? primaryAccentColor
                                              : appInTimerMode
                                              ? Colors.grey
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

                                // Rest Text Description
                                Text(
                                  'Rest Time',
                                  style: TextStyle(
                                    color: appInTimerMode
                                        ? Colors.grey
                                        : primaryColor,
                                    fontSize: 18,
                                    fontFamily: 'AstroSpace',
                                  ),
                                ),
                              ],
                            ),

                            ////////////////////////////////
                            // Spacer between Rest and Work
                            ////////////////////////////////
                            const SizedBox(height: 40),

                            ///////////////////////
                            // Work input Field  //
                            ///////////////////////
                            SizedBox(
                              width: 115,
                              child: (TextFormField(
                                controller: workTextEditController,
                                style: TextStyle(
                                    color: primaryAccentColor, fontSize: 30),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                keyboardType: TextInputType.number,
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
                                  hintText: setStartTime > 59
                                      ? changeDurationFromSecondsToMinutes(
                                      setStartTime)
                                      : setStartTime.toString(),
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
                                fontSize: 18,
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
                          Text(
                            'Timer Mode',
                            style: TextStyle(
                              color:
                                  appInTimerMode ? primaryColor : Colors.grey,
                              fontSize: 18,
                              fontFamily: 'AstroSpace',
                            ),
                          ),
                          ////////////////////////////////////
                          // Switch/Toggle Between App Modes
                          ////////////////////////////////////
                          Switch(
                            value: !appInTimerMode,
                            onChanged: _onTimerModeChanged,
                          ),
                          Text(
                            'Interval Mode',
                            style: TextStyle(
                              color: appInTimerMode
                                  ? Colors.grey
                                  : primaryAccentColor,
                              fontSize: 18,
                              fontFamily: 'AstroSpace',
                            ),
                          ),
                        ],
                      ),

                      /////////////////
                      // Volume Slider
                      /////////////////
                      appMuted
                          ? const SizedBox(height: 68)
                          : Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                  // overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                                  thumbColor: primaryAccentColor,
                                  // overlayColor: primaryAccentColor,
                                  activeTrackColor: primaryAccentColor,
                                  inactiveTrackColor: secondaryAccentColor,
                                ),
                                child: FractionallySizedBox(
                                  widthFactor: .9,
                                    child: Slider(
                                      value: setVolume,
                                      onChanged: (newValue) {
                                        setState(() {
                                          setVolume = newValue;
                                          widget.audio.setVolume(setVolume);
                                        });
                                      },
                                    )
                                ),
                              ),
                              Text(
                                'Volume',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontFamily: 'AstroSpace',
                                ),
                              ),
                            ],
                          ),

                      ////////////////////
                      // Bottom Settings
                      ///////////////////
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                      controller: subTimetextEditController,
                                      style: TextStyle(
                                          color: primaryAccentColor,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      keyboardType: TextInputType.number,
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
                                        hintText: setTimeModifyValueSub > 59
                                            ? changeDurationFromSecondsToMinutes(
                                                setTimeModifyValueSub)
                                            : setTimeModifyValueSub.toString(),
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
                                      fontSize: 18,
                                    ),
                                  ),

                                  SizedBox(height: 40),

                                  ////////////////////////////////
                                  // Dark Mode/Light Mode Button
                                  ////////////////////////////////
                                  IconButton(
                                    iconSize: 45,
                                    color: primaryColor,
                                    icon: appInDarkMode
                                      ? Icon(Icons.dark_mode)
                                      : Icon(Icons.light_mode),
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      _onDarkModeChanged();
                                    },
                                  ),

                                  // Dark Mode/Light Mode Text Description
                                  Text(
                                    appInDarkMode
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

                            SizedBox(width: 25),

                            //////////////////////////////
                            // save and close buttons
                            //////////////////////////////
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
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
                                      widget.audio.setVolume(setVolume);
                                      widget.audio.setReleaseMode(ReleaseMode.stop);
                                      if (!appMuted && saveButtonAudioEnabled) {
                                        widget.audio.play(AssetSource('sounds/Correct1.mp3'));
                                        widget.audio.setReleaseMode(ReleaseMode.stop);
                                      }
                                      // Check if settings have changed
                                            HapticFeedback.mediumImpact();

                                            ///////////////////////////////////////////////////
                                            // Check if changes were made to any Time settings
                                            ///////////////////////////////////////////////////
                                            // Check for Changes to Rest Time
                                            if (_desiredRestTimeDuration != '') {
                                              _changesRequiringRestartOccured =
                                                  true;
                                              setRestDuration = int.parse(
                                                  _desiredRestTimeDuration);
                                              // Prevent errors from numbers above 59:59
                                              if (setRestDuration > 5959) {
                                                setRestDuration = 5959;
                                              }
                                              if (_desiredRestTimeDuration.length >
                                                  2) {
                                                var timeFormatted = formatDuration(
                                                    setRestDuration.toString());
                                                var timeInSeconds =
                                                    convertMinutesToSeconds(
                                                        timeFormatted);
                                                setRestDuration = timeInSeconds;
                                              }
                                            }

                                            // Check for Changes to Work Time
                                            if (_desiredWorkTimeDuration != '') {
                                              _changesRequiringRestartOccured =
                                                  true;
                                              // Prevent errors from negative numbers
                                              setStartTime = int.parse(
                                                  _desiredWorkTimeDuration); // works if <2
                                              if (setStartTime < 1) {
                                                setStartTime = 1;
                                              }
                                              // Prevent errors from numbers above 59:59
                                              if (setStartTime > 5959) {
                                                setStartTime = 5959;
                                              }
                                              if (_desiredWorkTimeDuration.length >
                                                  2) {
                                                var timeFormatted = formatDuration(
                                                    setStartTime.toString());
                                                var timeInSeconds =
                                                    convertMinutesToSeconds(
                                                        timeFormatted);
                                                setStartTime = timeInSeconds;
                                              }
                                            }

                                            // Check for Changes to Subtract Modifier
                                            if (_desiredSubTimeMod != '') {
                                              setTimeModifyValueSub =
                                                  int.parse(_desiredSubTimeMod);
                                              if (setTimeModifyValueSub > 5959) {
                                                setTimeModifyValueSub = 5959;
                                              }
                                              if (_desiredSubTimeMod.length > 2) {
                                                var timeFormatted = formatDuration(
                                                    setTimeModifyValueSub
                                                        .toString());
                                                var timeInSeconds =
                                                    convertMinutesToSeconds(
                                                        timeFormatted);
                                                setTimeModifyValueSub =
                                                    timeInSeconds;
                                              }
                                            }

                                            // Check for Changes to Addition Modifier
                                            if (_desiredAddTimeMod != '') {
                                              setTimeModifyValueAdd =
                                                  int.parse(_desiredAddTimeMod);
                                              if (setTimeModifyValueAdd > 5959) {
                                                setTimeModifyValueAdd = 5959;
                                              }
                                              if (_desiredAddTimeMod.length > 2) {
                                                var timeFormatted = formatDuration(
                                                    setTimeModifyValueAdd
                                                        .toString());
                                                var timeInSeconds =
                                                    convertMinutesToSeconds(
                                                        timeFormatted);
                                                setTimeModifyValueAdd =
                                                    timeInSeconds;
                                              }
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
                                      fontSize: 20,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

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
                                        // widget.audio.setVolume(setVolume);
                                        if (!appMuted && cancelButtonAudioEnabled) {
                                          widget.audio.play(AssetSource('sounds/Woosh-spaced.mp3'));
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
                                  fontSize: 20,
                                ),
                              ),
                            ]),

                            SizedBox(width: 25),

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
                                      controller: addTimeTextEditController,
                                      style: TextStyle(
                                          color: primaryAccentColor,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      keyboardType: TextInputType.number,
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
                                        hintText: setTimeModifyValueAdd > 59
                                            ? changeDurationFromSecondsToMinutes(
                                                setTimeModifyValueAdd)
                                            : setTimeModifyValueAdd.toString(),
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

                                  // + Time Text Description
                                  Text(
                                    '+Time',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: primaryColor,
                                      fontSize: 18,
                                    ),
                                  ),

                                  SizedBox(height: 40),


                                  ////////////////////////////////
                                  // Sound Mute Button
                                  ////////////////////////////////
                                  IconButton(
                                    iconSize: 45,
                                    color: appMuted
                                    ? Colors.grey
                                    : primaryColor,
                                    icon: appMuted
                                      ? Icon(Icons.volume_off)
                                      : Icon(Icons.volume_up),
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
                                      color: appMuted
                                          ? Colors.grey
                                          : primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(appMuted
                                    ? 'Off'
                                    : 'On',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: appMuted
                                          ? Colors.grey
                                          : primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),

                              // SizedBox(height: 100),
                            ]),
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
