import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Center(
        child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 25),

                /// Create new Record Button
                ElevatedButton(
                    onPressed: () {
                      /// Launch New Log Menu
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
                            child: NewLogWidget(key: UniqueKey()),
                          );
                        },
                      );
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
                SizedBox(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(flex: 1),

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
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 18, height: 1.1,
                              color: _mainFilterExercise ? Colors.blue
                              : textColorOverwrite
                                ? Colors.black
                                : primaryColor
                          ),),
                      ]),

                      Spacer(flex: 1),
                      SizedBox(width: 5),

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
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 18, height: 1.1,
                              color: _mainFilterDate ? Colors.blue
                                  : textColorOverwrite
                                    ? Colors.black
                                    : primaryColor
                          ),),
                      ]),

                      Spacer(flex: 1),

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
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 18, height: 1.1,
                              color: _mainFilterBodyPart ? Colors.blue
                              : textColorOverwrite
                                ? Colors.black
                                : primaryColor
                          ),),
                      ]),

                      Spacer(flex: 1),
                    ]),
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

                /// Prompt user to select a Category
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
                        Text("Select a Category",
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

///////////////////////
// Widget for New Log
///////////////////////
class NewLogWidget extends StatefulWidget {
  const NewLogWidget({
    super.key,
  });

  @override
  NewLogWidgetState createState() => NewLogWidgetState();
}

class NewLogWidgetState extends State<NewLogWidget> {
  String? _selectedExercise;
  String? _selectedDate;
  String? _providedWeight;
  String? _providedReps;
  String? _providedSets;

  List<String> dropdownItems = <String>['Bench Press', 'Deadlift', 'Squat'];

  // counts how many fields the user has supplied to determine if save button should show
  int _userInputCount = 0;

  // Create a function that shows the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) {
      setState(() {
        if (_selectedDate == null) {
          ++_userInputCount;
        }
        _selectedDate = "${picked.month.toString().padLeft(2,'0')}/${picked.day.toString().padLeft(2,'0')}/${picked.year.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        width: 275,
        color: secondaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Header
              Text("New Log",
                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 30, height: 1.1, color: primaryColor, decoration: TextDecoration.none)),
              SizedBox(height: 15),
              SizedBox(height: 1, child: Container(color: Colors.grey)),
              SizedBox(height: 20),

              Row(children: [
                Spacer(flex: 1),
                  /// ////////////////
                  /// Exercise Input
                  /// ////////////////
                  SizedBox(
                    height: 50,
                    width: 190,
                    child:Material(
                      color: secondaryAccentColor,
                      child: Center(
                          child: DropdownButton<String>(
                          hint: Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 9.0, 0.0, 0.0),
                              child: Text("Exercise",
                              style: TextStyle(fontFamily: 'AstroSpace', fontSize: 30, color: secondaryColor),
                              textAlign: TextAlign.center,
                              )
                          ),
                          value: _selectedExercise,
                          onChanged: (String? newValue) {
                            setState(() {
                              if (_selectedExercise == null) {
                                ++_userInputCount;
                              }
                              _selectedExercise = newValue!;
                            });
                          },
                          items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, color: textColorOverwrite ? Colors.black : primaryColor, fontWeight: FontWeight.w600)
                              ),
                            );
                          }).toList(),
                          icon: Container(),
                          underline: Container(),
                          dropdownColor: secondaryAccentColor,
                          selectedItemBuilder: (BuildContext context) {
                            return dropdownItems.map<Widget>((String item) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Center(child: Text(item,
                                  style: TextStyle(fontFamily: 'AstroSpace', color: textColorOverwrite ? Colors.black : primaryColor, fontSize: 20, fontWeight: FontWeight.w600),
                                )),
                              );
                            }).toList();
                          },
                          )
                      )
                    )
                  ),
                Spacer(flex: 1),

                SizedBox(
                  height: 50,
                  width: 50,
                  /////////////////////////////
                  // Add Exercise Button    ///
                  /////////////////////////////
                  child: Material(
                      color: secondaryColor,
                      child: Center(
                        child: IconButton(
                            iconSize: 35,
                            color: primaryColor,
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              HapticFeedback.mediumImpact();

                              // Launch settings menu
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
                                  return Center(child: Text("Add New!"));
                                },
                              ).then((restartRequired) {
                                if (restartRequired == true) {
                                  // TODO Determine if Exercise Drop down needs to be refreshed
                                }
                              });
                              },
                        )
                      )
                  ),
                ),

                Spacer(flex: 1),
              ]),

              // SizedBox(height: 40),
              Spacer(flex: 1),

              /// Date and Weight
              Row(children: [
                Spacer(flex: 1),

                /// ///////////////////
                /// Date Input Fields
                /// ///////////////////
                Column(children: [
                  Material(
                      color: secondaryAccentColor,
                      child: Center(
                          child: SizedBox(
                            height: 40,
                            width: 110,
                            child: Center(
                                child: TextFormField(
                                  readOnly: true, // set readOnly to true to disable editing of the text field
                                  controller: TextEditingController(
                                    text: _selectedDate == null ? '' : _selectedDate.toString(),
                                  ),
                                  style: TextStyle(
                                      color: textColorOverwrite ? Colors.black : primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                  onTap: () => _selectDate(context),
                                  onChanged: (value) {},
                                  onFieldSubmitted: (value) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'mm/dd/yyyy',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )),
                          ))
                  ),
                  SizedBox(height: 5),
                  Text("Date",
                      style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, color: primaryColor, decoration: TextDecoration.none)),
                ]),

                Spacer(flex: 1),

                /// /////////////////////
                /// Weight Input Fields
                /// /////////////////////
                Column(children: [
                  Material(
                    color: secondaryAccentColor,
                    child: Center(
                        child: SizedBox(
                        height: 40,
                        width: 90,
                        child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: TextFormField(
                              style: TextStyle(
                                  color: textColorOverwrite ? Colors.black : primaryColor,
                                  fontSize: 30),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                if (value != '') {
                                  setState(() {
                                    if (_providedWeight == null) {
                                      ++_userInputCount;
                                    }
                                    _providedWeight = value;
                                  });
                                }
                                if (value == '') {
                                  // Useful if the text field was added to and deleted
                                  setState(() {
                                    --_userInputCount;
                                    _providedWeight = null;
                                  });
                                }
                              },
                              onFieldSubmitted: (value) {
                                FocusManager.instance.primaryFocus
                                    ?.unfocus();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 12),
                                hintText: '00',
                                hintStyle: TextStyle(
                                  fontSize: 30,
                                  color: secondaryColor,
                                ),
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                LengthLimitingTextInputFormatter(4), // 4 digits at most
                              ],
                            )),
                      ))
                ),
                  SizedBox(height: 5),
                  Text("Weight",
                      style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, color: primaryColor, decoration: TextDecoration.none)),
                ]),

                Spacer(flex: 1),
              ]),

              // SizedBox(height: 40),

              Spacer(flex: 1),

              /// Reps and Sets
              Row(children: [
                Spacer(flex: 1),

                /// //////////////////
                /// Reps Input Fields
                /// //////////////////
                Column(children: [
                  Material(
                      color: secondaryAccentColor,
                      child: Center(
                          child: SizedBox(
                            height: 40,
                            width: 75,
                            child: Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: textColorOverwrite ? Colors.black : primaryColor,
                                      fontSize: 30),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value != '') {
                                      setState(() {
                                        if (_providedReps == null) {
                                          ++_userInputCount;
                                        }
                                        _providedReps = value;
                                      });
                                    }
                                    if (value == '') {
                                      // Useful if the text field was added to and deleted
                                      setState(() {
                                        --_userInputCount;
                                        _providedReps = null;
                                      });
                                    }
                                  },
                                  onFieldSubmitted: (value) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  decoration: InputDecoration(
                                    hintText: '00',
                                    contentPadding: EdgeInsets.only(bottom: 12),
                                    hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                    FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                    LengthLimitingTextInputFormatter(4), // 4 digits at most
                                  ],
                                )),
                          ))
                  ),
                  SizedBox(height: 5),
                  Text("Reps",
                      style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, color: primaryColor, decoration: TextDecoration.none)),
                ]),

                Spacer(flex: 1),

                /// ///////////////////
                /// Sets Input Fields
                /// ///////////////////
                Column(children: [
                  Material(
                      color: secondaryAccentColor,
                      child: Center(
                          child: SizedBox(
                            height: 40,
                            width: 75,
                            child: Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: textColorOverwrite ? Colors.black : primaryColor,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value != '') {
                                      setState(() {
                                        if (_providedSets == null) {
                                          ++_userInputCount;
                                        }
                                        _providedSets = value;
                                      });
                                    }
                                    if (value == '') {
                                      // Useful if the text field was added to and deleted
                                      setState(() {
                                        --_userInputCount;
                                        _providedSets = null;
                                      });
                                    }
                                  },
                                  onFieldSubmitted: (value) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  decoration: InputDecoration(
                                    hintText: '00',
                                    contentPadding: EdgeInsets.only(bottom: 12),
                                    hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                    FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                    LengthLimitingTextInputFormatter(4), // 4 digits at most
                                  ],
                                )),
                          ))
                  ),
                  SizedBox(height: 5),
                  Text("Sets",
                      style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, color: primaryColor, decoration: TextDecoration.none)),
                ]),

                Spacer(flex: 1),
              ]),

              Spacer(flex: 1),

              /// Save and Cancel Buttons
              Row(children: [
                Spacer(flex: 1),

                /// Cancel Column
                Material(
                  color: secondaryColor,
                    child: Column(
                      children: [
                        // Cancel Button
                        IconButton(
                          iconSize: 45,
                          color: _userInputCount > 0
                              ? Colors.red.shade400
                              : primaryColor,
                          icon: const Icon(Icons.highlight_off),
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            if (_userInputCount > 0) {
                              // widget.audio.setVolume(_appVolume);
                              if (!appCurrentlyMuted && cancelButtonAudioCurrentlyEnabled) {
                                // widget.audio.play(AssetSource(audioForCancelButton));
                                // widget.audio.setReleaseMode(ReleaseMode.stop);
                              }
                            }
                            Navigator.pop(context);
                          },
                        ),

                        // Close/Cancel Text Description
                        Text(
                          _userInputCount > 0 ? 'Cancel' : 'Close',
                          style: TextStyle(
                            fontFamily: 'AstroSpace',
                            color: _userInputCount > 0
                                ? Colors.red.shade400
                                : primaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ])),

                Spacer(flex: 1),

                /// Save Column
                Material(
                  color: secondaryColor,
                  child: Column(
                    children: [
                      ////////////////
                      /// Save Button
                      ////////////////
                      IconButton(
                        iconSize: 45,
                        color: primaryAccentColor,
                        disabledColor: Colors.grey,
                        icon: const Icon(Icons.check_circle),
                        onPressed: _userInputCount == 5 ? () {
                          // widget.audio.setVolume(_appVolume);
                          // widget.audio.setReleaseMode(ReleaseMode.stop);
                          // if (!appCurrentlyMuted && saveButtonAudioCurrentlyEnabled) {
                          //   widget.audio.play(AssetSource(audioForSaveButton));
                          //   widget.audio.setReleaseMode(ReleaseMode.stop);
                          // }

                          HapticFeedback.mediumImpact();
                          Navigator.pop(context); // Close Settings menu
                        }
                            : null, // If all settings haven't updated, Disable Save Button
                      ),

                      /// Save Text Description
                      Text(
                        'Save',
                        style: TextStyle(
                          fontFamily: 'AstroSpace',
                          color: _userInputCount == 5
                              ? primaryAccentColor
                              : Colors.grey,
                          fontSize: 20,
                        ),
                      )
                    ])
                ),

                Spacer(flex: 1),
              ]),

              Spacer(flex: 1),
            ])
        )
    );
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
    {'id': 1, 'name': 'Bench Press',  'bodyPart': 'Chest', 'cardio': false, 'selected': false},
    {'id': 2, 'name': 'Deadlift',  'bodyPart': 'Back', 'cardio': false, 'selected': false},
    {'id': 3, 'name': 'Jump Rope',  'bodyPart': 'Cardio', 'cardio': true, 'selected': false},
    {'id': 4, 'name': 'Squat',  'bodyPart': 'Legs', 'cardio': false, 'selected': false},
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
