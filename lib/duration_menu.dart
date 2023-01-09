import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Config/settings.dart';

void main() {
  runApp(MaterialApp(
      home: DurationMenu(
    key: UniqueKey(),
  )));
}

class _TextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // print('\n');
    // print('\n');
    // print('oldvalue');
    // print(oldValue);
    // print('\n');
    //
    // print('\n');
    // print('\n');
    // print('newValue');
    // print(newValue);
    // print('\n');

    // if (newValue.text.length == 1) {
    //   return TextEditingValue(
    //     text: '${newValue.text}',
    //     selection: TextSelection.collapsed(offset: 3),
    //   );
    // }
    //
    // if (newValue.text.length == 2) {
    //   return TextEditingValue(
    //     text: '${newValue.text}',
    //     selection: TextSelection.collapsed(offset: 3),
    //   );
    // }
    // if (newValue.text.length == 3) {
    //   return TextEditingValue(
    //     text: '${oldValue}${newValue.text}',
    //     selection: TextSelection.collapsed(offset: 3),
    //   );
    // }
    // if (newValue.text.length == 4) {
    //   return TextEditingValue(
    //     text: '${oldValue}${newValue.text}',
    //     selection: TextSelection.collapsed(offset: 3),
    //   );
    // }

    return newValue;
  }
}

class DurationMenu extends StatefulWidget {
  DurationMenu({
    required Key key,
  }) : super(key: key);

  @override
  _DurationMenuState createState() => _DurationMenuState();
}

class _DurationMenuState extends State<DurationMenu> {
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

  // If a string is longer than 3 chars, we assume were in Minutes
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

  void _onChanged(bool value) {
    setState(() {
      if (appInTimerMode) {
        appInTimerMode = false;
      } else {
        appInTimerMode = true;
      }
    });
  }

  // textformfield variables
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
      backgroundColor: Colors.blueGrey,
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
                      ////////////////////////////////
                      // Settings Text Header      ///
                      ////////////////////////////////
                      // TODO Make clickable to access advanced settings
                      Container(
                          height: 60,
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text('Settings',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'AstroSpace',
                                    fontSize: 40,
                                    height: 1.1),
                                textAlign: TextAlign.center),
                          )),

                      const SizedBox(height: 45),

                      ///////////////////////////
                      // Rest and Work Settings
                      ///////////////////////////
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ////////////////////////
                          // Rest Input field  ///
                          ////////////////////////inp
                          SizedBox(
                            width: 115,
                            child: (TextFormField(
                              controller: restTextEditController,
                              style: TextStyle(color: Colors.blue, fontSize: 30),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value != '') {
                                  // Only record changes if not filtered (leading 0)
                                  recordSettingsChanged('rest');
                                  if (value.length > 2) {
                                    restTextEditController.text = formatDuration(value);
                                    restTextEditController.selection = TextSelection.collapsed(offset: restTextEditController.text.length);
                                  }
                                }
                                if (value == '') {
                                  // Useful if the text field was added to and deleted
                                  clearSettingsChanged('rest');
                                }
                                _desiredRestTimeDuration = value;
                              },
                              onFieldSubmitted: (value) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              decoration: InputDecoration(
                                hintText: setRestDuration > 59
                                    ? changeDurationFromSecondsToMinutes(
                                        setRestDuration)
                                    : setRestDuration.toString(),
                                hintStyle: TextStyle(
                                    fontSize: 30,
                                    color: appInTimerMode ? Colors.grey : Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: _restSettingChanged ? Colors.blue : appInTimerMode ? Colors.grey : Colors.white,
                                    width: 3,
                                  ),
                                  gapPadding: 1.0,
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,  // Only numbers can be entered
                                FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                LengthLimitingTextInputFormatter(4), // 4 digits at most
                                _TextInputFormatter(), // WIP: Formatting in the form of a custom function
                              ],
                            )),
                          ),

                          const SizedBox(height: 4),

                          // Rest Text Description
                          Text(
                            'Rest Time',
                            style: TextStyle(
                              color: appInTimerMode ? Colors.grey : Colors.white,
                              fontSize: 18,
                              fontFamily: 'AstroSpace',
                            ),
                          ),

                          ////////////////////////////////
                          // Spacer between Rest and Work
                          ////////////////////////////////
                          const SizedBox(height: 30),

                          ///////////////////////
                          // Work input Field  //
                          ///////////////////////
                          SizedBox(
                            width: 115,
                            child: (TextFormField(
                              controller: workTextEditController,
                              style: TextStyle(color: Colors.blue, fontSize: 30),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value != '') {
                                  // Only record changes if not filtered (leading 0)
                                  recordSettingsChanged('work');
                                  if (value.length > 2) {
                                    workTextEditController.text = formatDuration(value);
                                    workTextEditController.selection = TextSelection.collapsed(offset: workTextEditController.text.length);
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
                                hintStyle: const TextStyle(
                                    fontSize: 30, color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: _workSettingChanged ? Colors.blue : Colors.white,
                                    width: 3,
                                  ),
                                  gapPadding: 1.0,
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                LengthLimitingTextInputFormatter(4), // 4 digits at most
                                _TextInputFormatter(), // WIP: Formatting in the form of a custom function
                              ],
                            )),
                          ),

                          const SizedBox(height: 4),

                          // Work Text Description
                          const Text(
                            'Work Time',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'AstroSpace',
                            ),
                          ),
                        ],
                      ),

                      ////////////////////////////////
                      // Spacer between switch and timer settings
                      ////////////////////////////////
                      const SizedBox(height: 40),

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
                                  appInTimerMode ? Colors.white : Colors.grey,
                              fontSize: 18,
                              fontFamily: 'AstroSpace',
                            ),
                          ),
                          ////////////////////////////////////
                          // Switch/Toggle Between App Modes
                          ////////////////////////////////////
                          Switch(
                            value: !appInTimerMode,
                            onChanged: _onChanged,
                          ),
                          Text(
                            'Interval Mode',
                            style: TextStyle(
                              color: appInTimerMode ? Colors.grey : Colors.blue,
                              fontSize: 18,
                              fontFamily: 'AstroSpace',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      ////////////////////
                      // Bottom Settings
                      ///////////////////
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ////////////////////
                            // - Time Settings
                            ////////////////////
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // - Time Input Field
                                  SizedBox(
                                    width: 100,
                                    child: (TextFormField(
                                      controller: subTimetextEditController,
                                      style: TextStyle(color: Colors.blue, fontSize: 20),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        if (value != '') {
                                          // Only record changes if not filtered (leading 0)
                                          recordSettingsChanged('subTime');
                                          if (value.length > 2) {
                                            subTimetextEditController.text = formatDuration(value);
                                            subTimetextEditController.selection = TextSelection.collapsed(offset: subTimetextEditController.text.length);
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
                                        hintStyle: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                        fillColor: Colors.blueGrey,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                            color: _subTimeSettingChanged ? Colors.blue : Colors.white,
                                            width: 3,
                                          ),
                                          gapPadding: 1.0,
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                        FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                        LengthLimitingTextInputFormatter(4), // 4 digits at most
                                        _TextInputFormatter(), // WIP: Formatting in the form of a custom function
                                      ],
                                    )),
                                  ),

                                  const SizedBox(height: 4),

                                  // - Time Text Description
                                  const Text(
                                    '-Time',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 100),
                                ]),

                            SizedBox(width: 25),

                            //////////////////////////////
                            // save and close buttons
                            //////////////////////////////
                            Column(children: [
                              // Save Button
                              IconButton(
                                iconSize: 75,
                                color: Colors.blue,
                                icon: const Icon(Icons.check_circle),
                                onPressed: _settingsChanged
                                    ? () {
                                        // Check if settings have changed
                                        HapticFeedback.mediumImpact();

                                        ///////////////////////////////////////////////////
                                        // Check if changes were made to any Time settings
                                        ///////////////////////////////////////////////////
                                        // Check for Changes to Rest Time
                                        if (_desiredRestTimeDuration != '') {
                                          _changesRequiringRestartOccured = true;
                                          setRestDuration = int.parse(_desiredRestTimeDuration);
                                          // Prevent errors from numbers above 59:59
                                          if (setRestDuration > 5959) {
                                            setRestDuration = 5959;
                                          }
                                          if (_desiredRestTimeDuration.length > 2) {
                                            var timeFormatted = formatDuration(setRestDuration.toString());
                                            var timeInSeconds = convertMinutesToSeconds(timeFormatted);
                                            setRestDuration = timeInSeconds;
                                          }
                                        }

                                        // Check for Changes to Work Time
                                        if (_desiredWorkTimeDuration != '') {
                                          _changesRequiringRestartOccured =
                                              true;
                                          // Prevent errors from negative numbers
                                          setStartTime = int.parse(_desiredWorkTimeDuration); // works if <2
                                          if (setStartTime < 1) {
                                            setStartTime = 1;
                                          }
                                          // Prevent errors from numbers above 59:59
                                          if (setStartTime > 5959) {
                                            setStartTime = 5959;
                                          }
                                          if (_desiredWorkTimeDuration.length > 2) {
                                            var timeFormatted = formatDuration(setStartTime.toString());
                                            var timeInSeconds = convertMinutesToSeconds(timeFormatted);
                                            setStartTime = timeInSeconds;
                                          }
                                        }

                                        // Check for Changes to Subtract Modifier
                                        if (_desiredSubTimeMod != '') {
                                          setTimeModifyValueSub = int.parse(_desiredSubTimeMod);
                                          if (setTimeModifyValueSub > 5959) {
                                            setTimeModifyValueSub = 5959;
                                          }
                                          if (_desiredSubTimeMod.length > 2) {
                                            var timeFormatted = formatDuration(setTimeModifyValueSub.toString());
                                            var timeInSeconds = convertMinutesToSeconds(timeFormatted);
                                            setTimeModifyValueSub = timeInSeconds;
                                          }
                                        }

                                        // Check for Changes to Addition Modifier
                                        if (_desiredAddTimeMod != '') {
                                          setTimeModifyValueAdd = int.parse(_desiredAddTimeMod);
                                          if (setTimeModifyValueAdd > 5959) {
                                            setTimeModifyValueAdd = 5959;
                                          }
                                          if (_desiredAddTimeMod.length > 2) {
                                            var timeFormatted = formatDuration(setTimeModifyValueAdd.toString());
                                            var timeInSeconds = convertMinutesToSeconds(timeFormatted);
                                            setTimeModifyValueAdd = timeInSeconds;
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
                                      ? Colors.blue
                                      : Colors.grey,
                                  fontSize: 20,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Cancel Button
                              IconButton(
                                iconSize: 45,
                                color: _settingsChanged ? Colors.red : Colors.white,
                                icon: const Icon(Icons.highlight_off),
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.pop(context);
                                },
                              ),

                              // Close/Cancel Text Description
                              Text(
                                _settingsChanged ? 'Cancel' : 'Close',
                                style: TextStyle(
                                  fontFamily: 'AstroSpace',
                                  color: _settingsChanged
                                      ? Colors.red
                                      : Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ]),

                            SizedBox(width: 25),

                            //////////////////////
                            // + time settings
                            /////////////////////
                            Column(children: [
                              // + Time Input Field
                              SizedBox(
                                width: 100,
                                child: (TextFormField(
                                  controller: addTimeTextEditController,
                                  style: TextStyle(color: Colors.blue, fontSize: 20),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value != '') {
                                      // Only record changes if not filtered (leading 0)
                                      recordSettingsChanged('addTime');
                                      if (value.length > 2) {
                                        addTimeTextEditController.text = formatDuration(value);
                                        addTimeTextEditController.selection = TextSelection.collapsed(offset: addTimeTextEditController.text.length);
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
                                        ? changeDurationFromSecondsToMinutes(setTimeModifyValueAdd)
                                        : setTimeModifyValueAdd.toString(),
                                    hintStyle: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                    iconColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                        color: _addTimeSettingChanged ? Colors.blue : Colors.white,
                                        width: 3,
                                      ),
                                      gapPadding: 1.0,
                                    ),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                    FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                    LengthLimitingTextInputFormatter(4), // 4 digits at most
                                    _TextInputFormatter(), // WIP: Formatting in the form of a custom function
                                  ],
                                )),
                              ),

                              const SizedBox(height: 4),

                              // + Time Text Description
                              const Text(
                                '+Time',
                                style: TextStyle(
                                  fontFamily: 'AstroSpace',
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 100),
                            ]),
                          ]),

                      const SizedBox(height: 10),
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
