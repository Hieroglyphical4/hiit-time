// import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
// import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:hiit.time/countdown_progress_indicator.dart';
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
  var _timerModifierValue = setTimeModifyValue;
  var _stringModValue = setTimeModifyValue.toString();

  @override
  Widget build(BuildContext context) {
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
                      backgroundColor:
                          _isRunning ? Colors.lightGreenAccent.shade700 : Colors.blue,
                      initialPosition: 0,
                      duration: _duration,
                      text: 'seconds',
                      onComplete: () {
                        // Code to be executed when the countdown completes
                        setState(() {
                          print('Timer Complete!');
                          // print(_duration);
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
                          var desiredTime = _controller.setDuration(_duration, (-1 * _timerModifierValue.ceil()));
                          _duration = desiredTime;

                          if (_isRunning) {
                            _controller.restart(duration: _duration, initialPosition: 0);
                            _controller.resume();
                          } else {
                            _controller.restart(duration: _duration, initialPosition: 0);
                          }

                        }),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(5),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                            '-$_stringModValue',
                            style: const TextStyle(
                                fontSize: 20
                            )
                        ),
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
                          var desiredTime = _controller.setDuration(_duration, _timerModifierValue).ceil();
                          _duration = desiredTime;

                          if (_isRunning) {
                            _controller.restart(duration: _duration, initialPosition: 0);
                            _controller.resume();
                          } else {
                            _controller.restart(duration: _duration, initialPosition: 0);
                          }

                        }),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(5),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                            '+$_stringModValue',
                          style: const TextStyle(
                            fontSize: 20
                          )
                        ),
                      ),
                    ),
                  ],
                ),

                //////////////////////
                // Restart Button  ///
                //////////////////////
                ElevatedButton(
                  onPressed: () => setState(() {
                    _duration = setStartTime;
                    _isRunning = false;
                    _controller.restart(duration: _duration, initialPosition: 0);
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
