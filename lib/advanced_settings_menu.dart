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

  void _onModeSwitchAlertChanged(bool value) {
    setState(() {
      if (modeSwitchAlertEnabled) {
        modeSwitchAlertEnabled = false;
      } else {
        modeSwitchAlertEnabled = true;
      }

    });
  }

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
            child: Flex(
              direction: Axis.vertical,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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

                    const SizedBox(height: 500),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}