import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Config/settings.dart';

///////////////////////////////////
// Widget for The Plate Calculator
///////////////////////////////////
class PlateCalculator extends StatefulWidget {
  const PlateCalculator({
    required Key key,
  }) : super(key: key);

  @override
  PlateCalculatorState createState() => PlateCalculatorState();
}

class PlateCalculatorState extends State<PlateCalculator> {
  final weightTextEditController = TextEditingController();
  String calculatedWeight = '0';
  bool inLbMode = true;
  late var buttons;
  List<Widget> rows = [];

  // Adding an additional mode that can be switched to in this widget
  bool oneRepMaxMode = false;
  double _weight = 0;
  int _reps = 0;

  @override
  void initState() {
    super.initState();
    initializeButtonsLb();
    setupPlateButtonRows();
  }

  // Used during initial setup and when switching modes
  void initializeButtonsLb() {
    buttons = [
      NumberedPlateButton(
        key: _childWidgetKey35,
        number: '35',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey45,
        number: '45',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey55,
        number: '55',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey10,
        number: '10',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey15,
        number: '15',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey25,
        number: '25',
        count: 0,
        onPressed: changePlateCount
      ),
      NumberedPlateButton(
        key: _childWidgetKey1,
        number: '1',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey5,
        number: '5',
        count: 0,
        onPressed: changePlateCount,
      ),
    ];
  }

  // Used when switching between modes
  void initializeButtonsKg() {
    buttons = [
      NumberedPlateButton(
        key: _childWidgetKey35,
        number: '15.9',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey45,
        number: '20.4',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey55,
        number: '24.9',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey10,
        number: '4.5',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey15,
        number: '6.8',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
          key: _childWidgetKey25,
          number: '11.3',
          count: 0,
          onPressed: changePlateCount
      ),
      NumberedPlateButton(
        key: _childWidgetKey1,
        number: '0.5',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey5,
        number: '2.3',
        count: 0,
        onPressed: changePlateCount,
      ),
    ];
  }

  // Dynamically create rows for each button so we can call children: rows later
  void setupPlateButtonRows() {
    int numCols = 3;
    int numRows = (buttons.length / numCols).ceil();

    for (int i = 0; i < numRows; i++) {
      List<Widget> rowChildren = [];

      for (int j = 0; j < numCols; j++) {
        int index = i * numCols + j;
        if (index >= buttons.length) break;
        rowChildren.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buttons[index],
          ),
        );
      }

      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowChildren,
        ),
      );
    }
  }

  // When the user clicks a plate, increase the shown count
  void changePlateCount(String weight, bool increase, int count) {
    int roundTo = inLbMode ? 0 : 1;

    setState(() {
        if (increase) {
          calculatedWeight = (double.parse(calculatedWeight) + double.parse(weight)).toStringAsFixed(roundTo);
        } else {
          // decrease weight
          calculatedWeight = (double.parse(calculatedWeight) - (double.parse(weight) * count)).toStringAsFixed(roundTo);
        }
    });
  }

  // Clear all button counts to 0
  void resetCounts() {
    // TODO Actually clear text fields when this is hit
    setState(() {
      _reps = 0;
      _weight = 0;
      calculatedWeight = '0';

      for (var button in buttons) {
        button.key.currentState?.resetPlateCount();
      }
    });
  }

  void setCalculatorToLb() {
    setState(() {
      if (inLbMode == false) {
        inLbMode = true;
        calculatedWeight = '0';

        // Plate Calc Mode
        for (var button in buttons) {
          button.key.currentState?.convertToLb();
          calculatedWeight =  (
              double.parse(calculatedWeight) +
                  button.key.currentState?.calculateCurrentValue()
          ).toStringAsFixed(00);
        }
      }
    });
  }

  void setCalculatorToKg() {
    setState(() {
      if (inLbMode) {
        inLbMode = false;
        calculatedWeight = '0';

        for (var button in buttons) {
          button.key.currentState?.convertToKg();
          calculatedWeight = (
              double.parse(calculatedWeight) +
                  button.key.currentState?.calculateCurrentValue()
          ).toStringAsFixed(1);
        }
      }
    });
  }

  String calculateOneRepMax() {
    double answer = _weight / ( 1.0278 - 0.0278 * _reps );
    return answer.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
            color:  secondaryColor,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: primaryColor,
                              width: 1,
                            )
                        ),
                        width: 275,
                        height: 600,
                        child: Column(
                            children: [
                              SizedBox(height: 10),

                              /// Plate Calc Mode Button
                              SizedBox(
                                  height: 50,
                                  width: 200,
                                  child: ElevatedButton(
                                      onPressed: () => setState(() {
                                        calculatedWeight = '0';

                                        if (inLbMode) {
                                          rows = [];
                                          initializeButtonsLb();
                                          setupPlateButtonRows();
                                        } else {
                                          rows = [];
                                          initializeButtonsKg();
                                          setupPlateButtonRows();
                                        }
                                        oneRepMaxMode = false;
                                      }),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: oneRepMaxMode ? secondaryColor : Colors.blue,
                                        padding: const EdgeInsets.all(4),
                                      ),
                                      child: Text('Plate Calculator',
                                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 15, height: 1.1,
                                              color: oneRepMaxMode ?  Colors.grey : primaryColor
                                          ),
                                          textAlign: TextAlign.center
                                      )
                                  )
                              ),

                              SizedBox(height: 10),
                              SizedBox(height: 1, child: Container(color: Colors.grey)),
                              SizedBox(height: 10),

                              /// One Rep Max Mode Button
                              SizedBox(
                                  height: 50,
                                  width: 200,
                                  child: ElevatedButton(
                                      onPressed: () => setState(() {
                                        calculatedWeight = '0';
                                        oneRepMaxMode = true;
                                      }),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: oneRepMaxMode ?  Colors.blue : secondaryColor,
                                        padding: const EdgeInsets.all(4),
                                      ),
                                      child: Text('One Rep Max',
                                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 15, height: 1.1,
                                              color: oneRepMaxMode ? primaryColor : Colors.grey
                                          ),
                                          textAlign: TextAlign.center
                                      )
                                  )
                              ),

                              SizedBox(height: 10),
                              SizedBox(height: 1, child: Container(color: Colors.grey)),
                              SizedBox(height: 20),

                              ////////////////////////////////////
                              // Calculation Result Window | Kg/LB Buttons
                              ////////////////////////////////////
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /// KG Button
                                    oneRepMaxMode ? Container()
                                    : Container(
                                        width: 45,
                                        height: 45,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: inLbMode ? secondaryColor : primaryAccentColor,
                                            padding: const EdgeInsets.all(4),
                                          ),
                                          onPressed: setCalculatorToKg,
                                          child: Text('kg.',
                                              style: TextStyle(
                                                color: alternateColorOverwrite ? Colors.black : primaryColor,
                                                fontSize: 20.0,
                                              )),
                                        )
                                    ),
                                    SizedBox(width: 15),

                                    /// Calculated Weight Window
                                    Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: primaryColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: SizedBox(
                                          width: 100,
                                          height: 40,
                                          child: Center(child:
                                          Text(calculatedWeight,
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 30),
                                            textAlign: TextAlign.center,
                                          )
                                          ),
                                        )
                                    ),

                                    /// LB Button
                                    SizedBox(width: 15),
                                    oneRepMaxMode ? Container()
                                    : Container(
                                        width: 45,
                                        height: 45,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: inLbMode ? primaryAccentColor : secondaryColor,
                                            padding: const EdgeInsets.all(4),
                                          ),
                                          onPressed: setCalculatorToLb,
                                          child: Text('lb.',
                                              style: TextStyle(
                                                color: alternateColorOverwrite ? Colors.black : primaryColor,
                                                fontSize: 20.0,
                                              )),
                                        )
                                    ),
                                  ]),

                              SizedBox(height: 10),

                              /// Setup main body content
                              oneRepMaxMode
                                  ? Column(
                                  children: [
                                    SizedBox(height: 25),
                                    /// Weight Input Field
                                    SizedBox(
                                        width: 75,
                                        height: 50,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: primaryColor,
                                                  width: 1.0,
                                                )),
                                            child: TextFormField(
                                              // TODO Setup controller
                                              style: TextStyle(
                                                  color: secondaryColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              onTap: () => Scrollable.ensureVisible(context),
                                              onChanged: (value) {
                                                if (value != '') {
                                                  _weight = double.parse(value);
                                                }
                                                if (value == '') {
                                                  // Useful if the text field was added to and deleted
                                                  _weight = 0.0;
                                                }
                                              },
                                              onFieldSubmitted: (value) {
                                                FocusManager.instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: primaryColor,
                                                hintText: '000',
                                                hintStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                                FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                                LengthLimitingTextInputFormatter(4), // 2 digits at most
                                              ],
                                            ))
                                    ),
                                    SizedBox(height: 5),
                                    Text("Weight",
                                        style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                                            color: textColorOverwrite ? Colors.black : primaryColor
                                        )
                                    ),

                                    SizedBox(height: 25),

                                    /// Reps Input Field
                                    SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: primaryColor,
                                                  width: 1.0,
                                                )),
                                            child: TextFormField(
                                              // scrollPadding: EdgeInsets.only(bottom:100),
                                              style: TextStyle(
                                                  color: secondaryColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              onChanged: (value) {
                                                if (value != '') {
                                                  _reps = int.parse(value);
                                                }
                                                if (value == '') {
                                                  // Useful if the text field was added to and deleted
                                                  _reps = 0;
                                                }
                                              },
                                              onFieldSubmitted: (value) {
                                                FocusManager.instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: primaryColor,
                                                hintText: '0',
                                                hintStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                                FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                                LengthLimitingTextInputFormatter(2), // 2 digits at most
                                              ],
                                            ))
                                    ),
                                    SizedBox(height: 5),
                                    Text("Reps",
                                        style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                                            color: textColorOverwrite ? Colors.black : primaryColor
                                        )
                                    ),

                                    SizedBox(height: 25),

                                    /// Submit Button
                                    ElevatedButton(
                                      child: const Text("Submit",
                                        style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          calculatedWeight = calculateOneRepMax();
                                        });
                                      },
                                    ),
                                    SizedBox(height: 38),
                                  ])
                                  : Column(children: rows), /// Create All the Plate Buttons

                              SizedBox(height: 10),

                              /// Clear All provided input
                              Container(
                                  width: 125,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryAccentColor,
                                      padding: const EdgeInsets.all(4),
                                    ),
                                    onPressed: resetCounts,
                                    child: Text('Clear',
                                        style: TextStyle(
                                          fontFamily: 'AstroSpace',
                                          color: textColorOverwrite ? Colors.black : Colors.white,
                                          fontSize: 15,
                                        )),
                                  )
                              ),
                            ])
                    ))
            )
        )
    );
    // actions: [
    // ElevatedButton(
    //   child: Text('Close'),
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //   },
    // ),
    // ],
  }
}

/// Keys setup for each button to enable interaction between parent and child widgets
final GlobalKey<NumberedPlateButtonState> _childWidgetKey55 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey45 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey35 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey25 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey15 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey10 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey5 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey1 = GlobalKey<NumberedPlateButtonState>();

class NumberedPlateButton extends StatefulWidget {
  String number;
  final Function(String, bool, int)? onPressed;
  var count;

  NumberedPlateButton({
    required this.number,
    required this.onPressed,
    required int count,
    Key? key,
  }) : super(key: key);

  @override
  NumberedPlateButtonState createState() => NumberedPlateButtonState();
}

class NumberedPlateButtonState extends State<NumberedPlateButton> {

  @override
  void initState() {
    super.initState();
    widget.count = 0;
  }

  // Called from Parent widget during loop to wipe all widgets
  void resetPlateCount() {
    setState(() {
      widget.count = 0;
    });
  }

  // Everytime a plate button is pressed we will increase the count associated with that button
  void increasePlateCount() {
    setState(() {
      widget.count++;
      widget.onPressed!(widget.number, true, widget.count);
    });
  }

  // Called on single widget during long press, math required for displayed amount
  void clearSinglePlateCount() {
    setState(() {
      widget.onPressed!(widget.number, false, widget.count);
      widget.count = 0;
    });
  }

  void convertToKg() {
    double convertedResult = int.parse(widget.number) * .453;
    double roundedResult = (convertedResult * 100).round() / 100;
    setState(() {
      widget.number = roundedResult.toStringAsFixed(1);
    });
  }

  void convertToLb() {
    setState(() {
      widget.number = (double.parse(widget.number) * 2.204).round().toString();
    });
  }

  double calculateCurrentValue() {
    return double.parse(widget.number) * widget.count;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: clearSinglePlateCount,
      onTap: increasePlateCount,
      child: Column(
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: secondaryAccentColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.number,
                style: TextStyle(
                  color: textColorOverwrite ? Colors.black : Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),

          const SizedBox(height: 5.0),

          Text(
            '${widget.count}',
            style: TextStyle(
              fontSize: 15.0,
              color: primaryColor
            ),
          ),
        ],
      ),
    );
  }
}
