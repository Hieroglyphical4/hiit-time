// import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:hiit.time/countdown_progress_indicator.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hiit.time/Config/settings.dart';
import 'package:flutter/material.dart';

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
  var _timerLabel = 'seconds';
  final _timerModifierValue = setTimeModifyValue;
  final _stringModValue = setTimeModifyValue.toString();

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

        // TODO Get this background guy working
        const androidConfig = FlutterBackgroundAndroidConfig(
          notificationTitle: "flutter_background example app",
          notificationText:
              "Background notification for keeping the example app running in the background",
          notificationImportance: AndroidNotificationImportance.Default,
          notificationIcon: AndroidResource(
              name: 'background_icon',
              defType: 'drawable'), // Default is ic_launcher from folder mipmap
        );
        bool success =
            await FlutterBackground.initialize(androidConfig: androidConfig);
        bool hasPermissions = await FlutterBackground.hasPermissions;
        FlutterBackground.initialize(); // TODO Is this right???????
        bool enableBackgroundSuccess =
            await FlutterBackground.enableBackgroundExecution();
        // await FlutterBackground.disableBackgroundExecution(); // Keeping command around for reference
        // bool enabled = FlutterBackground.isBackgroundExecutionEnabled; // To check if its enabled
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
                // Enables animation on clicks
                Ink(
                  height: 300,
                  width: 300,
                  child: InkWell(
                    focusColor: Colors.green,
                    splashColor: Colors.white,
                    highlightColor: _isRunning ? Colors.pink : Colors.blue,
                    customBorder: const CircleBorder(),
                    onTap: () {
                      if (_canVibrate) {
                        Vibrate.feedback(FeedbackType.light);
                      }
                      setState(() {
                        if (_isRunning) {
                          _controller.pause();
                        } else {
                          _controller.resume();
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
                      valueColor: Colors.red,
                      backgroundColor: _isRunning
                          ? Colors.lightGreenAccent.shade700
                          : Colors.blue,
                      initialPosition: 0,
                      duration: _duration,
                      text: _timerLabel,
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
                        });
                      },
                    ),
                  ),
                ),

                // Spacer between timer and buttons
                const SizedBox(height: 25),
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
                          backgroundColor: Colors.black,
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
                          backgroundColor: Colors.black,
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
                    _isRunning = false;
                    _controller.restart(
                        duration: _duration, initialPosition: 0);
                  }),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(40),
                  ),
                  child: const Text('Restart'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
