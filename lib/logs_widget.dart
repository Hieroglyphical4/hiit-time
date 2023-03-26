import 'package:flutter/material.dart';
import 'Config/settings.dart';

//////////////////////////////////////////
// Widget for all User Logs (sub-submenu)
//////////////////////////////////////////
class LogsWidget extends StatefulWidget {
  const LogsWidget({
    required Key key,
  }) : super(key: key);

  @override
  LogsWidgetState createState() => LogsWidgetState();
}

// TODO 3 images to select the main filter: Exercise, Body Part, Date
// Within that body:
// 	1) Group By: Radio buttons (remaining 2 menus)
// 	2) Sort By: Drop down Menu (Alpha, Date)

class LogsWidgetState extends State<LogsWidget> {
  bool _mainFilterExercise = false;
  bool _mainFilterBodyPart = false;
  bool _mainFilterDate = false;
  String _header = '^  Choose Filter  ^';


  @override
  Widget build(BuildContext context) {
    // TODO Display Pages based on options:
    // Workout, Day, Muscle Group
    return Center(
        child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),

                /// Create new Record Button
                ElevatedButton(
                    onPressed: () {

                    },
                    child: Text('New Log',
                        style: TextStyle(fontFamily: 'AstroSpace',
                            fontSize: 20, color: primaryColor))
                ),

                SizedBox(height: 15),

                /// Main Filter Buttons
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Filter by Exercise
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _mainFilterExercise ? primaryColor : Colors.transparent,
                            width: 4,
                          )),
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            _mainFilterExercise = true;
                            _mainFilterBodyPart = false;
                            _mainFilterDate = false;
                            _header = 'Exercise';
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _mainFilterExercise ? Colors.blue : secondaryColor,
                            padding: const EdgeInsets.all(4),
                          ),
                          child: Icon(Icons.paragliding_outlined, color: primaryColor),
                        ),
                      ),

                      SizedBox(width: 45),

                      /// Filter by Date
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: _mainFilterDate ? primaryColor : Colors.transparent,
                              width: 4,
                            )),
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            _mainFilterExercise = false;
                            _mainFilterBodyPart = false;
                            _mainFilterDate = true;
                            _header = 'Date';
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _mainFilterDate ? Colors.blue : secondaryColor,
                            padding: const EdgeInsets.all(4),
                          ),
                          child: Icon(Icons.date_range, color: primaryColor),
                        ),
                      ),

                      SizedBox(width: 45),

                      /// Filter by BodyPart
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: _mainFilterBodyPart ? primaryColor : Colors.transparent,
                              width: 4,
                            )),
                        child: ElevatedButton(
                          onPressed: () => setState(() {
                            _mainFilterExercise = false;
                            _mainFilterBodyPart = true;
                            _mainFilterDate = false;
                            _header = 'Body Part';
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _mainFilterBodyPart ? Colors.blue : secondaryColor,
                            padding: const EdgeInsets.all(4),
                          ),
                          child: Icon(Icons.face, color: primaryColor),
                        ),
                      ),
                    ]
                ),

                SizedBox(height: 10),

                // Main Filter Header
                Text(_header,
                  style: TextStyle(fontFamily: 'AstroSpace', fontSize: 25, height: 1.1,
                      color: primaryColor
                  ),),

              ],
            )
        )
        );
    // return Text("User can track PRs here", style: TextStyle(fontSize: 30, color: textColorOverwrite ? Colors.black : Colors.white));
  }
}
