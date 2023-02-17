import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hiit.time/Config/settings.dart';

/// Create a Circular countdown indicator
class CountDownProgressIndicator extends StatefulWidget {
  /// Timer duration in seconds
  final int duration;

  /// Filling color
  final Color valueColor;

  /// This controller is used to restart, stop or resume the countdown
  final CountDownController? controller;

  /// This call callback will be executed when the Countdown ends.
  final Function? onComplete;

  /// Stroke width, the default is 10
  final double strokeWidth;

  /// Initial time, 0 by default
  final int initialPosition;

  /// The style for the remaining time indicator
  /// The default is black color, and fontWeight of W600
  final TextStyle? timeTextStyle;

  /// The formatter for the time string
  /// By default, no formatting is applied and
  /// the time is displayed in number of seconds left
  final String Function(int seconds)? timeFormatter;

  /// The style for the widget label
  /// The default is black color, and fontWeight of W600
  final TextStyle? labelTextStyle;

  /// This text will be shown with the time indicator
  // final String? text;

  /// true by default, this value indicates that the timer
  /// will start automatically
  final bool autostart;

  // Used to determine if App is in Timer Mode or Interval Mode
  var appInTimerMode;

  // Time of rest
  var restDuration;

  // Determine if timer is in Rest Mode vs Work Mode
  var timerInRestMode;

  // Determing is Timer is currently running
  var isRunning;

  // Keeps track and display current lap, resets on Timer reset
  var intervalLap;

  // Manages audio output
  var audioPlayer;

  // ignore: public_member_api_docs
  CountDownProgressIndicator({
    Key? key,
    required this.duration,
    this.restDuration,
    this.initialPosition = 0,
    required this.valueColor,
    this.timerInRestMode,
    this.controller,
    this.audioPlayer,
    this.isRunning,
    this.onComplete,
    this.timeTextStyle,
    this.timeFormatter,
    this.labelTextStyle,
    this.strokeWidth = 22,
    this.appInTimerMode,
    this.intervalLap,
    this.autostart = false,
  })  : assert(duration > 0),
        assert(initialPosition < duration),
        super(key: key);

  @override
  _CountDownProgressIndicatorState createState() =>
      _CountDownProgressIndicatorState();
}

class _CountDownProgressIndicatorState extends State<CountDownProgressIndicator>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  late AudioPlayer _audioPlayer;
  var _timerText = 'Tap to Start';
  var _currentDuration;
  var _desiredTime = 30;
  final _secondTimerSize = 135.0;
  final _minuteTimerSize = 115.0;
  late var _timerSize =
      widget.duration > 60 ? _minuteTimerSize : _secondTimerSize;

  // Used to prevent sounds from stacking
  bool _tenSecondQuePlayed = false;
  bool _threeSecondQuePlayed = false;
  bool _twoSecondQuePlayed = false;
  bool _oneSecondQuePlayed = false;

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _audioPlayer = widget.audioPlayer;
    _tenSecondQuePlayed = false;
    _threeSecondQuePlayed = false;
    _twoSecondQuePlayed = false;
    _oneSecondQuePlayed = false;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: widget.duration,
      ),
    );
    _animation = Tween<double>(
      begin: widget.initialPosition.toDouble(),
      end: widget.duration.toDouble(),
    ).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _animationController.addListener(() {
      _currentDuration = (widget.duration - _animation.value).toInt();
      if (_animation.value == 0.0) {
        // This indicates the duration change was a result of a button press
        // We should have the desired time calculated from the button press
        _currentDuration = _desiredTime;
      }
      setState(() {
        // Update: 3 separate checks on 3-2-1 instead of lumping audio into one
        if (_currentDuration == 3 && widget.isRunning && _threeSecondQuePlayed == false && !appCurrentlyMuted && threeTwoOneCountdownCurrentlyEnabled) {
          _audioPlayer.setReleaseMode(ReleaseMode.stop);
          _audioPlayer.play(AssetSource('sounds/Amplified/SalliThree.mp3'));
          _threeSecondQuePlayed = true;
        }
        if (_currentDuration == 2 && widget.isRunning && _twoSecondQuePlayed == false && !appCurrentlyMuted && threeTwoOneCountdownCurrentlyEnabled) {
          _audioPlayer.setReleaseMode(ReleaseMode.stop);
          _audioPlayer.play(AssetSource('sounds/Amplified/SalliTwo.mp3'));
          _twoSecondQuePlayed = true;
        }
        if (_currentDuration == 1 && widget.isRunning && _oneSecondQuePlayed == false && !appCurrentlyMuted && threeTwoOneCountdownCurrentlyEnabled) {
          _audioPlayer.setReleaseMode(ReleaseMode.stop);
          _audioPlayer.play(AssetSource('sounds/Amplified/SalliOne1.mp3'));
          _oneSecondQuePlayed = true;
        }
        if (_currentDuration == 10 && widget.isRunning && _tenSecondQuePlayed == false && !appCurrentlyMuted && tenSecondWarningCurrentlyEnabled) {
          _audioPlayer.setReleaseMode(ReleaseMode.stop);
          _audioPlayer.play(AssetSource('sounds/Amplified/JoeyTenAmped2.mp3'));
          _tenSecondQuePlayed = true;
        }
        _timerText = 'Timer Mode';
        if (_currentDuration > 59) {
          _timerSize = _minuteTimerSize;
        }
        if (_currentDuration < 58) {
          _timerSize = _secondTimerSize;
        }

        if (widget.appInTimerMode) {
          _timerText = 'Timer Mode';
        }
        if (!widget.appInTimerMode) {
          _timerText = 'Interval Mode';

          if (widget.isRunning) {
            _timerText = 'Work';
            if (widget.timerInRestMode) {
              _timerText = 'Rest';
            }
          }
        }
      });
    });

    _animation.addListener(() {
      setState(() {
        _animation = Tween<double>(
          begin: widget.initialPosition.toDouble(),
          end: widget.duration.toDouble(),
        ).animate(_animationController);
      });
    });

    widget.controller?._state = this;

    if (widget.autostart) onAnimationStart();
  }

  @override
  void reassemble() {
    onAnimationStart();
    super.reassemble();
  }

  void onAnimationStart() {
    _animationController.forward(from: 0);
  }

  // To go from seconds to mm:ss
  String changeDurationFromSecondsToMinutes(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: CircularProgressIndicator(
              strokeWidth: widget.strokeWidth,
              backgroundColor: widget.timerInRestMode
                  // Rest Mode:
                  ? widget.isRunning
                      ? secondaryColor
                      : Colors.blue
                  // Work Mode:
                  : widget.isRunning
                      ? Colors.lightGreenAccent.shade700
                      : Colors.blue,
              valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
              value: _animation.value / widget.duration,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (widget.duration - _animation.value).toInt() < 59
                      ? SizedBox(height: 15) // In Second Mode
                      : SizedBox(height: 12),
                  // In Minute Mode

                  // For when the App is in INTERVAL Mode
                  (!widget.appInTimerMode)
                      ? Column(children: [
                          //////////////////////////////////////////
                          // Secondary Number (top most): Duration
                          /////////////////////////////////////////
                          Text(
                            widget.restDuration > 59
                                ? changeDurationFromSecondsToMinutes(
                                    widget.restDuration)
                                : widget.restDuration.toString(),

                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: widget.timerInRestMode
                                        ? primaryColor
                                        : Colors.blue.shade300,
                                    fontFamily: 'AstroSpace',
                                    fontSize: 25,
                                    height: .1
                                    // fontWeight: FontWeight.w600,
                                    ),
                          ),
                          SizedBox(height: 28),
                        ])
                      : SizedBox(height: 30),

                  (widget.duration - _animation.value).toInt() < 59
                      ? Container() // In Second Mode
                      : SizedBox(height: 10),
                  // In Minute Mode

                  // Check if remaining duration should be displayed as Minute or Second
                  (widget.duration - _animation.value).toInt() < 59
                      ///////////////
                      // Second mode:
                      ///////////////
                      ? Text(
                          (widget.duration - _animation.value)
                              .toStringAsFixed(0),
                          style: widget.timeTextStyle ??
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: widget.timerInRestMode
                                      ? Colors.blue.shade300
                                      : primaryColor,
                                  // 59 is used here to avoid a small 59
                                  fontSize:
                                      (_currentDuration ?? widget.duration) > 59
                                          ? _minuteTimerSize
                                          : _secondTimerSize,
                                  fontWeight: FontWeight.w600),
                        )
                      ///////////////
                      // Minute mode
                      ///////////////
                      : Text(
                          widget.timeFormatter?.call(
                                  (widget.duration - _animation.value)
                                      .ceil()) ??
                              (widget.duration - _animation.value)
                                  .toStringAsFixed(0),
                          style: widget.timeTextStyle ??
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: widget.timerInRestMode
                                      ? Colors.blue.shade300
                                      : primaryColor,
                                  // 58 is used as a buffer, any higher and 1:00 is huge
                                  fontSize:
                                      (_currentDuration ?? widget.duration) > 58
                                          ? _minuteTimerSize
                                          : _secondTimerSize,
                                  fontWeight: FontWeight.w600),
                        ),

                  ///////////////////////////
                  // Clock Mode Description
                  ///////////////////////////
                  (widget.appInTimerMode)
                      ? Column(children: [
                        ///////////////////
                        // In "Timer Mode"
                        ///////////////////
                          SizedBox(height: 20),
                          Text(
                            _timerText,
                            style: widget.labelTextStyle ??
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: primaryColor,
                                      fontFamily: 'AstroSpace',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                          )
                        ])
                      : Column(children: [
                        ////////////////////////
                        // In: "Interval Mode"
                        ////////////////////////
                          SizedBox(height: 20),
                          Text(
                            widget.isRunning
                                ? _timerText +
                                    ": " +
                                    widget.intervalLap.toString()
                                : _timerText,
                            style: widget.labelTextStyle ??
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: !widget.isRunning
                                          ? Colors.blue
                                          : widget.timerInRestMode
                                              ? Colors.blue.shade300
                                              : primaryColor,
                                      fontFamily: 'AstroSpace',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper class for CountDown widget
class CountDownController {
  late _CountDownProgressIndicatorState _state;

  // Switch between Interval and Timer mode when animation is paused
  updateWorkoutMode(bool inTimerMode) {
    if (inTimerMode) {
      _state._timerText = 'Timer Mode';
      _state.widget.appInTimerMode = true;
    } else {
      _state._timerText = 'Interval Mode';
      _state.widget.appInTimerMode = false;
    }
  }

  // Update the timers remaining duration using +/- buttons
  // _state._animation.value = How many secs have passed
  setDuration(int currentDuration, int timeModification) {
    var currentTime = (currentDuration - _state._animation.value);
    var desiredTime = (currentTime + timeModification).toInt();

    // Prevent errors from negative numbers
    if (desiredTime < 1) {
      desiredTime = 1;
    }
    // Prevent errors from numbers above 99:99
    if (desiredTime > 3599) {
      desiredTime = 3599;
    }

    _state._desiredTime = desiredTime;
    _state._animationController.duration = Duration(seconds: desiredTime);
    // Enable Audio Queues
    _state._oneSecondQuePlayed = false;
    _state._twoSecondQuePlayed = false;
    _state._threeSecondQuePlayed = false;
    _state._tenSecondQuePlayed = false;

    return desiredTime;
  }

  /// Pause countdown timer
  void pause() {
    _state._animationController.stop(canceled: false);
  }

  /// Resumes countdown time
  void resume() {
    _state._animationController.forward();
  }

  /// Starts countdown timer
  /// This method works when [autostart] is false
  void start() {
    if (!_state.widget.autostart) {
      _state._animationController
          .forward(from: _state.widget.initialPosition.toDouble());
    }
  }

  void flip() {
    _state._animationController.forward();
    // _state._animationController.reverse(); // TODO Get Working
  }

  /// Restarts countdown timer.
  ///
  /// * [duration] is an optional value, if this value is null,
  /// the duration will use the previous one defined in the widget
  /// * Use [initialPosition] if you want the original position
  void restart(
      {int? duration, required double initialPosition, int? restDuration}) {
    if (duration != null) {
      _state._animationController.duration = Duration(seconds: duration);
      _state._desiredTime = duration;
    }
    if (restDuration != null) {
      _state.widget.restDuration = restDuration;
    }

    // Enable Audio Queues
    _state._oneSecondQuePlayed = false;
    _state._twoSecondQuePlayed = false;
    _state._threeSecondQuePlayed = false;
    _state._tenSecondQuePlayed = false;

    _state._animationController.forward(from: initialPosition);
    _state._animationController.stop(canceled: false);
  }
}
