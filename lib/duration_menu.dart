import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Config/settings.dart';

void main() {
  runApp(MaterialApp(
      home: DurationMenu(
    key: UniqueKey(),
  )));
}

class _TextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // print('\n');
    // print('\n');
    // print('oldvalue');
    // print(oldValue);
    // print('\n');
    //
    // print('\n');
    // print('\n');
    // print('newValue');
    // print(newValue);
    // print('\n');

    // if (newValue.text.length == 1) {
    //   return TextEditingValue(
    //     text: '${newValue.text}',
    //     selection: TextSelection.collapsed(offset: 3),
    //   );
    // }
    //
    // if (newValue.text.length == 2) {
    //   return TextEditingValue(
    //     text: '${newValue.text}',
    //     selection: TextSelection.collapsed(offset: 3),
    //   );
    // }
    // if (newValue.text.length == 3) {
    //   return TextEditingValue(
    //     text: '${oldValue}${newValue.text}',
    //     selection: TextSelection.collapsed(offset: 3),
    //   );
    // }
    // if (newValue.text.length == 4) {
    //   return TextEditingValue(
    //     text: '${oldValue}${newValue.text}',
    //     selection: TextSelection.collapsed(offset: 3),
    //   );
    // }

    return newValue;
  }
}

class DurationMenu extends StatefulWidget {
  DurationMenu({required Key key}) : super(key: key);

  @override
  _DurationMenuState createState() => _DurationMenuState();
}

class _DurationMenuState extends State<DurationMenu> {
  final _formKey = GlobalKey<FormState>();

  // textformfield variables
  late String _desiredRestTimeDuration;
  String _desiredWorkTimeDuration = '';
  late String _desiredSubTimeMod;
  late String _desiredAddTimeMod;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      resizeToAvoidBottomInset: true,
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
                          const SizedBox(height: 30),
                          ////////////////////////////////
                          // Quick Settings Text Header  /
                          ////////////////////////////////
                          // TODO Make clickable to access advanced settings
                          Container(
                              height: 60,
                              child: const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Quick Settings',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))),

                          const SizedBox(height: 40),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  ////////////////////////
                                  // Rest Input field  ///
                                  ////////////////////////

                                  SizedBox(
                                    width: 80,
                                    child: (TextFormField(
                                      focusNode: FocusNode(),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        _desiredRestTimeDuration = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: setRestDuration.toString(),
                                        hintStyle: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          gapPadding: 1.0,
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                        _TextInputFormatter(),
                                      ], // Only numbers can be entered
                                    )),
                                  ),
                                  const Text(
                                    'Rest',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  ////////////////////////////////
                                  // Spacer between Rest and Work
                                  ////////////////////////////////
                                  const SizedBox(height: 50),

                                  ///////////////////////
                                  // Work input Field  //
                                  ///////////////////////
                                  SizedBox(
                                    width: 115,
                                    child: (TextFormField(
                                      focusNode: FocusNode(),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        _desiredWorkTimeDuration = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: setStartTime.toString(),
                                        hintStyle: const TextStyle(
                                            fontSize: 45, color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          gapPadding: 1.0,
                                        ),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                        _TextInputFormatter(),
                                      ], // Only numbers can be entered
                                    )),
                                  ),
                                  const Text(
                                    'Work',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                          ////////////////////////////////
                          // Spacer between Save button and timer settings
                          ////////////////////////////////
                          const SizedBox(height: 80),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 50),
                            ],
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ///////////////////////////
                                      // - Time input field  ////
                                      ///////////////////////////
                                      SizedBox(
                                        width: 100,
                                        child: (TextFormField(
                                          focusNode: FocusNode(),
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            _desiredSubTimeMod = value;
                                          },
                                          decoration: InputDecoration(
                                            hintText: '-$setTimeModifyValue',
                                            hintStyle: const TextStyle(
                                                fontSize: 20, color: Colors.white),
                                            fillColor: Colors.blueGrey,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                              gapPadding: 1.0,
                                            ),
                                          ),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                            _TextInputFormatter(),
                                          ], // Only numbers can be entered
                                        )),
                                      ),

                                      SizedBox(width: 25),

                                      Container(
                                        width: 100,
                                        height: 80,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // TODO Update variables here!
                                            // textformfield todo remove...
                                            print("\n\nSave button pressed! \n");

                                            // Check if changes were made to any Time settings
                                            if (_desiredRestTimeDuration != '') {
                                              print("Change is coming");
                                            }
                                            if (_desiredWorkTimeDuration != '') {
                                              print("Change is coming");
                                            }
                                            if (_desiredSubTimeMod != '') {
                                              print("Change is coming");
                                            }
                                            if (_desiredAddTimeMod != '') {
                                              print("Change is coming");
                                            }

                                            Navigator.pop(context);
                                          },
                                          child: Text('Save'),
                                        ),
                                      ),

                                      SizedBox(width: 25),

                                      /////////////////////////
                                      // + Time input field  //
                                      /////////////////////////
                                      SizedBox(
                                        width: 100,
                                        child: (TextFormField(
                                          focusNode: FocusNode(),
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            _desiredAddTimeMod = value;
                                          },
                                          decoration: InputDecoration(
                                            hintText: '+$setTimeModifyValue',
                                            hintStyle: const TextStyle(
                                                fontSize: 20, color: Colors.white),
                                            iconColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                              gapPadding: 1.0,
                                            ),
                                          ),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(4),
                                            _TextInputFormatter(),
                                          ], // Only numbers can be entered
                                        )),
                                      ),
                                    ]),

                                //////////////////////////////////////
                                // Time Adjuster Text Descriptions ///
                                //////////////////////////////////////
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        '- Time',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 170),
                                      Text(
                                        '+ Time',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]),
                                const SizedBox(height: 30),
                                Container(
                                  width: 115,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ),
                                const SizedBox(height: 50),
                              ]),
                        ],
                      ),
                    ],
                  ),
                ),
            ),
        ),
      ),
    );
  }
}
