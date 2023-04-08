import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Config/settings.dart';

////////////////////////////////////////////////
// Widget for all Button Audio related Settings (sub-submenu)
////////////////////////////////////////////////
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
  bool calculatingFromTextField = false;
  late var buttons;
  List<Widget> rows = [];
  List<GlobalKey<NumberedPlateButtonState>> buttonKeys = [];


  @override
  void initState() {
    super.initState();
    initializeButtons();
    setupPlateButtonRows();
  }

  void initializeButtons() {
    buttons = [
      NumberedPlateButton(
        key: _childWidgetKey55,
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
        key: _childWidgetKey35,
        number: '55',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey25,
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
        key: _childWidgetKey10,
        number: '25',
        count: 0,
        onPressed: changePlateCount
      ),
      NumberedPlateButton(
        key: _childWidgetKey5,
        number: '1',
        count: 0,
        onPressed: changePlateCount,
      ),
      NumberedPlateButton(
        key: _childWidgetKey1,
        number: '5',
        count: 0,
        onPressed: changePlateCount,
      ),
    ];
    for (var button in buttons) {
      buttonKeys.add(GlobalKey<NumberedPlateButtonState>());
    }
  }

  // When the user clicks a plate, increase the shown count
  void changePlateCount(String weight, bool increase, int count) {
    setState(() {
      if (increase) {
        userRequestedWeight = (int.parse(userRequestedWeight) + int.parse(weight)).toString();
      } else {
        // decrease weight
        userRequestedWeight = (int.parse(userRequestedWeight) - (int.parse(weight) * count)).toString();
      }
    });
  }

  // Clear all button counts to 0
  void resetCounts() {
    setState(() {
      userRequestedWeight = '00';
      _childWidgetKey55.currentState?.resetPlateCount();
      _childWidgetKey45.currentState?.resetPlateCount();
      _childWidgetKey35.currentState?.resetPlateCount();
      _childWidgetKey25.currentState?.resetPlateCount();
      _childWidgetKey15.currentState?.resetPlateCount();
      _childWidgetKey10.currentState?.resetPlateCount();
      _childWidgetKey5.currentState?.resetPlateCount();
      _childWidgetKey1.currentState?.resetPlateCount();
    });
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


  @override
  Widget build(BuildContext context) {
    return Container(
        color: secondaryColor,
        width: 250,
        height: 470,
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
                      SizedBox(width: 30),
                      Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    child: SizedBox(
                      width: 75,
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
                      SizedBox(width: 10),
                      Align(alignment: Alignment.bottomCenter,
                          child:Text('lb.',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 22)
                      ))
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

/// Keys setup for each button to enable enteraction between parent and child widgets
final GlobalKey<NumberedPlateButtonState> _childWidgetKey55 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey45 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey35 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey25 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey15 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey10 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey5 = GlobalKey<NumberedPlateButtonState>();
final GlobalKey<NumberedPlateButtonState> _childWidgetKey1 = GlobalKey<NumberedPlateButtonState>();

class NumberedPlateButton extends StatefulWidget {
  final String number;
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
