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

  @override
  Widget build(BuildContext context) {
    // TODO Display Pages based on options:
    // Workout, Day, Muscle Group
    return Center(
        child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 25),

                /// Create new Record Button
                ElevatedButton(
                    onPressed: () {
                      // TODO Launch Alert Dialog to fill out form to submit new DB record
                    },
                    child: Container(
                        width: 130,
                        height: 40,
                        child:
                          Row(children: [
                            Icon(Icons.add_circle_outline),
                            Text(' New Log',
                              style: TextStyle(fontFamily: 'AstroSpace',
                                  fontSize: 20, color: primaryColor)
                            )
                          ])
                    )
                ),

                SizedBox(height: 20),
                // SizedBox(height: 1, child: Container(color: Colors.grey)),

                /// Main Filter Buttons
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// ///////////////////
                      /// Filter by Exercise
                      /// ///////////////////
                      Column(children: [
                          Container(
                          height: 65,
                          width: 65,
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
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _mainFilterExercise ? Colors.blue : secondaryColor,
                              padding: const EdgeInsets.all(4),
                            ),
                            child: Icon(Icons.paragliding_outlined, color: primaryColor, size: 30),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('Exercise',
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                              color: _mainFilterExercise ? Colors.blue
                              : textColorOverwrite
                                ? Colors.black
                                : primaryColor
                          ),),
                      ]),

                      SizedBox(width: 20),

                      /// ////////////////
                      /// Filter by Date
                      /// ////////////////
                      Column(children: [
                        Container(
                          height: 65,
                          width: 65,
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
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _mainFilterDate ? Colors.blue : secondaryColor,
                              padding: const EdgeInsets.all(4),
                            ),
                            child: Icon(Icons.date_range, color: primaryColor, size: 30),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('Date',
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                              color: _mainFilterDate ? Colors.blue
                                  : textColorOverwrite
                                    ? Colors.black
                                    : primaryColor
                          ),),
                      ]),

                      SizedBox(width: 20),

                      /// ////////////////////
                      /// Filter by BodyPart
                      /// ////////////////////
                      Column(children: [
                        Container(
                          height: 65,
                          width: 65,
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
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _mainFilterBodyPart ? Colors.blue : secondaryColor,
                              padding: const EdgeInsets.all(4),
                            ),
                            child: Icon(Icons.face, color: primaryColor, size: 30),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('Body Part',
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                              color: _mainFilterBodyPart ? Colors.blue
                              : textColorOverwrite
                                ? Colors.black
                                : primaryColor
                          ),),
                      ]),
                    ]
                ),

                SizedBox(height: 10),
                SizedBox(height: 1, child: Container(color: Colors.grey)),
                SizedBox(height: 15),

                // Determine if Exercise Widget should show:
                _mainFilterExercise
                  ? ExercisesWidget()
                  : Container(),

                // Determine if Date Widget should show:
                _mainFilterDate
                    ? DatesWidget()
                    : Container(),

                // Determine if BodyPart Widget should show:
                _mainFilterBodyPart
                    ? BodyPartsWidget()
                    : Container(),

                /// Prompt user to select a Filter
                (!_mainFilterExercise && !_mainFilterDate && !_mainFilterBodyPart)
                    ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: secondaryColor,
                          width: 2,
                        )),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 25, width: 200),
                        Text("Select a Filter",
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1,
                            color: textColorOverwrite ? Colors.black : primaryColor
                        ),),
                      Text("to View Logs",
                        style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1,
                            color: textColorOverwrite ? Colors.black : primaryColor
                        ),),
                        const SizedBox(height: 25),
                      ],
                    ))
                    : Container(),

                SizedBox(height: 10),
                SizedBox(height: 1, child: Container(color: Colors.grey)),
                SizedBox(height: 15),
              ],
            )
        )
        );
    // return Text("User can track PRs here", style: TextStyle(fontSize: 30, color: textColorOverwrite ? Colors.black : Colors.white));
  }
}

//////////////////////////////
// Widget for all Exercises
//////////////////////////////
class ExercisesWidget extends StatefulWidget {
  const ExercisesWidget({
    super.key,
  });

  @override
  ExercisesWidgetState createState() => ExercisesWidgetState();
}

class ExercisesWidgetState extends State<ExercisesWidget> {
  // Tables:
  // Exercises: {id, name, bodyPart, cardio}
  // WeightWorkouts: {id, exercise_id, weight, reps, sets, date}      | weights
  // CardioWorkouts: {id, exercise_id, distance, time, date}          | cardio

  // Query: Select Unique Exercise name from Exercises (Select All?)
  List<Map> exampleMap = [
    {'id': 1, 'name': 'Squat',  'bodyPart': 'Legs', 'cardio': false, 'selected': false},
    {'id': 2, 'name': 'Bench Press',  'bodyPart': 'Chest', 'cardio': false, 'selected': false},
    {'id': 3, 'name': 'Deadlift',  'bodyPart': 'Back', 'cardio': false, 'selected': false},
    {'id': 4, 'name': 'Jump Rope',  'bodyPart': 'Cardio', 'cardio': true, 'selected': false}
  ];

  // Query: SELECT * FROM workouts WHERE exerciseId = 1;
  List<Map> exampleDeadliftWorkoutMap = [
    {'id': 1, 'exercise_id': 3,  'weight': 100, 'reps': 8, 'set': 3, 'date': DateTime(2023, 3, 3).millisecondsSinceEpoch},
    {'id': 2, 'exercise_id': 3,  'weight': 110, 'reps': 6, 'set': 3, 'date': DateTime(2023, 3, 10).millisecondsSinceEpoch},
    {'id': 3, 'exercise_id': 3,  'weight': 115, 'reps': 4, 'set': 3, 'date': DateTime(2023, 3, 17).millisecondsSinceEpoch},
    {'id': 4, 'exercise_id': 3,  'weight': 115, 'reps': 6, 'set': 3, 'date': DateTime(2023, 3, 24).millisecondsSinceEpoch}
  ];

  // This Widget is shown whenever an individual exercise is selected
  Widget buildActiveWidget() {
    for (var item in exampleMap) {
      if (item['selected'] == true) {
        // todo Remove temp setup looking just for deadlift
        // TODO Run if logic on Cardio = true/false
        if ((item['name'] == 'Deadlift')) {
          return Container(
            width: 275,
            color: secondaryColor,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      TableCell(child:
                      Column(children: [
                        SizedBox(height: 5),
                        Text('Date',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: secondaryAccentColor)),
                        SizedBox(height: 5)
                      ])
                      ),
                      TableCell(child:
                        Column(children: [
                          SizedBox(height: 5),
                          Text('Weight',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: secondaryAccentColor)),
                          SizedBox(height: 5)
                        ])
                      ),
                      TableCell(child:
                        Column(children: [
                          SizedBox(height: 5),
                          Text('Reps',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: secondaryAccentColor)),
                          SizedBox(height: 5)
                        ])
                      ),
                      TableCell(child:
                        Column(children: [
                          SizedBox(height: 5),
                          Text('Sets',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: secondaryAccentColor)),
                          SizedBox(height: 5)
                        ])
                      ),
                    ],
                  ),
                  for (var item in exampleDeadliftWorkoutMap)
                    TableRow(
                      children: [
                        TableCell(child:
                        Column(children: [
                          Text(("${DateTime.fromMillisecondsSinceEpoch(item['date']).month}/${DateTime.fromMillisecondsSinceEpoch(item['date']).day}"),
                              style: TextStyle(fontFamily: 'AstroSpace',
                                  fontSize: 12, color: primaryColor)),
                          Divider(color: secondaryAccentColor)
                        ])
                        ),
                        TableCell(child:
                          Column(children: [
                            Text(item['weight'].toString(),
                              style: TextStyle(fontFamily: 'AstroSpace',
                              fontSize: 12, color: primaryColor)),
                            Divider(color: secondaryAccentColor)
                          ])
                        ),
                        TableCell(child:
                          Column(children:[
                            Text(item['reps'].toString(),
                              style: TextStyle(fontFamily: 'AstroSpace',
                              fontSize: 12, color: primaryColor)),
                            Divider(color: secondaryAccentColor)
                          ])
                        ),
                        TableCell(child:
                          Column(children: [
                            Text(item['set'].toString(),
                              style: TextStyle(fontFamily: 'AstroSpace',
                              fontSize: 12, color: primaryColor)),
                            Divider(color: secondaryAccentColor)
                          ])
                          ),
                      ],
                    ),
                ],
          ));
        } else {
          // TODO Query Workouts Table on exerciseId = item['id']
          return Container(
              width: 200,
              height: 100,
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    Text(item['name'] + ' selected',
                        style: TextStyle(fontFamily: 'AstroSpace',
                            fontSize: 15, color: primaryColor)),
                    SizedBox(height: 5)
                  ])
          );
        }
      }
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: 300,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: ListView.builder(
                itemCount: exampleMap.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 350,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: exampleMap[index]['selected'] ? primaryColor : Colors.transparent,
                                width: 4,
                              )),
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              // Only allow one Exercise Submenu active at a time:
                              for (int i = 0; i < exampleMap.length; i++) {
                                exampleMap[i]['selected'] = (i == index);
                              }
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: exampleMap[index]['selected'] ? Colors.blue : secondaryColor,
                              padding: const EdgeInsets.all(4),
                            ),
                            child: Text(exampleMap[index]['name'],
                              style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                  color: primaryColor
                              ),),
                          ),
                        ),

                        // If current index is selected, render it's widget
                        exampleMap[index]['selected']
                            ? Column(children: [SizedBox(height: 5), buildActiveWidget(), SizedBox(height: 5),])
                            : SizedBox(height: 10),
                        ]);
                },
              )),
        ])
    );
  }
}

//////////////////////////////
// Widget for all Dates
//////////////////////////////
class DatesWidget extends StatefulWidget {
  const DatesWidget({
    super.key,
  });

  @override
  DatesWidgetState createState() => DatesWidgetState();
}

class DatesWidgetState extends State<DatesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 50),
      Text("Hello from Dates Widget"),
      SizedBox(height: 50),
    ],);
  }
}

//////////////////////////////
// Widget for all Body Parts
//////////////////////////////
class BodyPartsWidget extends StatefulWidget {
  const BodyPartsWidget({
    super.key,
  });

  @override
  BodyPartsWidgetState createState() => BodyPartsWidgetState();
}

class BodyPartsWidgetState extends State<BodyPartsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 50),
      Text("Hello from Body Parts Widget"),
      SizedBox(height: 50),
    ],);
  }
}
