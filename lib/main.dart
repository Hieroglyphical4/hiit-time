import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:hiit.time/countdown_progress_indicator.dart';
import 'package:hiit.time/Config/settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hiit.time/settings_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    FutureBuilder(
      future:getDuration(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            home: MyApp(duration: snapshot.data),
          );
        } else {
          return Container();
        }
      }
  )
  );
}

class MyApp extends StatefulWidget {
  var duration;

  MyApp({
    Key? key,
    this.duration
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isRunning = false;
  final _controller = CountDownController();
  var _duration = defaultWorkDuration;
  var _restDuration = defaultRestDuration;
  var _timerModifierValueAdd = defaultTimeModifyValueAdd;
  var _timerModifierValueSub = defaultTimeModifyValueSub;
  var _timerButtonRestart = false;
  var _timerInRestMode = false;
  var _orientation = 0;
  var _intervalLap = 1;
  final _audioPlayer = AudioPlayer();

  var _workTime = defaultWorkDuration; // Value displayed in settingsMenu

  @override
  void initState() {
    super.initState();
    _duration = widget.duration ?? defaultWorkDuration;
  }

  // Update the value to be displayed in settings menu from
  Future<void> updateWorkTime() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _workTime = prefs.getInt('duration') ?? defaultWorkDuration;
    });
  }

  Future<void> resetTimer() async {
    final prefs = await SharedPreferences.getInstance();

    _intervalLap = 1;
    _isRunning = false;
    _duration = prefs.getInt('duration') ?? defaultWorkDuration;
    _restDuration = defaultRestDuration;
    _timerModifierValueAdd = defaultTimeModifyValueAdd;
    _timerModifierValueSub = defaultTimeModifyValueSub;

    _controller.restart(
      duration: _duration,
      initialPosition: 0,
      restDuration: _restDuration,
    );
    _timerInRestMode = false;
    _controller.updateWorkoutMode(appInTimerModeDefault);
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _audioPlayer.stop();
    Wakelock.disable();
  }

  // Change timer from Rest Mode to Work Mode and Vice Versa
  Future<void> flipIntervalTimer(bool restFlip) async {
    final prefs = await SharedPreferences.getInstance();

    // Rest Flip indicates the duration needs to be set to Rest Duration
    if (restFlip) {
      _audioPlayer.setVolume(defaultVolume);
      if (!appMutedDefault && modeSwitchAlertEnabled) {
        _audioPlayer.play(AssetSource('sounds/Amplified/Rest-Voice-salli-Amped2.mp3'));
      }
      _duration = defaultRestDuration;
      _restDuration = prefs.getInt('duration') ?? defaultWorkDuration;
    } else {
      _audioPlayer.setVolume(defaultVolume);
      if (!appMutedDefault && modeSwitchAlertEnabled) {
        _audioPlayer.play(AssetSource('sounds/Amplified/Work-Voice-salli-Amped2.mp3'));
      }
      _duration = prefs.getInt('duration') ?? defaultWorkDuration;
      _restDuration = defaultRestDuration;
      _intervalLap++;
    }

    _controller.restart(
      duration: _duration,
      initialPosition: 0,
      restDuration: _restDuration,
    );
    _controller.flip();
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

  // Used to determine how many times to rotate the screen to maintain the orientation
  void setTurnsFromOrientation(NativeDeviceOrientation orientation) {
    int turns = 0;
    switch (orientation) {
      case NativeDeviceOrientation.portraitUp:
        turns = 0;
        break;
      case NativeDeviceOrientation.portraitDown:
        turns = 2;
        break;
      case NativeDeviceOrientation.landscapeLeft:
        turns = 1;
        break;
      case NativeDeviceOrientation.landscapeRight:
        turns = 3;
        break;
      case NativeDeviceOrientation.unknown:
        turns = 0;
        break;
    }
    _orientation = turns;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.transparent,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: secondaryColor,
          child: Center(
            // child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Get the orientation of the device:
                NativeDeviceOrientedWidget(
                    useSensor: true,
                    fallback: (context) {
                      var currentOrientation =
                          NativeDeviceOrientationReader.orientation(context);
                      setTurnsFromOrientation(currentOrientation);
                      return Center(child: Container());
                    }),
                ///////////////////////
                //  HIIT Time Header //
                ///////////////////////
                Container(
                  width: 333,
                  height: 75,
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (appInTimerModeDefault) {
                            return primaryColor;
                          }
                          return null; // defer to the defaults
                        },
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();

                      setState(() {
                        appInTimerModeDefault = !appInTimerModeDefault;
                        _controller.updateWorkoutMode(appInTimerModeDefault);
                      });
                    },
                    child: const Text('HIIT Time',
                        style: TextStyle(fontFamily: 'AstroSpace', fontSize: 40, height: 1.1),
                        textAlign: TextAlign.center),
                  ),
                ),

                // Spacer between Header and Timer
                const SizedBox(height: 20),

                ///////////
                // Timer //
                ///////////
                RotatedBox(
                  quarterTurns: _orientation,
                  child: Ink(
                    height: 333,
                    width: 333,
                    child: InkWell(
                      // focusColor: Colors.green,
                      splashColor: primaryColor,
                      highlightColor: _isRunning ? Colors.pink : Colors.blue,
                      customBorder: const CircleBorder(),
                      // Long press will allow the user to change the duration
                      onLongPress: () {
                        // TODO Engage Count-in mode
                      },
                      onTap: () {
                        _audioPlayer.stop(); // stop timer alarm
                        HapticFeedback.lightImpact();
                        // Check if the user is pressing the timer after it finished.
                        // If so, restart timer to initial state (reset)
                        if (_timerButtonRestart) {
                          resetTimer();
                          _isRunning = true; // To get into upcoming pause block
                          _timerButtonRestart = false;
                        }

                        setState(() {
                          if (_isRunning) {
                            // Timer was running, going into pause mode
                            _controller.pause();
                            // Update timer text
                            _controller.updateWorkoutMode(appInTimerModeDefault);
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
                        valueColor: _timerInRestMode
                        ? appInDarkModeDefault // Color slice showing time passed
                          ? primaryColor
                          : Colors.blueGrey.shade700
                        : Colors.blueGrey.shade700,
                        initialPosition: 0,
                        isRunning: _isRunning,
                        duration: _duration,
                        restDuration: _restDuration,
                        intervalLap: _intervalLap,
                        appInTimerMode: appInTimerModeDefault,
                        timerInRestMode: _timerInRestMode,
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
                            HapticFeedback.vibrate();
                            if (appInTimerModeDefault == false) {
                              // App is in Interval mode and needs to repeat
                              if (_timerInRestMode == false) {
                                _timerInRestMode = true;
                                flipIntervalTimer(_timerInRestMode);
                                // TODO set timer off in reverse
                              } else {
                                _timerInRestMode = false;
                                flipIntervalTimer(_timerInRestMode);
                                _controller.resume();
                              }
                            }
                            if (appInTimerModeDefault == true) {
                              // Upon completion in Timer mode,
                              // Enable the next press on the timer button to restart the timer
                              _timerButtonRestart = true;

                              // Sound the Alarm:
                              if (!appMutedDefault && timerAlarmEnabled) {
                                // _audioPlayer.play(AssetSource('sounds/alarm-beep-beep-1.mp3'));
                                // _audioPlayer.play(AssetSource('sounds/alarm-standard-1.mp3'));
                                _audioPlayer.setVolume(defaultVolume + .1);
                                _audioPlayer.play(AssetSource('sounds/Amplified/PianoAlarmAmped.mp3'));
                                _audioPlayer.setReleaseMode(ReleaseMode.loop);
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),

                // Spacer between timer and buttons
                const SizedBox(height: 25),

                // +/- Time Buttons and Settings
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //////////////////////////
                    // Subtract Time Button //
                    //////////////////////////
                    RotatedBox(
                      quarterTurns: _orientation,
                      child: Container(
                        width: 75,
                        height: 75,
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            HapticFeedback.mediumImpact();

                            // If the user is manually changing the time, we shouldn't
                            // set the timer up to restart on the next press
                            _timerButtonRestart = false;
                            // Reassign value in-case setting were saved
                            _timerModifierValueSub = defaultTimeModifyValueSub;

                            var desiredTime = _controller.setDuration(_duration,
                                (-1 * _timerModifierValueSub.ceil()));
                            _duration = desiredTime;

                            if (_isRunning) {
                              _controller.restart(
                                  duration: _duration, initialPosition: 0);
                              _controller.resume();
                            } else {
                              _audioPlayer.stop(); // stop timer alarm
                              _controller.restart(
                                  duration: _duration, initialPosition: 0);
                            }
                          }),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5),
                            backgroundColor: secondaryAccentColor,
                          ),
                          child: Text(
                              defaultTimeModifyValueSub > 59
                                  ? '-${changeDurationFromSecondsToMinutes(defaultTimeModifyValueSub)}'
                                  : '-${defaultTimeModifyValueSub}s',
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),

                    const SizedBox(width: 45),

                    /////////////////////////////
                    // Settings/Config Button ///
                    /////////////////////////////
                    IconButton(
                      iconSize: 45,
                      color: primaryColor,
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        HapticFeedback.mediumImpact();

                        // Update settings from memory
                        updateWorkTime();

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
                              child: SettingsMenu(
                                key: UniqueKey(),
                                audio: _audioPlayer,
                                workTime: _workTime,
                              ),
                            );
                          },
                        ).then((restartRequired) {
                          if (restartRequired == true) {
                            resetTimer();
                          }
                          setState(() {
                            _controller.updateWorkoutMode(appInTimerModeDefault);
                          });
                        });
                      },
                    ),

                    const SizedBox(width: 45),

                    /////////////////////
                    // Add time Button
                    ////////////////////
                    RotatedBox(
                      quarterTurns: _orientation,
                      child: Container(
                        width: 75,
                        height: 75,
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            HapticFeedback.mediumImpact();
                            // If the user is manually changing the time, we shouldn't
                            // set the timer up to restart on the next press
                            _timerButtonRestart = false;
                            // Reassign value in-case setting were saved
                            _timerModifierValueAdd = defaultTimeModifyValueAdd;

                            var desiredTime = _controller
                                .setDuration(_duration, _timerModifierValueAdd)
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
                            backgroundColor: secondaryAccentColor,
                          ),
                          child: Text(
                              defaultTimeModifyValueAdd > 59
                                  ? '+${changeDurationFromSecondsToMinutes(defaultTimeModifyValueAdd)}'
                                  : '+${defaultTimeModifyValueAdd}s',
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 25),

                //////////////////////
                // Restart Button  ///
                //////////////////////
                SizedBox(
                  height: 90,
                  width: 90,
                  child: ElevatedButton(
                      onPressed: () => setState(() {
                            HapticFeedback.lightImpact();
                            _audioPlayer.setVolume(defaultVolume);
                            if (!appMutedDefault && restartButtonAudioEnabled) {
                              _audioPlayer.play(AssetSource('sounds/Selection1Reversed.mp3'));
                            }
                            resetTimer();
                          }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryAccentColor,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(4),
                      ),
                      child: const Icon(Icons.autorenew, size: 75)),
                ),

                // Bottom Spacing
                const SizedBox(height: 30),
              ],
            ),
            // ) // ScrollView... disabled for now
          ),
        ),
      ),
    );
  }
}
