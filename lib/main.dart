import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hiit_time/Config/notification_controller.dart';
import 'package:hiit_time/countdown_progress_indicator.dart';
import 'package:hiit_time/advanced_settings_menu.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:hiit_time/Config/settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hiit_time/settings_menu.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Database/database_helper.dart';
import 'dart:async';
import 'dart:ui';

// Initialize the audio player
final audioPlayer = AudioPlayer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevents weird orientation rotation?
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Service Used to keep timer running in background
  initializeService();

  // Initialize Notifications
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  NotificationController.initializeLocalNotifications(awesomeNotifications);


  // Initialize the database
  await DatabaseHelper.instance.database;

  runApp(FutureBuilder(
      future: getSavedUserSettings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Assemble user settings:
          int returnedWorkTime = int.parse(snapshot.data!['workDuration']);
          int returnedRestTime = int.parse(snapshot.data!['restDuration']);
          int returnedTimeModAdd =
              int.parse(snapshot.data!['timeModifyValueAdd']);
          int returnedTimeModSub =
              int.parse(snapshot.data!['timeModifyValueSub']);
          double returnedAppVolume = double.parse(snapshot.data!['appVolume']);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MyApp(
              audioPlayer: audioPlayer,
              notifications: awesomeNotifications,
              workDuration: returnedWorkTime,
              restDuration: returnedRestTime,
              timeModAdd: returnedTimeModAdd,
              timeModSub: returnedTimeModSub,
              appVolume: returnedAppVolume,
            ),
          );
        } else {
          return Container();
        }
      }));
}

Future<void> stopAudio() async {
  await audioPlayer.stop();
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      autoStartOnBoot: false,
      isForegroundMode: false,

      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(),
  );

  service.startService();
}
Future<void> onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();
  var servicePlayer = AudioPlayer();

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    await servicePlayer.play(AssetSource('sounds/Silence.mp3'));
    await servicePlayer.stop();
  });
}

// In-App purchase Setup
late StreamSubscription<dynamic> _streamSubscription;

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  var audioPlayer;
  var notifications;
  var workDuration;
  var restDuration;
  var timeModAdd;
  var timeModSub;
  var appVolume;

  MyApp({
    Key? key,
    this.audioPlayer,
    this.notifications,
    this.workDuration,
    this.restDuration,
    this.timeModAdd,
    this.timeModSub,
    this.appVolume,
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
  late AudioPlayer _audioPlayer;
  late AwesomeNotifications _notificationsPlugin;

  // Second Audio player added for overlapping audio
  final _audioPlayer2 = AudioPlayer();
  var _appVolume = defaultVolume;

  // Values being passed to Settings Menu
  var _workTime = defaultWorkDuration;
  var _restTime = defaultRestDuration;

  // Used to communicate to the Themes widget (thru AdvancedSettings) to update the UI after a Purchase
  final advancedSettingsKey = GlobalKey<AdvancedSettingsMenuState>();

  // Used for In-App purchases
  _listenToPurchase(List<PurchaseDetails> purchaseDetailsList, BuildContext context) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('New PurchaseID Heard: ${purchaseDetails.productID}')));
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction Date: ${purchaseDetails.transactionDate}')));
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Local Verif: ${purchaseDetails.verificationData.localVerificationData}')));
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server Verif: ${purchaseDetails.verificationData.serverVerificationData}')));

      if (purchaseDetails.status == PurchaseStatus.pending)  {
        // Item is pending
        // TODO Add pending UI?
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchase Pending...')));
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Item encountered an error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Encountered: ${purchaseDetails.error!.message}")));
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        // User purchased product previous, ensure they have it enabled
        enableTheme(purchaseDetails.productID);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        // User just purchased an item
        // TODO Is Additional verification needed before enabling?
        enableTheme(purchaseDetails.productID);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your Purchase!!!')));
      }

      // Complete Purchase
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);

        // Trigger method in Advanced Settings to update UI
        advancedSettingsKey.currentState?.updateUIAfterPurchase();
      }
    });
  }

  // Used for In-App purchases
  _initStore() async {
    var storeAvailable = await inAppPurchase.isAvailable();

    if (storeAvailable) {
      final ProductDetailsResponse productDetailsResponse = await inAppPurchase.queryProductDetails(productIds);

      if (productDetailsResponse.notFoundIDs.isNotEmpty) {
        // No products found from store.
        // todo Remove Purchases? Test this!
        clearThemesFromSavedPrefs();
      }

      if (productDetailsResponse.error == null) {
        // No errors found, restore previous purchases
        inAppPurchase.restorePurchases();
        setState(() {
          // Setup products from store
          // This variable is set in settings.dart
          availableProducts = productDetailsResponse.productDetails;
        });
      }
    } else {
      // No store available to verify purchases.
      // Set them using the user's storedPreferences for now:
      setupInAppPurchasesFromSharedPreferences();
    }
  }

  @override
  void initState() {
    super.initState();

    ////////////////////////////////
    // Begin In-App Purchase Block
    ////////////////////////////////
    // setupInAppPurchasesFromSharedPreferences();
    inAppPurchase = InAppPurchase.instance; // This is the Billing Client
    final Stream purchaseUpdated = inAppPurchase.purchaseStream;
    _streamSubscription = purchaseUpdated.listen((purchaseList) {
      _listenToPurchase(purchaseList, context);
    }, onDone: (){
      _streamSubscription.cancel();
    }, onError: (error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong')));
    });
    _initStore();
    ///////////////////////////
    // End In-App Int Block
    ///////////////////////////

    _audioPlayer = widget.audioPlayer;
    _notificationsPlugin = widget.notifications;
    _duration = widget.workDuration ?? defaultWorkDuration;
    _restDuration = widget.restDuration ?? defaultRestDuration;
    _timerModifierValueAdd = widget.timeModAdd ?? defaultTimeModifyValueAdd;
    _timerModifierValueSub = widget.timeModSub ?? defaultTimeModifyValueSub;
    _appVolume = widget.appVolume ?? defaultVolume;
    _audioPlayer.setVolume(_appVolume);
    _audioPlayer2.setVolume(_appVolume);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _audioPlayer2.dispose();
    audioPlayer.dispose();
    _notificationsPlugin.cancelAll(); // TODO Prolly unnecessary /w the next line
    AwesomeNotifications().cancelAll();
    _streamSubscription.cancel();
    super.dispose();
  }
  
  // Update values to be displayed in settings menu using previous stored settings
  Future<void> updateSettingsFromMemory() async {
    final settings = await getSavedUserSettings();

    setState(() {
      _workTime = int.parse(settings['workDuration']);
      _restTime = int.parse(settings['restDuration']);
      _timerModifierValueAdd = int.parse(settings['timeModifyValueAdd']);
      _timerModifierValueSub = int.parse(settings['timeModifyValueSub']);
      _appVolume = double.parse(settings['appVolume']);
      _audioPlayer.setVolume(_appVolume);
      _audioPlayer2.setVolume(_appVolume);
    });
  }

  Future<void> resetTimer() async {
    final settings = await getSavedUserSettings();
    _duration = int.parse(settings['workDuration']);
    _restDuration = int.parse(settings['restDuration']);

    setState(() {
      _intervalLap = 1;
      _isRunning = false;
      _timerButtonRestart = false;
      _controller.updateWorkoutMode(appCurrentlyInTimerMode);
      _timerInRestMode = false;
    });

    _controller.restart(
      duration: _duration,
      initialPosition: 0,
      restDuration: _restDuration,
    );
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    Wakelock.disable();
  }

  // When the user re-opens their running app, we need to match
  //    the displayed timer with the background timer.
  reestablishRunningTimer(duration, altDuration, inRestMode, lap) {
    setState(() {
      _duration = duration;
      _restDuration = altDuration;
      _timerInRestMode = inRestMode;
      _intervalLap = lap;
    });

    _controller.restart(
      duration: duration,
      initialPosition: 0,
      restDuration: altDuration,
    );
    _controller.resume();
}

  // Change timer from Rest Mode to Work Mode and Vice Versa
  Future<void> flipIntervalTimer(bool restFlip) async {
    final settings = await getSavedUserSettings();
    final int savedWorkDuration = int.parse(settings['workDuration']);
    final int savedRestDuration = int.parse(settings['restDuration']);

    // Rest Flip indicates the duration needs to be set to Rest Duration
    if (restFlip) {
      if (!appCurrentlyMuted && alertRestModeStartedCurrentlyEnabled) {
        _audioPlayer2.play(AssetSource(audioForAlertRestModeStarted));
      }
      _duration = savedRestDuration;
      _restDuration = savedWorkDuration;
    } else {
      if (!appCurrentlyMuted && alertWorkModeStartedCurrentlyEnabled) {
        _audioPlayer2.play(AssetSource(audioForAlertWorkModeStarted));
      }
      _duration = savedWorkDuration;
      _restDuration = savedRestDuration;
      _intervalLap++;
    }

    _controller.restart(
      duration: _duration,
      initialPosition: 0,
      restDuration: _restDuration,
    );
    _controller.resume();
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: secondaryColor,
        statusBarIconBrightness: appCurrentlyInDarkMode ? Brightness.light : Brightness.dark
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      color: Colors.transparent,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: secondaryColor,
          child: Center(
            child: SingleChildScrollView(
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
                  SizedBox(height: 5),
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
                            if (appCurrentlyInTimerMode) {
                              return primaryColor;
                            }
                            return primaryAccentColor; // defer to the defaults
                          },
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();

                        setState(() {
                          /// Launch Extras Menu
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
                                child: AdvancedSettingsMenu(key: advancedSettingsKey)
                              );
                            },
                          ).then((restartRequired) {
                            if (restartRequired == true) {
                              //
                            }
                            setState(() {
                              updateSettingsFromMemory();
                              // _controller.updateWorkoutMode(appCurrentlyInTimerMode);
                            });
                          });
                        });
                      },
                      child: const Text('HIIT Time',
                          style: TextStyle(
                              fontFamily: 'AstroSpace',
                              fontSize: 40,
                              height: 1.1),
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
                            if (!appCurrentlyMuted && restartButtonAudioCurrentlyEnabled) {
                              _audioPlayer.play(AssetSource(audioForRestartButton));
                            }
                            resetTimer();
                            _isRunning = true; // To get into upcoming pause block
                            _timerButtonRestart = false;
                          }

                          setState(() {
                            if (_isRunning) {
                              // Timer was running, going into pause mode
                              _controller.pause();
                              // Update timer text
                              _controller.updateWorkoutMode(appCurrentlyInTimerMode);
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
                          valueColor: _timerInRestMode // Color slice showing time passed
                              ? primaryColor
                              : secondaryColor,
                          initialPosition: 0,
                          audioPlayer: _audioPlayer,
                          notifications: _notificationsPlugin,
                          isRunning: _isRunning,
                          duration: _duration,
                          restDuration: _restDuration,
                          intervalLap: _intervalLap,
                          appInTimerMode: appCurrentlyInTimerMode,
                          timerInRestMode: _timerInRestMode,
                          reestablishRunningTimer: reestablishRunningTimer,
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
                              if (appCurrentlyInTimerMode == false) {
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
                              if (appCurrentlyInTimerMode == true) {
                                // Upon completion in Timer mode,
                                // Enable the next press on the timer button to restart the timer
                                _timerButtonRestart = true;
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
                                _timerModifierValueSub > 59
                                    ? '-${changeDurationFromSecondsToMinutes(_timerModifierValueSub)}'
                                    : '-${_timerModifierValueSub}s',
                                style: TextStyle(fontSize: 20, color: textColorOverwrite ? Colors.black : Colors.white)),
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
                          updateSettingsFromMemory();

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
                                  restTime: _restTime,
                                  timeModAdd: _timerModifierValueAdd,
                                  timeModSub: _timerModifierValueSub,
                                  appVolume: _appVolume,
                                  advancedSettingsKey: advancedSettingsKey
                                ),
                              );
                            },
                          ).then((restartRequired) {
                            if (restartRequired == true) {
                              resetTimer();
                            }
                            setState(() {
                              updateSettingsFromMemory();
                              _controller.updateWorkoutMode(appCurrentlyInTimerMode);
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
                              // _timerModifierValueAdd = _timeModAdd;

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
                                _timerModifierValueAdd > 59
                                    ? '+${changeDurationFromSecondsToMinutes(_timerModifierValueAdd)}'
                                    : '+${_timerModifierValueAdd}s',
                                style: TextStyle(fontSize: 20, color: textColorOverwrite ? Colors.black : Colors.white)
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  // Spacer between config and restart buttons
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
                              if (!appCurrentlyMuted && restartButtonAudioCurrentlyEnabled) {
                                _audioPlayer.play(AssetSource(audioForRestartButton));
                              }
                              resetTimer();
                            }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryAccentColor,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(4),
                        ),
                        child: Icon(Icons.autorenew, size: 75, color: alternateColorOverwrite ? Colors.black : Colors.white
                        )),
                  ),

                  // Bottom Spacing
                  const SizedBox(height: 30),
                ],
              ),
            ) // ScrollView... disabled for now
          ),
        ),
      ),
    );
  }
}
