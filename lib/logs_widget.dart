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
  bool _displayNewLogsWidget = false;

  void closeNewLogsMenuAfterSubmission() {
    // TODO Display popup message of submission

    setState(() {
      _displayNewLogsWidget = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 5),

                /// Create New Log Button
                Stack(
                  children: [
                    Container(
                      height: 50,
                      width: 175,
                      decoration: BoxDecoration(
                        color: _displayNewLogsWidget ? secondaryColor : secondaryAccentColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 9,
                      left: 13,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _displayNewLogsWidget ? Colors.red.shade400 : primaryAccentColor,
                            padding: const EdgeInsets.all(4),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_displayNewLogsWidget) {
                                _displayNewLogsWidget = false;
                              } else {
                                _displayNewLogsWidget = true;
                              }
                            });
                          },
                          child: Container(
                              color: _displayNewLogsWidget ? Colors.red.shade400 : primaryAccentColor,
                              width: 140,
                              height: 40,
                              child:
                              _displayNewLogsWidget
                                  ? Row(children: [
                                Icon(Icons.highlight_off),
                                Text(' Close',
                                    style: TextStyle(fontFamily: 'AstroSpace',
                                        fontSize: 20, color: primaryColor)
                                )
                              ])
                                  : Row(children: [
                                Icon(Icons.add_circle_outline),
                                Text(' New Log',
                                    style: TextStyle(fontFamily: 'AstroSpace',
                                        fontSize: 20, color: primaryColor)
                                )
                              ])
                          )
                      ),
                    )
                  ]
                ),

                _displayNewLogsWidget
                    ? NewLogWidget(closeNewLogsMenu: closeNewLogsMenuAfterSubmission)
                    : Container(),

                // Grey Line
                SizedBox(height: 10),
                SizedBox(height: 1, child: Container(color: Colors.grey)),
                SizedBox(height: 15),

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
                              _mainFilterExercise = !_mainFilterExercise;
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
                              _mainFilterDate = !_mainFilterDate;
                              _mainFilterExercise = false;
                              _mainFilterBodyPart = false;
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
                              _mainFilterBodyPart = !_mainFilterBodyPart;
                              _mainFilterExercise = false;
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
  final Function() closeNewLogsMenu;
  const NewLogWidget({
    super.key,
    required this.closeNewLogsMenu
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

  int maxExerciseStringLength = 15;

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
        height: 450,
        width: 275,
        color: secondaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),

              // Header
              Text("New Log",
                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 30, height: 1.1, color: primaryColor, decoration: TextDecoration.none)),
              SizedBox(height: 10),
              SizedBox(height: 1, child: Container(color: Colors.grey)),
              SizedBox(height: 15),

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

                  SizedBox(
                    height: 50,
                    width: 50,
                    //////////////////////////////
                    /// Add Exercise Button    ///
                    //////////////////////////////
                    child: Material(
                        color: secondaryAccentColor,
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
                                    return AddExerciseDialog(maxExerciseStringLength);
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

              SizedBox(height: 20),

              /// ///////////////////
              /// Date Input Fields
              /// ///////////////////
              Column(children: [
                SizedBox(
                    height: 40,
                    width: 120,
                    child: Material(
                      color: secondaryAccentColor,
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
                          )
                        )
                ),
                SizedBox(height: 5),
                Text("Date",
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, color: primaryColor, decoration: TextDecoration.none)),
              ]),

              SizedBox(height: 20),

              /////////////////////////
              /// Weight Input Field
              /// /////////////////////
              Column(children: [
                SizedBox(
                  height: 40,
                  width: 75,
                  child: Material(
                    color: secondaryAccentColor,
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
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: '000',
                            hintStyle: TextStyle(
                              fontSize: 30,
                              color: secondaryColor,
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            // Only numbers can be entered
                            FilteringTextInputFormatter.deny(RegExp('^0+')),
                            // Filter leading 0s
                            LengthLimitingTextInputFormatter(4),
                            // 4 digits at most
                          ],
                        )
                        ),
                  ),
                ),
                SizedBox(height: 5),
                Text("Weight",
                    style: TextStyle(
                        fontFamily: 'AstroSpace',
                        fontSize: 12,
                        height: 1.1,
                        color: primaryColor,
                        decoration: TextDecoration.none)),
              ]),

              SizedBox(height: 15),

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
                                        fontSize: 30),
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
                                      hintText: '0',
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

              /// Save and Cancel Buttons
              Row(children: [
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
                          widget.closeNewLogsMenu();
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

              SizedBox(height: 10),
            ])
        )
    );
  }
}

///////////////////////////////////
// Widget for add Exercise Dialog
///////////////////////////////////
class AddExerciseDialog extends StatefulWidget {
  final int initialMaxExerciseStringLength;
  AddExerciseDialog(this.initialMaxExerciseStringLength);

  @override
  _AddExerciseDialogState createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends State<AddExerciseDialog> {
  late int maxExerciseStringLength;

  @override
  void initState() {
    super.initState();
    maxExerciseStringLength = widget.initialMaxExerciseStringLength;
  }

  @override
  Widget build(BuildContext context) {
   return Center(
        child: Material(
            color: secondaryColor,
            child: SizedBox(
                height: 118,
                width: 200,
                child: Column(
                    children: [
                      Divider(color: primaryColor),
                      SizedBox(height: 5),
                      TextFormField(
                        style: TextStyle(
                            color: textColorOverwrite ? Colors.black : primaryColor,
                            fontSize: 30),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          if (value != '') {
                            setState(() {
                              maxExerciseStringLength = 15 - value.length;
                            });
                          }
                          if (value == '') {
                            // Useful if the text field was added to and deleted
                            setState(() {
                              maxExerciseStringLength = 15;
                            });
                          }
                        },
                        onFieldSubmitted: (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: const InputDecoration(
                          hintText: 'add exercise',
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(25), // 25 characters at most
                        ],
                      ),
                      SizedBox(height: 3),

                      Text("Remaining Characters: $maxExerciseStringLength", style: TextStyle(fontSize: 12, color: primaryColor)),

                      SizedBox(height: 5),
                      Divider(color: primaryColor),
                    ])
            ))
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
                  1: FlexColumnWidth(1),
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
                        Divider(color: secondaryAccentColor),
                      ])
                      ),
                      TableCell(child:
                        Column(children: [
                          SizedBox(height: 5),
                          Text('Weight',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: secondaryAccentColor)),
                          Divider(color: secondaryAccentColor),
                        ])
                      ),
                      TableCell(child:
                        Column(children: [
                          SizedBox(height: 5),
                          Text('Reps',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: secondaryAccentColor)),
                          Divider(color: secondaryAccentColor),
                        ])
                      ),
                      TableCell(child:
                        Column(children: [
                          SizedBox(height: 5),
                          Text('Sets',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: secondaryAccentColor)),
                          Divider(color: secondaryAccentColor),
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
        height: 200,
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
                                if (i == index) {
                                  exampleMap[i]['selected'] = !exampleMap[i]['selected'];
                                }
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
