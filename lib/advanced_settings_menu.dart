import 'dart:math';

import 'package:flutter/material.dart';

import 'Config/settings.dart';

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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Advanced Settings'),
          leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                SizedBox(height: 5),

                ///////////////////////////
                // Audio Settings Button
                ///////////////////////////
                SizedBox(
                  height: 90,
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
                        padding: EdgeInsets.all(4),
                      ),
                      child: Text(_displayAudioSettings
                          ? 'Audio Settings'
                          : '- Audio Settings -',
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 30, height: 1.1),
                          textAlign: TextAlign.center))),

                // Determine if Audio Settings Widget should show:
                _displayAudioSettings
                  ? AudioSettingsWidget()
                  : Container(),

                SizedBox(height: 20),

                ///////////////////////////
                // Theme Settings Button
                ///////////////////////////
                SizedBox(
                    height: 90,
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
                          padding: EdgeInsets.all(4),
                        ),
                        child: Text(_displayThemesSettings
                            ? 'Themes'
                            : '- Themes -',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 30, height: 1.1),
                            textAlign: TextAlign.center))),
                // Determine if Themes Widget should show:
                _displayThemesSettings
                  ? ThemeSettingsWidget()
                  : Container(),

                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////
// Widget for all Theme related Settings
////////////////////////////////////////////
class ThemeSettingsWidget extends StatefulWidget {
  const ThemeSettingsWidget({super.key});

  @override
  ThemeSettingsWidgetState createState() => ThemeSettingsWidgetState();
}

class ThemeSettingsWidgetState extends State<ThemeSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text('Hello World!',
        style: TextStyle(fontFamily: 'AstroSpace', fontSize: 40, color: primaryAccentColor, height: 1.1),
        textAlign: TextAlign.center),
      SizedBox(height: 400,),
    ]);
  }
}

////////////////////////////////////////////
// Widget for all Audio related Settings
////////////////////////////////////////////
class AudioSettingsWidget extends StatefulWidget {
  const AudioSettingsWidget({super.key});

  @override
  AudioSettingsWidgetState createState() => AudioSettingsWidgetState();
}

class AudioSettingsWidgetState extends State<AudioSettingsWidget> {
  void _onTimerAlarmChanged(bool value) {
    setState(() {
      if (timerAlarmEnabled) {
        timerAlarmEnabled = false;
      } else {
        timerAlarmEnabled = true;
      }
    });
  }

  void _on321CountdownChanged(bool value) {
    setState(() {
      if (threeTwoOneCountdownEnabled) {
        threeTwoOneCountdownEnabled = false;
      } else {
        threeTwoOneCountdownEnabled = true;
      }
    });
  }

  void _onModeSwitchAlertChanged(bool value) {
    setState(() {
      if (modeSwitchAlertEnabled) {
        modeSwitchAlertEnabled = false;
      } else {
        modeSwitchAlertEnabled = true;
      }
    });
  }

  void _onSaveButtonAudioChanged(bool value) {
    setState(() {
      if (saveButtonAudioEnabled) {
        saveButtonAudioEnabled = false;
      } else {
        saveButtonAudioEnabled = true;
      }
    });
  }

  void _onCancelButtonAudioChanged(bool value) {
    setState(() {
      if (cancelButtonAudioEnabled) {
        cancelButtonAudioEnabled = false;
      } else {
        cancelButtonAudioEnabled = true;
      }
    });
  }

  void _onRestartButtonAudioChanged(bool value) {
    setState(() {
      if (restartButtonAudioEnabled) {
        restartButtonAudioEnabled = false;
      } else {
        restartButtonAudioEnabled = true;
      }
    });
  }

  void _onSwitchButtonAudioChanged(bool value) {
    setState(() {
      if (switchButtonAudioEnabled) {
        switchButtonAudioEnabled = false;
      } else {
        switchButtonAudioEnabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 20),
        /////////////////////////////
        // Timer Alarm Settings
        /////////////////////////////
        Row(
          children: [
            const SizedBox(width: 20),

            Text('Timer Alarm',
                style: TextStyle(
                    color: timerAlarmEnabled
                        ? primaryColor
                        : Colors.grey,
                    fontFamily: 'AstroSpace',
                    fontSize: 20,
                    height: 1.1),
                textAlign: TextAlign.center),

            Spacer(),

            Switch(
              value: timerAlarmEnabled,
              onChanged: _onTimerAlarmChanged,
            ),
          ],
        ),

        const SizedBox(height: 20),
        SizedBox(height: 1, child: Container(color: Colors.grey)),
        const SizedBox(height: 20),

        /////////////////////////////
        // 3-2-1 Countdown Settings
        /////////////////////////////
        Row(
          children: [
            const SizedBox(width: 20),

            Text('3-2-1 Countdown',
                style: TextStyle(
                    color: threeTwoOneCountdownEnabled
                        ? primaryColor
                        : Colors.grey,
                    fontFamily: 'AstroSpace',
                    fontSize: 20,
                    height: 1.1),
                textAlign: TextAlign.center),

            Spacer(),

            Switch(
              value: threeTwoOneCountdownEnabled,
              onChanged: _on321CountdownChanged,
            ),
          ],
        ),

        const SizedBox(height: 20),
        SizedBox(height: 1, child: Container(color: Colors.grey)),
        const SizedBox(height: 20),
        ///////////////////////////////
        // Mode Switch Audio Settings
        //////////////////////////////
        Row(
          children: [
            const SizedBox(width: 20),

            Text('Mode Switch Alert',
                style: TextStyle(
                    color: modeSwitchAlertEnabled
                        ? primaryColor
                        : Colors.grey,
                    fontFamily: 'AstroSpace',
                    fontSize: 20,
                    height: 1.1),
                textAlign: TextAlign.center),

            Spacer(),

            Switch(
              value: modeSwitchAlertEnabled,
              onChanged: _onModeSwitchAlertChanged,
            ),

          ],
        ),

        const SizedBox(height: 20),
        SizedBox(height: 1, child: Container(color: Colors.grey)),
        const SizedBox(height: 20),

        ////////////////////////
        // Restart Button Audio
        ////////////////////////
        Row(
          children: [
            const SizedBox(width: 20),

            Text('Restart Button Audio',
                style: TextStyle(
                    color: restartButtonAudioEnabled
                        ? primaryColor
                        : Colors.grey,
                    fontFamily: 'AstroSpace',
                    fontSize: 20,
                    height: 1.1),
                textAlign: TextAlign.center),

            Spacer(),

            Switch(
              value: restartButtonAudioEnabled,
              onChanged: _onRestartButtonAudioChanged,
            ),

          ],
        ),

        const SizedBox(height: 20),
        SizedBox(height: 1, child: Container(color: Colors.grey)),
        const SizedBox(height: 20),

        ///////////////////////
        // Save Button Audio
        ///////////////////////
        Row(
          children: [
            const SizedBox(width: 20),
            Text('Save Button Audio',
                style: TextStyle(
                    color: saveButtonAudioEnabled
                        ? primaryColor
                        : Colors.grey,
                    fontFamily: 'AstroSpace',
                    fontSize: 20,
                    height: 1.1),
                textAlign: TextAlign.center),

            Spacer(),

            Switch(
              value: saveButtonAudioEnabled,
              onChanged: _onSaveButtonAudioChanged,
            ),
          ],
        ),

        const SizedBox(height: 20),
        SizedBox(height: 1, child: Container(color: Colors.grey)),
        const SizedBox(height: 20),

        /////////////////////////
        // Cancel Button Audio
        /////////////////////////
        Row(
          children: [
            const SizedBox(width: 20),

            Text('Cancel Button Audio',
                style: TextStyle(
                    color: cancelButtonAudioEnabled
                        ? primaryColor
                        : Colors.grey,
                    fontFamily: 'AstroSpace',
                    fontSize: 20,
                    height: 1.1),
                textAlign: TextAlign.center),

            Spacer(),

            Switch(
              value: cancelButtonAudioEnabled,
              onChanged: _onCancelButtonAudioChanged,
            ),

          ],
        ),

        const SizedBox(height: 20),
        SizedBox(height: 1, child: Container(color: Colors.grey)),
        const SizedBox(height: 20),

        /////////////////////////
        // Switch Button Audio
        /////////////////////////
        Row(
          children: [
            const SizedBox(width: 20),

            Text('Switch Button Audio',
                style: TextStyle(
                    color: switchButtonAudioEnabled
                        ? primaryColor
                        : Colors.grey,
                    fontFamily: 'AstroSpace',
                    fontSize: 20,
                    height: 1.1),
                textAlign: TextAlign.center),

            Spacer(),

            Switch(
              value: switchButtonAudioEnabled,
              onChanged: _onSwitchButtonAudioChanged,
            ),
          ],
        ),

        const SizedBox(height: 20),
        SizedBox(height: 1, child: Container(color: Colors.grey)),
        const SizedBox(height: 20),
      ],
    );
  }
}