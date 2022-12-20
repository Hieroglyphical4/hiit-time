// import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:hiit.time/countdown_progress_indicator.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hiit.time/Config/settings.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';

import 'hiit_time_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isRunning = false;
  final _controller = CountDownController();
  var _duration = setStartTime;
  final _timerModifierValue = setTimeModifyValue;
  final _stringModValue = setTimeModifyValue.toString();
  var _timerButtonRestart = false;
  var _appInTimerMode = true;
  var _restDuration = setRestDuration;

  @override
  void initState() {
    super.initState();
    _init();
  }

  // Vibration related settings
  bool _canVibrate = false;
  final Iterable<Duration> pauses = [
    const Duration(milliseconds: 150),
  ];

  Future<void> _init() async {
    try {
      bool canVibrate = await Vibrate.canVibrate;
      setState(() async {
        _canVibrate = canVibrate;
      });
    } catch (e) {
      print('Error checking if device can vibrate: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return MaterialApp(
      color: Colors.transparent,
      home: Scaffold(
        body: Container(
          color: Colors.black.withOpacity(0.85),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///////////////////////
                //  HIIT Time Header //
                ///////////////////////
                Container(
                  width: 333,
                  height: 75,
                  child: HiitTimeButton(
                    selected: _appInTimerMode,
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.white;
                          }
                          return null; // defer to the defaults
                        },
                      ),
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.transparent;
                          }
                          return null; // defer to the defaults
                        },
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _appInTimerMode = !_appInTimerMode;
                        _controller.updateWorkoutMode(_appInTimerMode);
                      });
                    },
                    child: const Text('HIIT Time',
                        style: TextStyle(
                            fontFamily: 'SuezOne', fontSize: 44, height: 1.1),
                        textAlign: TextAlign.center),
                  ),
                ),

                // Spacer between Header and Timer
                const SizedBox(height: 30),

                ///////////
                // Timer //
                ///////////
                Ink(
                  height: 333,
                  width: 333,
                  child: InkWell(
                    // focusColor: Colors.green,
                    splashColor: Colors.white,
                    highlightColor: _isRunning ? Colors.pink : Colors.blue,
                    customBorder: const CircleBorder(),
                    // Long press will allow the user to change the duration
                    onLongPress: () {
                      // TODO Get a popup appearing here
                      // showIndicator();
                      // _changeDurationMenu(context);
                      // _showIndicator;
                    },
                    onTap: () {
                      if (_canVibrate) {
                        Vibrate.feedback(FeedbackType.light);
                      }

                      // Check if the user is pressing the timer after it finished.
                      // If so, restart timer to initial state
                      if (_timerButtonRestart) {
                        _duration = setStartTime;
                        _controller.restart(
                            duration: _duration, initialPosition: 0);
                        _timerButtonRestart = false;
                      }

                      setState(() {
                        if (_isRunning) {
                          // Timer was running, going into pause mode
                          _controller.pause();
                          Wakelock.disable();
                        } else {
                          // Timer was paused, turning on
                          _controller.resume();
                          Wakelock.enable();
                        }
                        _isRunning = !_isRunning; // Flip isRunning state
                      });
                    },
                    ///////////
                    // Timer //
                    ///////////
                    child: CountDownProgressIndicator(
                      controller: _controller,
                      strokeWidth: 18,
                      autostart: false,
                      valueColor: Colors.blueGrey.shade700,
                      backgroundColor: _isRunning
                          ? Colors.lightGreenAccent.shade700
                          : Colors.blue,
                      initialPosition: 0,
                      duration: _duration,
                      restDuration: _restDuration,
                      appInTimerMode: _appInTimerMode,
                      timeFormatter: _duration > 59
                          ? (seconds) {
                              // When the duration is above 59 seconds,
                              // this will create a mm:ss format
                              var Dur = Duration(seconds: seconds);
                              String twoDigits(int n) =>
                                  n.toString().padLeft(2, "0");
                              String twoDigitMinutes =
                                  twoDigits(Dur.inMinutes.remainder(60));
                              String twoDigitSeconds =
                                  twoDigits(Dur.inSeconds.remainder(60));
                              return "$twoDigitMinutes:$twoDigitSeconds";
                            }
                          : null,
                      onComplete: () {
                        // Code to be executed when the countdown completes
                        setState(() {
                          if (_canVibrate) {
                            Vibrate.vibrateWithPauses(pauses);
                          }
                          // Upon completion, Enable the next press on the timer button to restart the timer
                          _timerButtonRestart = true;

                          // Disable keeping the phone awake
                          Wakelock.disable();
                        });
                      },
                    ),
                  ),
                ),

                // Spacer between timer and buttons
                const SizedBox(height: 25),

                // +/- Time Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //////////////////////////
                    // Subtract Time Button //
                    //////////////////////////
                    Container(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () => setState(() {
                          if (_canVibrate) {
                            Vibrate.feedback(FeedbackType.light);
                          }
                          // If the user is manually changing the time, we shouldn't
                          // set the timer up to restart on the next press
                          _timerButtonRestart = false;

                          var desiredTime = _controller.setDuration(
                              _duration, (-1 * _timerModifierValue.ceil()));
                          _duration = desiredTime;

                          if (_isRunning) {
                            _controller.restart(
                                duration: _duration, initialPosition: 0);
                            _controller.resume();
                          } else {
                            _controller.restart(
                                duration: _duration, initialPosition: 0);
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(5),
                          backgroundColor: Colors.blueGrey.shade700,
                        ),
                        child: Text('-$_stringModValue',
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),

                    const SizedBox(width: 150),

                    /////////////////////
                    // Add time Button
                    ////////////////////
                    Container(
                      width: 70,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () => setState(() {
                          if (_canVibrate) {
                            Vibrate.feedback(FeedbackType.light);
                          }
                          // If the user is manually changing the time, we shouldn't
                          // set the timer up to restart on the next press
                          _timerButtonRestart = false;

                          var desiredTime = _controller
                              .setDuration(_duration, _timerModifierValue)
                              .ceil();
                          _duration = desiredTime;

                          if (_isRunning) {
                            _controller.restart(
                                duration: _duration, initialPosition: 0);
                            _controller.resume();
                          } else {
                            _controller.restart(
                                duration: _duration, initialPosition: 0);
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(5),
                          backgroundColor: Colors.blueGrey.shade700,
                        ),
                        child: Text('+$_stringModValue',
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),

                //////////////////////
                // Restart Button  ///
                //////////////////////
                ElevatedButton(
                  onPressed: () => setState(() {
                    if (_canVibrate) {
                      Vibrate.feedback(FeedbackType.heavy);
                    }
                    _duration = setStartTime;
                    _controller.restart(
                        duration: _duration, initialPosition: 0);
                    _isRunning = false;
                    Wakelock.disable();
                  }),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(40),
                  ),
                  child: const Text('Restart'),
                ),

                // Bottom Spacing
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
