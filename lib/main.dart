import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:hiit.time/countdown_progress_indicator.dart';
import 'package:hiit.time/Config/settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hiit.time/settings_menu.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
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
  var _restDuration = setRestDuration;
  var _timerModifierValueAdd = setTimeModifyValueAdd;
  var _timerModifierValueSub = setTimeModifyValueSub;
  var _timerButtonRestart = false;
  var _timerInRestMode = false;
  var _orientation = 0;
  var _intervalLap = 1;
  final _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  void resetTimer() {
    _intervalLap = 1;
    _isRunning = false;
    _duration = setStartTime;
    _restDuration = setRestDuration;
    _timerModifierValueAdd = setTimeModifyValueAdd;
    _timerModifierValueSub = setTimeModifyValueSub;

    _controller.restart(
      duration: _duration,
      initialPosition: 0,
      restDuration: _restDuration,
    );
    _timerInRestMode = false;
    _controller.updateWorkoutMode(appInTimerMode);
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _audioPlayer.stop();
    Wakelock.disable();
  }

  // Change timer from Rest Mode to Work Mode and Vice Versa
  void flipIntervalTimer(bool restFlip) {
    // Rest Flip indicates the duration needs to be set to Rest Duration
    if (restFlip) {
      // _audioPlayer.setVolume(1.5);
      !appMuted ? _audioPlayer.play(AssetSource('sounds/Rest-Voice-salli.mp3')) : null;
      _duration = setRestDuration;
      _restDuration = setStartTime;
    } else {
      // _audioPlayer.setVolume(1.5);
      !appMuted ? _audioPlayer.play(AssetSource('sounds/Work-Voice-salli.mp3')) : null;
      _duration = setStartTime;
      _restDuration = setRestDuration;
      _intervalLap++;
      // _controller.updateIntervalLap('increase');
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
                          if (appInTimerMode) {
                            return primaryColor;
                          }
                          return null; // defer to the defaults
                        },
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();

                      setState(() {
                        appInTimerMode = !appInTimerMode;
                        _controller.updateWorkoutMode(appInTimerMode);
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
                        HapticFeedback.lightImpact();

                        _audioPlayer.setVolume(.5);
                        if (_isRunning) {
                          !appMuted ? _audioPlayer.play(AssetSource('sounds/Selection1.mp3')) : null;
                        } else {
                          !appMuted ? _audioPlayer.play(AssetSource('sounds/Selection1Reversed.mp3')) : null;
                        }
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
                            _controller.updateWorkoutMode(appInTimerMode);
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
                        ? appInDarkMode // Color slice showing time passed
                          ? primaryColor
                          : Colors.blueGrey.shade700
                        : Colors.blueGrey.shade700,
                        initialPosition: 0,
                        isRunning: _isRunning,
                        duration: _duration,
                        restDuration: _restDuration,
                        intervalLap: _intervalLap,
                        appInTimerMode: appInTimerMode,
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
                            if (appInTimerMode == false) {
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
                            if (appInTimerMode == true) {
                              // Upon completion in Timer mode,
                              // Enable the next press on the timer button to restart the timer
                              _timerButtonRestart = true;

                              // Sound the Alarm:
                              if (!appMuted) {
                                // _audioPlayer.play(AssetSource('sounds/alarm-beep-beep-1.mp3'));
                                // _audioPlayer.play(AssetSource('sounds/alarm-standard-1.mp3'));
                                _audioPlayer.setVolume(.5);
                                _audioPlayer.play(AssetSource('sounds/PianoAlarm.mp3'));
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

                            _audioPlayer.setVolume(.2);
                            _audioPlayer.setReleaseMode(ReleaseMode.stop);
                            !appMuted ? _audioPlayer.play(AssetSource('sounds/PongDown.mp3')) : null;
                            // If the user is manually changing the time, we shouldn't
                            // set the timer up to restart on the next press
                            _timerButtonRestart = false;
                            // Reassign value in-case setting were saved
                            _timerModifierValueSub = setTimeModifyValueSub;

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
                              setTimeModifyValueSub > 59
                                  ? '-${changeDurationFromSecondsToMinutes(setTimeModifyValueSub)}'
                                  : '-${setTimeModifyValueSub}s',
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
                        _audioPlayer.setVolume(.5);
                        _audioPlayer.setReleaseMode(ReleaseMode.stop);
                        !appMuted ? _audioPlayer.play(AssetSource('sounds/ShopOpenBellv2.mp3')) : null;
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
                              child: SettingsMenu(
                                key: UniqueKey(),
                                audio: _audioPlayer
                              ),
                            );
                          },
                        ).then((restartRequired) {
                          if (restartRequired == true) {
                            resetTimer();
                          }
                          setState(() {
                            _controller.updateWorkoutMode(appInTimerMode);
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

                            _audioPlayer.setVolume(.2);
                            _audioPlayer.setReleaseMode(ReleaseMode.stop);
                            !appMuted ? _audioPlayer.play(AssetSource('sounds/PongUp.mp3')) : null;

                            // If the user is manually changing the time, we shouldn't
                            // set the timer up to restart on the next press
                            _timerButtonRestart = false;
                            // Reassign value in-case setting were saved
                            _timerModifierValueAdd = setTimeModifyValueAdd;

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
                              setTimeModifyValueAdd > 59
                                  ? '+${changeDurationFromSecondsToMinutes(setTimeModifyValueAdd)}'
                                  : '+${setTimeModifyValueAdd}s',
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

                            _audioPlayer.setVolume(.3);
                            !appMuted ? _audioPlayer.play(AssetSource('sounds/dooDaDoo.mp3')) : null;

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
