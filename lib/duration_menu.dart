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

  void recordSettingsChanged() {
    setState(() {
      _settingsChanged = true;
    });
  }

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
                      const SizedBox(height: 45),
                      ////////////////////////////////
                      // Quick Settings Text Header  /
                      ////////////////////////////////
                      // TODO Make clickable to access advanced settings
                      Container(
                          height: 60,
                          child: const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Quick Settings',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))),

                      const SizedBox(height: 65),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              ////////////////////////
                              // Rest Input field  ///
                              ////////////////////////

                              SizedBox(
                                width: 80,
                                child: (TextFormField(
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    _desiredRestTimeDuration = value;
                                    recordSettingsChanged();
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
                                    hintStyle: const TextStyle(
                                        fontSize: 20, color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      gapPadding: 1.0,
                                    ),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                    _TextInputFormatter(),
                                  ], // Only numbers can be entered
                                )),
                              ),
                              const Text(
                                'Rest',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    _desiredWorkTimeDuration = value;
                                    recordSettingsChanged();
                                  },
                                  onFieldSubmitted: (value) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
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
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      gapPadding: 1.0,
                                    ),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                    _TextInputFormatter(),
                                  ], // Only numbers can be entered
                                )),
                              ),
                              const Text(
                                'Work',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      ////////////////////////////////
                      // Spacer between Cancel/-time/+time button and timer settings
                      ////////////////////////////////
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Timer Mode',
                            style: TextStyle(
                              color:
                                  appInTimerMode ? Colors.white : Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 20),
                          ////////////////////////////////////
                          // Switch/Toggle Between App Modes
                          ////////////////////////////////////
                          Switch(
                            value: !appInTimerMode,
                            onChanged: _onChanged,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Interval Mode',
                            style: TextStyle(
                              color: appInTimerMode ? Colors.grey : Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 50),
                        ],
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ///////////////////////////
                                  // - Time input field  ////
                                  ///////////////////////////
                                  SizedBox(
                                    width: 100,
                                    child: (TextFormField(
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        recordSettingsChanged();
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
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          gapPadding: 1.0,
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                        _TextInputFormatter(),
                                      ], // Only numbers can be entered
                                    )),
                                  ),

                                  SizedBox(width: 25),

                                  //////////////////
                                  // Cancel Button
                                  //////////////////
                                  IconButton(
                                    iconSize: 75,
                                    color: Colors.red,
                                    icon: const Icon(Icons.block),
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.pop(context);
                                    },
                                  ),

                                  SizedBox(width: 25),

                                  /////////////////////////
                                  // + Time input field  //
                                  /////////////////////////
                                  SizedBox(
                                    width: 100,
                                    child: (TextFormField(
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        _desiredAddTimeMod = value;
                                        recordSettingsChanged();
                                      },
                                      onFieldSubmitted: (value) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      decoration: InputDecoration(
                                        // hintText: '+$setTimeModifyValueAdd',

                                        hintText: setTimeModifyValueAdd > 59
                                            ? changeDurationFromSecondsToMinutes(
                                                setTimeModifyValueAdd)
                                            : setTimeModifyValueAdd.toString(),

                                        hintStyle: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                        iconColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          gapPadding: 1.0,
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                        _TextInputFormatter(),
                                      ], // Only numbers can be entered
                                    )),
                                  ),
                                ]),

                            //////////////////////////////////////
                            // Time Adjuster Text Descriptions ///
                            //////////////////////////////////////
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    '- Time',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 170),
                                  Text(
                                    '+ Time',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),

                            const SizedBox(height: 10),

                            /////////////////
                            // Save Button
                            /////////////////
                            IconButton(
                              iconSize: 75,
                              color: Colors.blue,
                              icon: const Icon(Icons.save),
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
                                        setRestDuration =
                                            int.parse(_desiredRestTimeDuration);
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
                                        _changesRequiringRestartOccured = true;
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
                                              setTimeModifyValueSub.toString());
                                          var timeInSeconds =
                                              convertMinutesToSeconds(
                                                  timeFormatted);
                                          setTimeModifyValueSub = timeInSeconds;
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
                                              setTimeModifyValueAdd.toString());
                                          var timeInSeconds =
                                              convertMinutesToSeconds(
                                                  timeFormatted);
                                          setTimeModifyValueAdd = timeInSeconds;
                                        }
                                      }

                                      Navigator.pop(context,
                                          _changesRequiringRestartOccured); // Close Settings menu
                                    }
                                  : null, // If settings haven't changed, Disable Save Button
                            ),

                            const SizedBox(height: 75),
                          ]),
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
