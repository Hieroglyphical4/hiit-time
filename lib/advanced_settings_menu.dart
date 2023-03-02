import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Config/settings.dart';

// This is the Parent Widget from which other settings menus are opened
class AdvancedSettingsMenu extends StatefulWidget {

  const AdvancedSettingsMenu({
    required Key key,
  }) : super(key: key);

  @override
  _AdvancedSettingsMenuState createState() => _AdvancedSettingsMenuState();
}

class _AdvancedSettingsMenuState extends State<AdvancedSettingsMenu> {
  final _formKey = GlobalKey<FormState>();
  bool _displayAudioSettings = false;
  bool _displayThemesSettings = false;

  Future<bool> _confirmRestoreDefaults() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm",
            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 16, height: 1.1),
          ),
          content: const Text("Are you sure you want to restore all settings to their default?",
            style: TextStyle(fontSize: 14, height: 1.1),
          ),
          actions: [
            ElevatedButton(
              child: const Text("Cancel",
                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: const Text("Confirm",
                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Advanced Settings'),
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
          Navigator.pop(context);
          },
          ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              // direction: Axis.vertical,
              children: [
                // Body of Settings!
                const SizedBox(height: 115),

                ///////////////////////////
                // Audio Settings Button
                ///////////////////////////
                SizedBox(
                  height: 60,
                  width: 350,
                  child: ElevatedButton(
                      onPressed: () => setState(() {
                        if (_displayAudioSettings) {
                          _displayAudioSettings = false;
                        } else {
                          _displayAudioSettings = true;
                          _displayThemesSettings = false;
                        }
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryAccentColor,
                        // shape: Rectangle(),
                        padding: const EdgeInsets.all(4),
                      ),
                      child: Text(_displayAudioSettings
                          ? 'Audio Settings'
                          : 'Audio Settings    >',
                          style: const TextStyle(fontFamily: 'AstroSpace', fontSize: 25, height: 1.1),
                          textAlign: TextAlign.center
                      )
                  )
                ),

                // Determine if Audio Settings Widget should show:
                _displayAudioSettings
                  ? AudioSettingsWidget()
                  : Container(),

                const SizedBox(height: 20),

                ///////////////////////////
                // Theme Settings Button
                ///////////////////////////
                SizedBox(
                    height: 60,
                    width: 350,
                    child: ElevatedButton(
                        onPressed: () => setState(() {
                          if (_displayThemesSettings) {
                            _displayThemesSettings = false;
                          } else {
                            _displayThemesSettings = true;
                            _displayAudioSettings = false;
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryAccentColor,
                          // shape: Rectangle(),
                          padding: const EdgeInsets.all(4),
                        ),
                        child: Text(_displayThemesSettings
                            ? 'Themes'
                            : 'Themes                   >',
                            style: const TextStyle(fontFamily: 'AstroSpace', fontSize: 25, height: 1.1),
                            textAlign: TextAlign.center)
                    )
                ),

                // Determine if Themes Widget should show:
                _displayThemesSettings
                  ? const ThemeSettingsWidget()
                  : Container(),

                // Spacer between Theme Button and Restore Defaults
                _displayAudioSettings || _displayThemesSettings
                    ? const SizedBox(height: 150)
                    : const SizedBox(height: 300),

                ///////////////////////////
                // Restore Defaults Button
                ///////////////////////////
                SizedBox(
                    height: 50,
                    width: 350,
                    child: ElevatedButton(
                        onPressed: () {
                          _confirmRestoreDefaults().then((confirmed) {
                            if (confirmed) {
                              // Call Settings.dart method to remove all stored variables
                              clearUserSettings();

                              // Close this menu and return true to tell the settings menu
                              // to also close and restart the timer, leaving the user
                              // at the main/timer screen with default settings
                              Navigator.pop(context, true);
                            }
                          });
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          // shape: Rectangle(),
                          padding: const EdgeInsets.all(4),
                        ),
                        child: const Text('Restore Defaults',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 25, height: 1.1),
                            textAlign: TextAlign.center)
                    )
                ),

                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////
// Widget for all Theme related Settings (submenu)
////////////////////////////////////////////
class ThemeSettingsWidget extends StatefulWidget {
  const ThemeSettingsWidget({super.key});

  @override
  ThemeSettingsWidgetState createState() => ThemeSettingsWidgetState();
}

class ThemeSettingsWidgetState extends State<ThemeSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        const SizedBox(height: 55),
        Text('Coming Soon!',
          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 40, color: primaryAccentColor, height: 1.1),
          textAlign: TextAlign.center),
        const SizedBox(height: 55),
      ])
    );
  }
}

////////////////////////////////////////////
// Widget for all Audio related Settings (submenu)
////////////////////////////////////////////
class AudioSettingsWidget extends StatefulWidget {

  const AudioSettingsWidget({
    super.key,
  });

  @override
  AudioSettingsWidgetState createState() => AudioSettingsWidgetState();
}

class AudioSettingsWidgetState extends State<AudioSettingsWidget> {
  bool _displayTimerAudioSettings = false;
  bool _displayButtonAudioSettings = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 20),
        /////////////////////////
        // Timer Submenu Button
        /////////////////////////
        SizedBox(
          height: 45,
          width: 350,
          child: ElevatedButton(
              onPressed: () => setState(() {
                if (_displayTimerAudioSettings) {
                  _displayTimerAudioSettings = false;
                } else {
                  _displayTimerAudioSettings = true;
                }
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding: const EdgeInsets.all(4),
              ),
              child: Row(
                children: [
                  _displayTimerAudioSettings
                    ? SizedBox(width: 100)
                    : SizedBox(width: 10),
                  const Icon(Icons.watch_later_outlined),
                  const SizedBox(width: 10),
                  Text(_displayTimerAudioSettings
                    ? 'Timer'
                    : '  Timer                                 >',
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1, color: primaryColor))
                ],
              ),
          )
        ),

        // Determine if Timer Audio Submenu Widget should show:
        _displayTimerAudioSettings
            ? TimerAudioSettingsWidget()
            : Container(),

        const SizedBox(height: 10),
        SizedBox(height: 1, child: Container(color: Colors.grey)),
        const SizedBox(height: 10),

        ////////////////////////////
        // Buttons Submenu Button
        ////////////////////////////
        SizedBox(
          height: 45,
          width: 350,
          child: ElevatedButton(
              onPressed: () => setState(() {
                if (_displayButtonAudioSettings) {
                  _displayButtonAudioSettings = false;
                } else {
                  _displayButtonAudioSettings = true;
                }
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding: const EdgeInsets.all(4),
              ),
              child: Row(
                children: [
                  _displayButtonAudioSettings
                      ? SizedBox(width: 100)
                      : SizedBox(width: 10),
                  const Icon(Icons.touch_app_outlined),
                  const SizedBox(width: 10),
                  Text(_displayButtonAudioSettings
                  ? 'Buttons'
                      : '  Buttons                           >',
                  style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1, color: primaryColor),
                  ),
                ],              )
          )
        ),

        // Determine if Timer Audio Submenu Widget should show:
        _displayButtonAudioSettings
            ? const ButtonAudioSettingsWidget()
            : Container(),

        const SizedBox(height: 20),
        SizedBox(height: 1, child: Container(color: Colors.grey)),
      ],
    );
  }
}

////////////////////////////////////////////////
// Widget for all Timer Audio related Settings (sub-submenu)
////////////////////////////////////////////////
class TimerAudioSettingsWidget extends StatefulWidget {

  const TimerAudioSettingsWidget({
    super.key,
  });

  @override
  TimerAudioSettingsWidgetState createState() => TimerAudioSettingsWidgetState();
}

class TimerAudioSettingsWidgetState extends State<TimerAudioSettingsWidget> {
  final double _textFontSize = 18;

  void _onTimerAlarmChanged(bool value) {
    setState(() {
      if (timerAlarmCurrentlyEnabled) {
        // Call settings.dart Setter
        setBooleanSetting('timerAlarmEnabled', false);
        timerAlarmCurrentlyEnabled = false;
      } else {
        // Call settings.dart Setter
        setBooleanSetting('timerAlarmEnabled', true);
        timerAlarmCurrentlyEnabled = true;
      }
    });
  }

  void _on321CountdownChanged(bool value) {
    setState(() {
      if (threeTwoOneCountdownCurrentlyEnabled) {
        setBooleanSetting('threeTwoOneCountdownEnabled', false);
        threeTwoOneCountdownCurrentlyEnabled = false;
      } else {
        setBooleanSetting('threeTwoOneCountdownEnabled', true);
        threeTwoOneCountdownCurrentlyEnabled = true;
      }
    });
  }

  void _onTenSecondWarningChanged(bool value) {
    setState(() {
      if (tenSecondWarningCurrentlyEnabled) {
        setBooleanSetting('tenSecondWarningEnabled', false);
        tenSecondWarningCurrentlyEnabled = false;
      } else {
        setBooleanSetting('tenSecondWarningEnabled', true);
        tenSecondWarningCurrentlyEnabled = true;
      }
    });
  }

  void _onWorkModeAlertSwitchChanged(bool value) {
    setState(() {
      if (alertWorkModeStartedCurrentlyEnabled) {
        setBooleanSetting('alertWorkModeStartedEnabled', false);
        alertWorkModeStartedCurrentlyEnabled = false;
      } else {
        setBooleanSetting('alertWorkModeStartedEnabled', true);
        alertWorkModeStartedCurrentlyEnabled = true;
      }
    });
  }

  void _onRestModeAlertSwitchChanged(bool value) {
    setState(() {
      if (alertRestModeStartedCurrentlyEnabled) {
        setBooleanSetting('alertRestModeStartedEnabled', false);
        alertRestModeStartedCurrentlyEnabled = false;
      } else {
        setBooleanSetting('alertRestModeStartedEnabled', true);
        alertRestModeStartedCurrentlyEnabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          /////////////////////////////
          // Timer Alarm Settings
          /////////////////////////////
          Row(
            children: [
              const SizedBox(width: 30),
              Text('Timer Alarm',
                  style: TextStyle(
                      color: timerAlarmCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),

              IconButton(
                iconSize: 35,
                color: timerAlarmCurrentlyEnabled
                    ? primaryColor
                    : Colors.grey,
                icon: const Icon(Icons.audio_file_outlined),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Launch Audio Changer menu
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
                        child: AudioChangerMenuWidget(
                          parentWidget: 'Timer Alarm',
                          options: timerAlarmAssetMap.values.toList(),
                        ),
                      );
                    },
                  ).then((restartRequired) {
                    setState(() {
                      //
                    });
                  });
                },
              ),

              const SizedBox(width: 15),

              Switch(
                value: timerAlarmCurrentlyEnabled,
                onChanged: _onTimerAlarmChanged,
              ),
              const SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          /////////////////////////////
          // 3-2-1 Countdown Settings
          /////////////////////////////
          Row(
            children: [
              const SizedBox(width: 30),
              Text('3-2-1 Countdown',
                  style: TextStyle(
                      color: threeTwoOneCountdownCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),

              IconButton(
                iconSize: 35,
                color: threeTwoOneCountdownCurrentlyEnabled
                    ? primaryColor
                    : Colors.grey,
                icon: const Icon(Icons.audio_file_outlined),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Launch Audio Changer menu
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
                        child: AudioChangerMenuWidget(
                          parentWidget: '3-2-1 Countdown',
                          options: threeTwoOneCountdownAssetMap.values.toList(),
                        ),
                      );
                    },
                  ).then((restartRequired) {
                    setState(() {
                      //
                    });
                  });
                },
              ),

              const SizedBox(width: 15),

              Switch(
                value: threeTwoOneCountdownCurrentlyEnabled,
                onChanged: _on321CountdownChanged,
              ),
              const SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          /////////////////////////////
          // 10 Second Warning Settings
          /////////////////////////////
          Row(
            children: [
              const SizedBox(width: 30),
              Text('10 Second Warning',
                  style: TextStyle(
                      color: tenSecondWarningCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),
              IconButton(
                iconSize: 35,
                color: tenSecondWarningCurrentlyEnabled
                    ? primaryColor
                    : Colors.grey,
                icon: const Icon(Icons.audio_file_outlined),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Launch Audio Changer menu
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
                        child: AudioChangerMenuWidget(
                          parentWidget: '10 Second Warning',
                          options: tenSecondWarningAssetMap.values.toList(),
                        ),
                      );
                    },
                  ).then((restartRequired) {
                    setState(() {
                      //
                    });
                  });
                },
              ),

              const SizedBox(width: 15),
              Switch(
                value: tenSecondWarningCurrentlyEnabled,
                onChanged: _onTenSecondWarningChanged,
              ),
              const SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),
          ///////////////////////////////
          // Mode Switch Alert: Work Audio Settings
          //////////////////////////////
          Row(
            children: [
              const SizedBox(width: 30),
              Text('Alert for Work Mode',
                  style: TextStyle(
                      color: alertWorkModeStartedCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),
              IconButton(
                iconSize: 35,
                color: alertWorkModeStartedCurrentlyEnabled
                    ? primaryColor
                    : Colors.grey,
                icon: const Icon(Icons.audio_file_outlined),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Launch Audio Changer menu
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
                        child: AudioChangerMenuWidget(
                          parentWidget: 'Alert for Work Mode',
                          options: alertWorkModeStartedAssetMap.values.toList(),
                        ),
                      );
                    },
                  ).then((restartRequired) {
                    setState(() {
                      //
                    });
                  });
                },
              ),

              const SizedBox(width: 15),
              Switch(
                value: alertWorkModeStartedCurrentlyEnabled,
                onChanged: _onWorkModeAlertSwitchChanged,
              ),
              const SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          ///////////////////////////////
          // Mode Switch Alert: Rest Audio Settings
          //////////////////////////////
          Row(
            children: [
              const SizedBox(width: 30),

              Text('Alert for Rest Mode',
                  style: TextStyle(
                      color: alertRestModeStartedCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),
              IconButton(
                iconSize: 35,
                color: alertRestModeStartedCurrentlyEnabled
                    ? primaryColor
                    : Colors.grey,
                icon: const Icon(Icons.audio_file_outlined),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Launch Audio Changer menu
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
                        child: AudioChangerMenuWidget(
                          parentWidget: 'Alert for Rest Mode',
                          options: alertRestModeStartedAssetMap.values.toList(),
                        ),
                      );
                    },
                  ).then((restartRequired) {
                    setState(() {
                      //
                    });
                  });
                },
              ),

              const SizedBox(width: 15),
              Switch(
                value: alertRestModeStartedCurrentlyEnabled,
                onChanged: _onRestModeAlertSwitchChanged,
              ),
              const SizedBox(width: 10),
            ],
          ),

        ]
    );
  }
}

////////////////////////////////////////////////
// Widget for all Button Audio related Settings (sub-submenu)
////////////////////////////////////////////////
class ButtonAudioSettingsWidget extends StatefulWidget {
  const ButtonAudioSettingsWidget({super.key});

  @override
  ButtonAudioSettingsWidgetState createState() => ButtonAudioSettingsWidgetState();
}

class ButtonAudioSettingsWidgetState extends State<ButtonAudioSettingsWidget> {
  final double _textFontSize = 18;


  void _onRestartButtonAudioChanged(bool value) {
    setState(() {
      if (restartButtonAudioCurrentlyEnabled) {
        setBooleanSetting('restartButtonAudioEnabled', false);
        restartButtonAudioCurrentlyEnabled = false;
      } else {
        setBooleanSetting('restartButtonAudioEnabled', true);
        restartButtonAudioCurrentlyEnabled = true;
      }
    });
  }

  void _onSaveButtonAudioChanged(bool value) {
    setState(() {
      if (saveButtonAudioCurrentlyEnabled) {
        setBooleanSetting('saveButtonAudioEnabled', false);
        saveButtonAudioCurrentlyEnabled = false;
      } else {
        setBooleanSetting('saveButtonAudioEnabled', true);
        saveButtonAudioCurrentlyEnabled = true;
      }
    });
  }

  void _onCancelButtonAudioChanged(bool value) {
    setState(() {
      if (cancelButtonAudioCurrentlyEnabled) {
        setBooleanSetting('cancelButtonAudioEnabled', false);
        cancelButtonAudioCurrentlyEnabled = false;
      } else {
        setBooleanSetting('cancelButtonAudioEnabled', true);
        cancelButtonAudioCurrentlyEnabled = true;
      }
    });
  }

  void _onSwitchButtonAudioChanged(bool value) {
    setState(() {
      if (switchButtonAudioCurrentlyEnabled) {
        setBooleanSetting('switchButtonAudioEnabled', false);
        switchButtonAudioCurrentlyEnabled = false;
      } else {
        setBooleanSetting('switchButtonAudioEnabled', true);
        switchButtonAudioCurrentlyEnabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          ////////////////////////
          // Restart Button Audio
          ////////////////////////
          Row(
            children: [
              const SizedBox(width: 30),
              Text('Restart Button Audio',
                  style: TextStyle(
                      color: restartButtonAudioCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),

              Switch(
                value: restartButtonAudioCurrentlyEnabled,
                onChanged: _onRestartButtonAudioChanged,
              ),
              const SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          ///////////////////////
          // Save Button Audio
          ///////////////////////
          Row(
            children: [
              const SizedBox(width: 30),
              Text('Save Button Audio',
                  style: TextStyle(
                      color: saveButtonAudioCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),

              Switch(
                value: saveButtonAudioCurrentlyEnabled,
                onChanged: _onSaveButtonAudioChanged,
              ),
              const SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          /////////////////////////
          // Cancel Button Audio
          /////////////////////////
          Row(
            children: [
              const SizedBox(width: 30),
              Text('Cancel Button Audio',
                  style: TextStyle(
                      color: cancelButtonAudioCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),

              Switch(
                value: cancelButtonAudioCurrentlyEnabled,
                onChanged: _onCancelButtonAudioChanged,
              ),
              const SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          /////////////////////////
          // Switch Button Audio
          /////////////////////////
          Row(
            children: [
              const SizedBox(width: 30),
              Text('Switch Button Audio',
                  style: TextStyle(
                      color: switchButtonAudioCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),

              Switch(
                value: switchButtonAudioCurrentlyEnabled,
                onChanged: _onSwitchButtonAudioChanged,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ]
    );
  }
}


////////////////////////////////////////////////
// Widget to handle Changing Audio Settings (Overlay menu)
////////////////////////////////////////////////
class AudioChangerMenuWidget extends StatefulWidget {
  final parentWidget;
  final List<String> options;

  const AudioChangerMenuWidget({
    super.key,
    required this.parentWidget,
    required this.options,
  });

  @override
  AudioChangerMenuWidgetState createState() => AudioChangerMenuWidgetState();
}

class AudioChangerMenuWidgetState extends State<AudioChangerMenuWidget> {
  late String _parentWidget = '';
  late List<String> _options;
  String? _selectedOption;
  final _audioPlayer = AudioPlayer();


  @override
  void initState() {
    super.initState();
    _parentWidget = widget.parentWidget;
    _options = widget.options;
    setupForParentWidget();
    _audioPlayer.setVolume(appCurrentVolume);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void setupForParentWidget() {
    switch (_parentWidget) {
      case 'Timer Alarm':
        _selectedOption = timerAlarmAssetMap[audioForTimerAlarm];
        break;
      case '3-2-1 Countdown':
        _selectedOption = threeTwoOneCountdownAssetMap[audioForAssembledCountdown];
        break;
      case '10 Second Warning':
        _selectedOption = tenSecondWarningAssetMap[audioForTimerCountdownAtTen];
        break;
      case 'Alert for Work Mode':
        _selectedOption = alertWorkModeStartedAssetMap[audioForAlertWorkModeStarted];
        break;
      case 'Alert for Rest Mode':
        _selectedOption = alertRestModeStartedAssetMap[audioForAlertRestModeStarted];
        break;
    }
  }

  // TODO Update this method to accept the _selectedOption
  String getAudioAssetFromMap() {
    switch (_parentWidget) {
      case 'Timer Alarm':
        for (var entry in timerAlarmAssetMap.entries) {
          if (entry.value == _selectedOption) {
            return entry.key;
          }
        }
        return '';

      case '3-2-1 Countdown':
        for (var entry in threeTwoOneCountdownAssetMap.entries) {
          if (entry.value == _selectedOption) {
            return entry.key;
          }
        }
        return '';

      case '10 Second Warning':
        for (var entry in tenSecondWarningAssetMap.entries) {
          if (entry.value == _selectedOption) {
            return entry.key;
          }
        }
        return '';

      case 'Alert for Work Mode':
        for (var entry in alertWorkModeStartedAssetMap.entries) {
          if (entry.value == _selectedOption) {
            return entry.key;
          }
        }
        return '';

      case 'Alert for Rest Mode':
        for (var entry in alertRestModeStartedAssetMap.entries) {
          if (entry.value == _selectedOption) {
            return entry.key;
          }
        }
        return '';

      default:
        throw Exception('Invalid Asset Provided');
    }
  }

  void setChosenAudioAsset(String desiredAsset) {
    switch (_parentWidget) {
      case 'Timer Alarm':
        audioForTimerAlarm = desiredAsset;
        setStringSetting('audioTimerAlarm', desiredAsset);
        break;
      case '3-2-1 Countdown':
        List<String> assetsSplit = desiredAsset.split(",");
        setStringSetting('audioTimerCountdownAtThree', assetsSplit[0]);
        setStringSetting('audioTimerCountdownAtTwo', assetsSplit[1]);
        setStringSetting('audioTimerCountdownAtOne', assetsSplit[2]);
        audioForAssembledCountdown = desiredAsset;
        setStringSetting('audioAssembledCountdown', desiredAsset);
        break;
      case '10 Second Warning':
        audioForTimerCountdownAtTen = desiredAsset;
        setStringSetting('audioTimerCountdownAtTen', desiredAsset);
        break;

      case 'Alert for Work Mode':
        audioForAlertWorkModeStarted = desiredAsset;
        setStringSetting('audioAlertWorkModeStarted', desiredAsset);
        break;

      case 'Alert for Rest Mode':
        audioForAlertRestModeStarted = desiredAsset;
        setStringSetting('audioAlertRestModeStarted', desiredAsset);
        break;
    }
  }

  void playAudioWithDelay(String desiredAsset) async {
    List<String> assetsSplit = desiredAsset.split(",");
    _audioPlayer.play(AssetSource(assetsSplit[0]));
    await Future.delayed(const Duration(seconds: 1));
    _audioPlayer.play(AssetSource(assetsSplit[1]));
    await Future.delayed(const Duration(seconds: 1));
    _audioPlayer.play(AssetSource(assetsSplit[2]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_parentWidget,
          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 35, height: 1.1),
        ),

        // Dynamically create rows
        ListView.builder(
          shrinkWrap: true,
          itemCount: _options.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOption = _options[index];
                      var desiredAsset = getAudioAssetFromMap();
                      setChosenAudioAsset(desiredAsset);

                      if (_parentWidget == '3-2-1 Countdown') {
                        // We need to break the desired asset down into 3 with spaces
                        playAudioWithDelay(desiredAsset);
                      } else {
                        // There is only one asset to play:
                        _audioPlayer.play(AssetSource(desiredAsset));
                      }
                    });
                  },
                  child: ListTile(
                    title: Text(_options[index]),
                    leading: Radio<String>(
                      value: _options[index],
                      groupValue: _selectedOption,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedOption = value;
                          var desiredAsset = getAudioAssetFromMap();
                          setChosenAudioAsset(desiredAsset);

                          // if (_parentWidget == '3-2-1 Countdown') {
                          //   // We need to break the desired asset down into 3 with spaces
                          //   playAudioWithDelay(desiredAsset);
                          // } else {
                          //   // There is only one asset to play:
                          //   _audioPlayer.play(AssetSource(desiredAsset));
                          // }
                        });
                      },
                    ),
                  )
                ),
            );
          },
        ),
      ],
    );
  }
}