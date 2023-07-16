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
  String userRequestedWeight = '00';
  bool inLbMode = true;
  late var buttons;
  List<Widget> rows = [];

  @override
  void initState() {
    super.initState();
    initializeButtons();
    setupPlateButtonRows();
  }

  void initializeButtons() {
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
          userRequestedWeight = (double.parse(userRequestedWeight) + double.parse(weight)).toStringAsFixed(roundTo);
        } else {
          // decrease weight
          userRequestedWeight = (double.parse(userRequestedWeight) - (double.parse(weight) * count)).toStringAsFixed(roundTo);
        }
    });
  }

  // Clear all button counts to 0
  void resetCounts() {
    setState(() {
      userRequestedWeight = '00';

      for (var button in buttons) {
        button.key.currentState?.resetPlateCount();
      }
    });
  }

  void setCalculatorToLb() {
    setState(() {
      if (inLbMode == false) {
        inLbMode = true;
        userRequestedWeight = '00';

        for (var button in buttons) {
          button.key.currentState?.convertToLb();
          userRequestedWeight =  (
              double.parse(userRequestedWeight) +
                  button.key.currentState?.calculateCurrentValue()
          ).toStringAsFixed(0);
        }
      }
    });
  }

  void setCalculatorToKg() {
    setState(() {
      if (inLbMode) {
        inLbMode = false;
        userRequestedWeight = '00';

        for (var button in buttons) {
          button.key.currentState?.convertToKg();
          userRequestedWeight = (
              double.parse(userRequestedWeight) +
                  button.key.currentState?.calculateCurrentValue()
          ).toStringAsFixed(1);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: secondaryColor,
        width: 250,
        height: 475,
        child: Material(
          color:  secondaryColor,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 10),
                Text('Plate Calculator',
                    style: TextStyle(fontFamily: 'AstroSpace', color: primaryColor, fontSize: 16, height: 1.1)
                ),
                SizedBox(height: 10),
                SizedBox(height: 1, child: Container(color: Colors.grey)),
                SizedBox(height: 20),
                ////////////////////////////////////
                // Weight Calculation Text Field
                ////////////////////////////////////
                Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      /// KG Button
                      Container(
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
                                  color: textColorOverwrite ? Colors.black : Colors.white,
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
                            Text(userRequestedWeight,
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
                      Container(
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
                                  color: textColorOverwrite ? Colors.black : Colors.white,
                                  fontSize: 20.0,
                                )),
                          )
                      ),
                ]),

                SizedBox(height: 10),

                /// Create All the Plate Buttons
                Column(children: rows),

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
                            color: textColorOverwrite ? Colors.black : Colors.white,
                            fontSize: 20.0,
                      )),
                )
                ),
              ])
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
