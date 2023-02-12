import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'advanced_settings_menu.dart';
import 'Config/settings.dart';

// class _TextInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     // Code here
//
//     return newValue;
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      FutureBuilder(
        future:getDuration(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
                home: SettingsMenu(workTime: snapshot.data)
            );
          } else {
            return Container();
          }
        }
      )
  );
}

class SettingsMenu extends StatefulWidget {
  final audio;
  final int? workTime;

  const SettingsMenu({
    Key? key,
    this.audio,
    this.workTime,
  }) : super(key: key);

  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  final _formKey = GlobalKey<FormState>();
  late int _workTime;
  bool _settingsChanged = false;
  bool _restSettingChanged = false;
  bool _workSettingChanged = false;
  bool _subTimeSettingChanged = false;
  bool _addTimeSettingChanged = false;

  @override
  void initState() {
    super.initState();
    _workTime = widget.workTime ?? defaultWorkDuration;
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
      if (appInTimerModeDefault) {
        widget.audio.setVolume(defaultVolume);
        widget.audio.setReleaseMode(ReleaseMode.stop);
        if (!appMutedDefault && switchButtonAudioEnabled) {
          widget.audio.play(AssetSource('sounds/SwitchAndBeep1.mp3'));
      }
        appInTimerModeDefault = false;
      } else {
        widget.audio.setVolume(defaultVolume);
        widget.audio.setReleaseMode(ReleaseMode.stop);
        if (!appMutedDefault && switchButtonAudioEnabled) {
          widget.audio.play(AssetSource('sounds/Switch1.mp3'));
        }
        appInTimerModeDefault = true;
      }
    });
  }

  void _onMuteModeChanged () {
    setState(() {
      if (appMutedDefault) {
        appMutedDefault = false;
      } else {
        appMutedDefault = true;
        widget.audio.stop();
      }
    });
  }

  void _onDarkModeChanged() {
    setState(() {
      if (appInDarkModeDefault) {
        appInDarkModeDefault = false;
        primaryColor = Colors.black;
        secondaryColor = Colors.white;
        primaryAccentColor = Colors.blue.shade400;
        secondaryAccentColor = Colors.blueGrey;
      } else {
        appInDarkModeDefault = true;
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
                      // Settings Header           ///
                      ////////////////////////////////
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 70),
                            const Spacer(flex: 1),

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
                                        fontSize: 40,
                                        height: 1.1),
                                    textAlign: TextAlign.center),
                              )
                            ),

                            const SizedBox(width: 10),

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
                                        print("Inside Value Guy\n");
                                        print(value);
                                        recordSettingsChanged('rest');
                                        if (value.length > 2) {
                                          // Prevent user from pushing 0 into minute section
                                          if (value[0] == '0') {
                                            value = value.substring(1,3);
                                            print("new Value\n");
                                            print(value);
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
                                      hintText: defaultRestDuration > 59
                                          ? changeDurationFromSecondsToMinutes(
                                          defaultRestDuration)
                                          : defaultRestDuration.toString(),
                                      hintStyle: TextStyle(
                                        fontSize: 30,
                                        color: appInTimerModeDefault
                                            ? Colors.grey
                                            : primaryColor,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                          color: _restSettingChanged
                                              ? primaryAccentColor
                                              : appInTimerModeDefault
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
                                    color: appInTimerModeDefault
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
                                  hintText: _workTime > 59
                                      ? changeDurationFromSecondsToMinutes(
                                      _workTime)
                                      : _workTime.toString(),
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
                              appInTimerModeDefault ? primaryColor : Colors.grey,
                              fontSize: 18,
                              fontFamily: 'AstroSpace',
                            ),
                          ),
                          ////////////////////////////////////
                          // Switch/Toggle Between App Modes
                          ////////////////////////////////////
                          Switch(
                            value: !appInTimerModeDefault,
                            onChanged: _onTimerModeChanged,
                          ),
                          Text(
                            'Interval Mode',
                            style: TextStyle(
                              color: appInTimerModeDefault
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
                      appMutedDefault
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
                                      value: defaultVolume,
                                      onChanged: (newValue) {
                                        setState(() {
                                          defaultVolume = newValue;
                                          widget.audio.setVolume(defaultVolume);
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
                                        hintText: defaultTimeModifyValueSub > 59
                                            ? changeDurationFromSecondsToMinutes(
                                            defaultTimeModifyValueSub)
                                            : defaultTimeModifyValueSub.toString(),
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
                                    icon: appInDarkModeDefault
                                      ? Icon(Icons.dark_mode)
                                      : Icon(Icons.light_mode),
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      _onDarkModeChanged();
                                    },
                                  ),

                                  // Dark Mode/Light Mode Text Description
                                  Text(
                                    appInDarkModeDefault
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
                                      widget.audio.setVolume(defaultVolume);
                                      widget.audio.setReleaseMode(ReleaseMode.stop);
                                      if (!appMutedDefault && saveButtonAudioEnabled) {
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
                                        _changesRequiringRestartOccured = true;
                                        defaultRestDuration = int.parse(_desiredRestTimeDuration);
                                        // Prevent errors from numbers above 59:59
                                        if (defaultRestDuration > 5959) {
                                          defaultRestDuration = 5959;
                                        }
                                        if (_desiredRestTimeDuration.length > 2) {
                                          var timeFormatted = formatDuration(
                                              defaultRestDuration.toString());
                                          var timeInSeconds =
                                              convertMinutesToSeconds(
                                                  timeFormatted);
                                          defaultRestDuration = timeInSeconds;
                                        }
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
                                        setDuration(_workTime);
                                      }

                                      // Check for Changes to Subtract Modifier
                                      if (_desiredSubTimeMod != '') {
                                        defaultTimeModifyValueSub =
                                            int.parse(_desiredSubTimeMod);
                                        if (defaultTimeModifyValueSub > 5959) {
                                          defaultTimeModifyValueSub = 5959;
                                        }
                                        if (_desiredSubTimeMod.length > 2) {
                                          var timeFormatted = formatDuration(
                                              defaultTimeModifyValueSub
                                                  .toString());
                                          var timeInSeconds =
                                              convertMinutesToSeconds(
                                                  timeFormatted);
                                          defaultTimeModifyValueSub =
                                              timeInSeconds;
                                        }
                                      }

                                      // Check for Changes to Addition Modifier
                                      if (_desiredAddTimeMod != '') {
                                        defaultTimeModifyValueAdd =
                                            int.parse(_desiredAddTimeMod);
                                        if (defaultTimeModifyValueAdd > 5959) {
                                          defaultTimeModifyValueAdd = 5959;
                                        }
                                        if (_desiredAddTimeMod.length > 2) {
                                          var timeFormatted = formatDuration(
                                              defaultTimeModifyValueAdd
                                                  .toString());
                                          var timeInSeconds =
                                              convertMinutesToSeconds(
                                                  timeFormatted);
                                          defaultTimeModifyValueAdd =
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
                                        widget.audio.setVolume(defaultVolume);
                                        if (!appMutedDefault && cancelButtonAudioEnabled) {
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
                                        hintText: defaultTimeModifyValueAdd > 59
                                            ? changeDurationFromSecondsToMinutes(
                                            defaultTimeModifyValueAdd)
                                            : defaultTimeModifyValueAdd.toString(),
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
                                    color: appMutedDefault
                                    ? Colors.grey
                                    : primaryColor,
                                    icon: appMutedDefault
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
                                      color: appMutedDefault
                                          ? Colors.grey
                                          : primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(appMutedDefault
                                    ? 'Off'
                                    : 'On',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: appMutedDefault
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
