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

  void _on321CountdownChanged(bool value) {
    setState(() {
      if (threeTwoOneCountdownEnabled) {
        threeTwoOneCountdownEnabled = false;
      } else {
        threeTwoOneCountdownEnabled = true;
      }

    });
  }

  void _onModeSwitchAudioChanged(bool value) {
    setState(() {
      if (modeSwitchAudioEnabled) {
        modeSwitchAudioEnabled = false;
      } else {
        modeSwitchAudioEnabled = true;
      }

    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
      title: Text('Advanced Settings'),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
        Navigator.pop(context);
        },
        ),
      ),
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
                      const SizedBox(height: 35),
                      /////////////////////////////
                      // 3-2-1 Countdown Settings
                      /////////////////////////////
                      Row(
                        children: [
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

                      const SizedBox(height: 35),
                      ///////////////////////////////
                      // Mode Switch Audio Settings
                      //////////////////////////////
                      Row(
                        children: [
                          Text('Mode Switch Audio',
                              style: TextStyle(
                                  color: modeSwitchAudioEnabled
                                    ? primaryColor
                                    : Colors.grey,
                                  fontFamily: 'AstroSpace',
                                  fontSize: 20,
                                  height: 1.1),
                              textAlign: TextAlign.center),
                          Spacer(),
                          Switch(
                            value: modeSwitchAudioEnabled,
                            onChanged: _onModeSwitchAudioChanged,
                          ),

                        ],
                      ),

                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}