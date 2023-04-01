import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Config/settings.dart';
import 'Database/database_helper.dart';

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
// 	2) Sort By: Drop down Menu (Name, Date)

class LogsWidgetState extends State<LogsWidget> {
  bool _mainFilterExercise = false;
  bool _mainFilterBodyPart = false;
  bool _mainFilterDate = false;
  bool _displayNewLogsWidget = false;

  void closeNewLogsMenuAfterSubmission() {
    // TODO Display popup message of submission

    setState(() {
      _displayNewLogsWidget = false;
      _mainFilterExercise = false;
      _mainFilterBodyPart = false;
      _mainFilterDate = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                        color: _displayNewLogsWidget ? secondaryColor : secondaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 9,
                      left: 14,
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
                    ? NewLogEditLogWidget(closeNewLogsMenu: closeNewLogsMenuAfterSubmission, header: 'New Log', id: null)
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

///////////////////////////////////
// Widget for New & Edit Log
///////////////////////////////////
class NewLogEditLogWidget extends StatefulWidget {
  final Function() closeNewLogsMenu;
  String header; // Either New Log or Edit Log
  final id; // Id of Workout Record

  NewLogEditLogWidget({
    super.key,
    required this.closeNewLogsMenu,
    required this.header,
    required this.id
  });

  @override
  NewLogEditLogWidgetState createState() => NewLogEditLogWidgetState();
}

class NewLogEditLogWidgetState extends State<NewLogEditLogWidget> {
  // Text Displayed on Dropdown Menu
  String? _selectedExercise;

  // These are Edit Mode Variables and are the log Initial Values
  late bool _editMode;
  String? _currentExercise;
  String? _currentDate;
  String? _currentWeight;
  String? _currentReps;
  String? _currentSets;

  // These are the variables used to store users provided values
  String? _providedExercise;
  String? _providedDate;
  String? _providedWeight;
  String? _providedReps;
  String? _providedSets;

  // Config Var to limit string lengths
  int maxExerciseStringLength = 15;

  // Initialize dropdown menu to avoid errors
  List<String> dropdownItems = <String>[''];

  // counts how many fields the user has supplied to determine if save button should show
  int _userInputCount = 0;

  // Create a function that shows the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != _providedDate) {
      setState(() {
        if (_providedDate == null) {
          ++_userInputCount;
        }
        _providedDate = "${picked.month.toString().padLeft(2,'0')}/${picked.day.toString().padLeft(2,'0')}/${picked.year.toString()}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getExercises();

    if (widget.header == 'New Log') {
      // New Log Setup Stuff
      _editMode = false;
    } else {
      // Edit Mode Setup Stuff
      _editMode = true;

      // TODO Initialize Vars
      getCurrentWorkoutFields();
    }
  }

  // Initialize Items in Dropdown menu
  Future<void> getExercises() async {
    final items = await DatabaseHelper.instance.getUniqueExerciseNames();

    setState(() {
      dropdownItems = items;
    });
  }

  // Initialize TextFields in Edit Log Widget
  Future<void> getCurrentWorkoutFields() async {
    final workout = await DatabaseHelper.instance.getWorkout(widget.id);
    final Map<String, dynamic> workoutFields = workout.first;

    setState(() {
      _currentExercise = workoutFields['exerciseName'];
      _currentDate = workoutFields['date'];
      _currentWeight = workoutFields['weight'].toString();
      _currentReps = workoutFields['reps'].toString();
      _currentSets = workoutFields['sets'].toString();
    });
  }

  // Insert new workout record
  Future<int> insertWeightedWorkout() async {
    Map<String, dynamic> data = {
      'exerciseId' : '', // will be updated in database_helper
      'date': _providedDate,
      'weight': _providedWeight,
      'reps': _providedReps,
      'sets': _providedSets,
    };

    return await DatabaseHelper.instance.insertWeightedWorkout('weighted_workouts', data, _providedExercise!);
  }

  // Insert new workout record
  Future<int> updateWeightedWorkout() async {
    Map<String, dynamic> data = {
      'exerciseId' : '', // will be updated in database_helper
      'date': _providedDate ?? _currentDate,
      'weight': _providedWeight ?? _currentWeight,
      'reps': _providedReps ?? _currentReps,
      'sets': _providedSets ?? _currentSets,
    };

    var exercise = _providedExercise ?? _currentExercise;

    return await DatabaseHelper.instance.updateWeightedWorkout(data, exercise!, widget.id);
  }

  deleteWeightedWorkout() async {
    return await DatabaseHelper.instance.delete('weighted_workouts', widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 365,
        width: 275,
        color: secondaryAccentColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),

              // Header
              Text(widget.header,
                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 25, height: 1.1, color: primaryColor, decoration: TextDecoration.none)),
              SizedBox(height: 10),
              SizedBox(height: 1, child: Container(color: Colors.grey)),
              SizedBox(height: 15),

              /// ////////////////
              /// Exercise Inputs
              /// ////////////////
              Row(children: [
                  Spacer(flex: 1),

                  /// ///////////////////
                  /// Exercise Dropdown
                  /// ///////////////////
                  SizedBox(
                      height: 50,
                      width: 210,
                      child:Material(
                        color: primaryColor,
                        child: Center(
                            child: DropdownButton<String>(
                            hint: Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 9.0, 0.0, 0.0),
                                child: Row(children:[
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_drop_down, size: 25, color: appCurrentlyInDarkMode ? Colors.black : Colors.white),
                                  _editMode
                                      ? Text(_currentExercise!,
                                      style: TextStyle(fontFamily: 'AstroSpace', fontSize: 16,
                                          color: (_providedExercise == _currentExercise)
                                              ? primaryAccentColor
                                              : appCurrentlyInDarkMode ? Colors.black : Colors.white
                                      ),
                                      textAlign: TextAlign.center)
                                     : Text(" Exercise",
                                      style: TextStyle(fontFamily: 'AstroSpace', fontSize: 16,
                                          color: (_providedExercise != _currentExercise)
                                              ? primaryAccentColor
                                              : appCurrentlyInDarkMode ? Colors.black : Colors.white),
                                      textAlign: TextAlign.center),
                                ])
                            ),
                            value: _selectedExercise,
                            onChanged: (String? newValue) {
                              setState(() {
                                if (_selectedExercise == null) {
                                  ++_userInputCount;
                                }
                                _selectedExercise = newValue!;
                                _providedExercise = newValue;
                              });
                            },
                            items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 16, color: textColorOverwrite ? Colors.black : primaryColor, fontWeight: FontWeight.w600)
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
                                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 16, fontWeight: FontWeight.w600,
                                        color: (_providedExercise != _currentExercise)
                                            ? primaryAccentColor
                                            : appCurrentlyInDarkMode ? Colors.black : Colors.white
                                    ),
                                  )),
                                );
                              }).toList();
                            },
                            )
                        )
                      )
                    ),

                  //////////////////////////////
                  /// Add Exercise Button    ///
                  //////////////////////////////
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Material(
                        color: primaryColor,
                        child: Center(
                          child: IconButton(
                              iconSize: 35,
                              color: secondaryColor,
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
                                    return AddExerciseEditExerciseDialog(
                                        initialMaxExerciseStringLength: maxExerciseStringLength,
                                        header: 'Add Exercise',
                                        initialExerciseName: '',
                                    );
                                  },
                                ).then((restartRequired) {
                                  if (restartRequired == true) {
                                    // Refresh exercise dropdown menu
                                    widget.closeNewLogsMenu();
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

              // Only show input fields after exercise is selected
              (_providedExercise == null && _currentExercise == null)
                  ? SizedBox(height: 131)
                  : Column (children:[
                /// Date and Weight Inputs
                Row(
                  children: [
                    Spacer(),
                      /// ///////////////////
                      /// Date Input Fields
                      /// ///////////////////
                      Column(children: [
                        SizedBox(
                            height: 40,
                            width: 100,
                            child: Material(
                              color: primaryColor,
                              child: TextFormField(
                                    readOnly: true, // set readOnly to true to disable editing of the text field
                                    controller: TextEditingController(
                                      text: _providedDate == null ? '' : _providedDate.toString(),
                                    ),
                                    style: TextStyle(
                                        color: (_providedDate != _currentDate)
                                            ? primaryAccentColor
                                            : appCurrentlyInDarkMode ? Colors.black : Colors.white,
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
                                      hintText: _editMode ? _currentDate : 'mm/dd/yyyy',
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: appCurrentlyInDarkMode ? Colors.black : Colors.white,
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

                    Spacer(),

                    /////////////////////////
                      /// Weight Input Field
                      /// /////////////////////
                      Column(children: [
                        SizedBox(
                          height: 40,
                          width: 100,
                          child: Material(
                            color: primaryColor,
                            child: Padding(
                                padding: EdgeInsets.only(top: 17),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: (_providedWeight != _currentWeight)
                                          ? primaryAccentColor
                                            : appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                      fontSize: 25),
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
                                    hintText: _editMode ? _currentWeight : '000',
                                    hintStyle: TextStyle(
                                      fontSize: 25,
                                      color: appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                    ),
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                    FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                    LengthLimitingTextInputFormatter(4), // 4 digits at most
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

                    Spacer(),
                  ]),

                SizedBox(height: 15),

                /// Reps and Sets
                Row(children: [
                  Spacer(),

                  /// //////////////////
                  /// Reps Input Fields
                  /// //////////////////
                  Column(children: [
                    Material(
                        color: primaryColor,
                        child: Center(
                            child: SizedBox(
                              height: 40,
                              width: 100,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 17),
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: (_providedReps != _currentReps)
                                            ? primaryAccentColor
                                            : appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                        fontSize: 25),
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
                                      hintText: _editMode ? _currentReps : '00',
                                      hintStyle: TextStyle(
                                        fontSize: 25,
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

                  Spacer(),

                  /// ///////////////////
                  /// Sets Input Fields
                  /// ///////////////////
                  Column(children: [
                    Material(
                        color: primaryColor,
                        child: Center(
                            child: SizedBox(
                              height: 40,
                              width: 100,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 17),
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: (_providedSets != _currentSets)
                                            ? primaryAccentColor
                                            : appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                        fontSize: 25),
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
                                      hintText: _editMode ? _currentSets : '0',
                                      hintStyle: TextStyle(
                                        fontSize: 25,
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

                  Spacer(),
              ]),
              ]),


              /// Delete And Save Buttons
              Row(children: [

                _editMode
                  ? Spacer()
                  : Container(),

                /// Delete Column
                _editMode
                    ? Material(
                    color: secondaryAccentColor,
                    child: Column(
                        children: [
                          SizedBox(height: 15),
                          //////////////////
                          /// Delete Button
                          //////////////////
                          GestureDetector(
                              onLongPress: () {
                                HapticFeedback.mediumImpact();

                                deleteWeightedWorkout();
                                widget.closeNewLogsMenu();
                                Navigator.of(context).pop(true);
                              },
                              child: IconButton(
                                  iconSize: 45,
                                  color: Colors.red.shade600,
                                  icon: const Icon(Icons.delete_forever),
                                  onPressed: () {
                                    // null
                                  }
                                )),

                          /// Delete Text Description
                          Column(children:[
                            Text(
                              'Hold to',
                              style: TextStyle(
                                fontFamily: 'AstroSpace',
                                color: Colors.red.shade600,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(
                                fontFamily: 'AstroSpace',
                                color: Colors.red.shade600,
                                fontSize: 20,
                              ),
                            )
                          ])
                        ])
                )
                    :  Container(),

                Spacer(),

                /// Save Column
                Material(
                  color: secondaryAccentColor,
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
                        onPressed: _editMode
                            ? _userInputCount > 0 ? () {
                          /// Edit Mode
                          // widget.audio.setVolume(_appVolume);
                          // widget.audio.setReleaseMode(ReleaseMode.stop);
                          // if (!appCurrentlyMuted && saveButtonAudioCurrentlyEnabled) {
                          //   widget.audio.play(AssetSource(audioForSaveButton));
                          //   widget.audio.setReleaseMode(ReleaseMode.stop);
                          // }
                          // TODO Update Weight Record

                          updateWeightedWorkout();
                          HapticFeedback.mediumImpact();
                          widget.closeNewLogsMenu();
                          Navigator.of(context).pop(true);
                        }
                                : null
                            : _userInputCount == 5 ? () {
                          /// New Log Mode
                          // widget.audio.setVolume(_appVolume);
                          // widget.audio.setReleaseMode(ReleaseMode.stop);
                          // if (!appCurrentlyMuted && saveButtonAudioCurrentlyEnabled) {
                          //   widget.audio.play(AssetSource(audioForSaveButton));
                          //   widget.audio.setReleaseMode(ReleaseMode.stop);
                          // }


                          insertWeightedWorkout();
                          HapticFeedback.mediumImpact();
                          widget.closeNewLogsMenu();
                        }
                                : null,
                         // If all settings haven't updated, Disable Save Button
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

                Spacer(),
              ]),

              SizedBox(height: 15),
            ])
        )
    );
  }
}

////////////////////////////////////////////
// Widget for Add & Edit Exercise Dialog
////////////////////////////////////////////
class AddExerciseEditExerciseDialog extends StatefulWidget {
  final int initialMaxExerciseStringLength;
  String header;
  final String initialExerciseName;

  AddExerciseEditExerciseDialog({
      required this.initialMaxExerciseStringLength,
      required this.header,
      required this.initialExerciseName,
      super.key,
  });

  @override
  AddExerciseEditExerciseDialogState createState() => AddExerciseEditExerciseDialogState();
}

class AddExerciseEditExerciseDialogState extends State<AddExerciseEditExerciseDialog> {
  int maxExerciseStringLength = 15;
  late int currentExerciseStringLength;
  late String initialExerciseName;
  String newExerciseName = '';

  int maxBodyPartStringLength = 15;
  late int currentBodyPartStringLength;
  late String initialBodyPartName;
  String newBodyPartName = '';


  bool cardioExercise = false;
  late bool editMode;

  @override
  void initState() {
    super.initState();
    maxExerciseStringLength = widget.initialMaxExerciseStringLength;
    currentExerciseStringLength = maxExerciseStringLength;

    currentBodyPartStringLength = maxBodyPartStringLength;

    if (widget.header == 'Add Exercise') {
      editMode = false;
    } else {
      editMode = true;
    }
  }

  void _changeCardioOrWeightWorkout(bool value) {
    setState(() {
      if (cardioExercise) {
        cardioExercise = false;
      } else{
        cardioExercise = true;
      }
    });
  }

  Future<void> insertNewExerciseAndBodyPartsRecord(String exercise, String bodypart, bool isCardio) async {
    await DatabaseHelper.instance.insertExerciseWithBodyPartName(exercise, bodypart, isCardio);
  }

  @override
  Widget build(BuildContext context) {
   return Center(
        child: Material(
            color: secondaryColor,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 20,
                      right: 20,
                      top: 20,
                    ),
                    child:SizedBox(
                    height: 350,
                    width: 210,
                    child: Column(
                        children: [
                          /// Header
                          Divider(color: primaryColor),
                          Container(
                              width: 210,
                              child: Text(' ${widget.header}:',
                                style: TextStyle(
                                  // backgroundColor: primaryAccentColor,
                                    color: textColorOverwrite ? Colors.black : primaryColor,
                                    fontSize: 20),
                              )),
                          Divider(color: primaryColor),

                          /// Cardio Toggle
                          Row(children: [
                            Spacer(),
                            Text('Cardio',
                                style: TextStyle(color: cardioExercise ? textColorOverwrite ? Colors.black : primaryColor
                                    : Colors.grey, fontSize: 18)
                            ),
                            Switch(
                              value: !cardioExercise,
                              onChanged: _changeCardioOrWeightWorkout,
                            ),
                            Text('Weighted',
                                style: TextStyle(color: cardioExercise ? Colors.grey
                                    : textColorOverwrite ? Colors.black : primaryColor, fontSize: 18)
                            ),
                            Spacer(),
                          ]),

                          /// Body Part
                          TextFormField(
                            style: TextStyle(
                                color: textColorOverwrite ? Colors.black : primaryColor,
                                fontSize: 25),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              newBodyPartName = value;

                              if (value != '') {
                                setState(() {
                                  currentBodyPartStringLength = maxBodyPartStringLength - value.length;
                                });
                              }
                              if (value == '') {
                                // Useful if the text field was added to and deleted
                                setState(() {
                                  currentBodyPartStringLength = maxBodyPartStringLength;
                                });
                              }
                            },
                            onFieldSubmitted: (value) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: const InputDecoration(
                              hintText: 'ex: chest',
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(maxBodyPartStringLength), // 15 characters at most
                            ],
                          ),
                          SizedBox(height: 3),
                          Text('Body Part',
                              style: TextStyle(
                                fontFamily: 'AstroSpace',
                                color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                fontSize: 12)
                          ),

                          SizedBox(height: 10),

                          Divider(color: primaryColor),

                          /// Exercise Name Field
                          TextFormField(
                            style: TextStyle(
                                color: textColorOverwrite ? Colors.black : primaryColor,
                                fontSize: 25),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              newExerciseName = value;

                              if (value != '') {
                                setState(() {
                                  currentExerciseStringLength = maxExerciseStringLength - value.length;
                                });
                              }
                              if (value == '') {
                                // Useful if the text field was added to and deleted
                                setState(() {
                                  currentExerciseStringLength = maxExerciseStringLength;
                                });
                              }
                            },
                            onFieldSubmitted: (value) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            decoration: const InputDecoration(
                              hintText: 'ex: squat',
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(maxExerciseStringLength), // 15 characters at most
                            ],
                          ),
                          SizedBox(height: 3),
                          Text('Exercise Name',
                              style: TextStyle(
                                  fontFamily: 'AstroSpace',
                                  color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                  fontSize: 12)
                          ),

                          SizedBox(height: 10),

                          /// Cancel and Confirm Buttons
                          Row(children: [
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade600,
                                padding: const EdgeInsets.all(4),
                              ),
                              child: const Text("Cancel",
                                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: newExerciseName.isNotEmpty ? primaryAccentColor : secondaryColor,
                                padding: const EdgeInsets.all(4),
                              ),
                              child: const Text("Confirm",
                                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
                              ),
                              onPressed: newExerciseName.isNotEmpty ? () {

                                if (editMode == false) {
                                  insertNewExerciseAndBodyPartsRecord(newExerciseName, newBodyPartName, cardioExercise);
                                } else {
                                  // TODO Create update statement
                                }
                                Navigator.of(context).pop(true);
                              } : null,
                            ),
                            const Spacer(),
                          ]),
                          Divider(color: primaryColor),
                        ])
                ))
            )
        )
    );
  }
}

///////////////////////////////////
// Widget for Edit Exercise Dialog
///////////////////////////////////
class EditExerciseDialog extends StatefulWidget {
  final String initialExerciseName;
  EditExerciseDialog(this.initialExerciseName);

  @override
  _EditExerciseDialogState createState() => _EditExerciseDialogState();
}

class _EditExerciseDialogState extends State<EditExerciseDialog> {
  int maxExerciseStringLength = 15;
  late int currentExerciseStringLength;
  late String initialExerciseName;
  late String updatedExerciseName;

  @override
  void initState() {
    super.initState();
    initialExerciseName = widget.initialExerciseName;
    currentExerciseStringLength = maxExerciseStringLength - initialExerciseName.length;
    updatedExerciseName = initialExerciseName;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
            color: secondaryColor,
            child: SizedBox(
                height: 200,
                width: 210,
                child: Column(
                    children: [
                      Divider(color: primaryColor),
                      Container(
                          width: 210,
                          child: Text(' Edit Exercise Name:',
                        style: TextStyle(
                          // backgroundColor: primaryAccentColor,
                          color: textColorOverwrite ? Colors.black : primaryColor,
                          fontSize: 20),
                      )),

                      Divider(color: primaryColor),
                      TextFormField(
                        initialValue: initialExerciseName,
                        style: TextStyle(
                            backgroundColor: secondaryColor,
                            color: textColorOverwrite ? Colors.black : primaryColor,
                            fontSize: 25),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          updatedExerciseName = value;

                          if (value != '') {
                            setState(() {
                              currentExerciseStringLength = maxExerciseStringLength - value.length;
                            });
                          }
                          if (value == '') {
                            // Useful if the text field was added to and deleted
                            setState(() {
                              currentExerciseStringLength = maxExerciseStringLength;
                            });
                          }
                        },
                        onFieldSubmitted: (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        decoration: const InputDecoration(
                          hintText: 'new name',
                          hintStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(maxExerciseStringLength), // 15 characters at most
                        ],
                      ),

                      SizedBox(height: 25),

                      Row(children: [
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            padding: const EdgeInsets.all(4),
                          ),
                          child: const Text("Cancel",
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (updatedExerciseName.isNotEmpty && updatedExerciseName != initialExerciseName) ? primaryAccentColor : secondaryColor,
                            padding: const EdgeInsets.all(4),
                          ),
                          child: const Text("Confirm",
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
                          ),
                          onPressed: (updatedExerciseName.isNotEmpty && updatedExerciseName != initialExerciseName) ? () {
                            Navigator.of(context).pop(true);
                          } : null,
                        ),
                        const Spacer(),
                      ]),
                      Divider(color: primaryColor),
                    ])
            ))
    );
  }
}

///////////////////////////////////
// Widget for Edit Workout Dialog
///////////////////////////////////
class EditWorkoutDialog extends StatefulWidget {
  final int workoutId;
  EditWorkoutDialog(this.workoutId);

  @override
  _EditWorkoutDialogState createState() => _EditWorkoutDialogState();
}

class _EditWorkoutDialogState extends State<EditWorkoutDialog> {
  late int workoutId;

  @override
  void initState() {
    super.initState();
    workoutId = widget.workoutId;
  }

  // TODO Build forward and back arrow to grab next and previous records.

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
            color: secondaryColor,
            child: SizedBox(
                height: 200,
                width: 210,
                child: Column(
                    children: [
                      Divider(color: primaryColor),
                      Container(
                          width: 210,
                          child: Text(' Edit Workout:',
                            style: TextStyle(
                              // backgroundColor: primaryAccentColor,
                                color: textColorOverwrite ? Colors.black : primaryColor,
                                fontSize: 20),
                          )),

                      Divider(color: primaryColor),

                      SizedBox(height: 70),

                      Row(children: [
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            padding: const EdgeInsets.all(4),
                          ),
                          child: const Text("Cancel",
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryAccentColor,
                            padding: const EdgeInsets.all(4),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text("Confirm",
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
                          ),
                        ),
                        const Spacer(),
                      ]),
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
  // List<Map> exampleMap = [
  //   {'id': 1, 'name': 'Bench Press',  'bodyPart': 'Chest', 'cardio': false, 'selected': false},
  //   {'id': 2, 'name': 'Deadlift',  'bodyPart': 'Back', 'cardio': false, 'selected': false},
  //   {'id': 3, 'name': 'Jump Rope',  'bodyPart': 'Cardio', 'cardio': true, 'selected': false},
  //   {'id': 4, 'name': 'Squat',  'bodyPart': 'Legs', 'cardio': false, 'selected': false},
  // ];

  List<Map> exerciseMap = [];
  List<Map> workoutMap = [];
  late String selectedExercise;

  // This Widget is shown whenever an individual exercise is selected
  Widget buildTableForSelectedExercise() {
    for (var item in exerciseMap) {
      if (item['selected'] == true) {
        // todo Remove temp setup looking just for deadlift
        // TODO Run if logic on Cardio = true/false
          return Container(
            width: 275,
            color: primaryColor,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.2),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(1.2),
                  4: FlexColumnWidth(1),
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
                                  fontSize: 16, color: textColorOverwrite
                                      ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                      : secondaryAccentColor
                              )),
                          Divider(color: textColorOverwrite
                              ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                              : secondaryAccentColor),
                        ])
                      ),
                      TableCell(child:
                        Column(children: [
                          SizedBox(height: 5),
                          Text('Weight',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 16, color: textColorOverwrite
                                    ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                    : secondaryAccentColor)),
                          Divider(color: textColorOverwrite
                              ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                              : secondaryAccentColor),
                        ])
                      ),
                      TableCell(child:
                        Column(children: [
                          SizedBox(height: 5),
                          Text('Reps',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 16, color: textColorOverwrite
                                    ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                    : secondaryAccentColor)),
                          Divider(color: textColorOverwrite
                              ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                              : secondaryAccentColor),
                        ])
                      ),
                      TableCell(child:
                        Column(children: [
                          SizedBox(height: 5),
                          Text('Sets',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 16, color: textColorOverwrite
                                    ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                    : secondaryAccentColor)),
                          Divider(color: textColorOverwrite
                              ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                              : secondaryAccentColor),
                        ])
                      ),
                      TableCell(child:
                        Column(children: [
                          SizedBox(height: 5),
                          Text('Edit',
                              style: TextStyle(fontFamily: 'AstroSpace',
                                  fontSize: 16, color: textColorOverwrite
                                      ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                      : secondaryAccentColor)),
                          Divider(color: textColorOverwrite
                              ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                              : secondaryAccentColor),
                        ])
                      ),
                    ],
                  ),
                  for (var item in workoutMap)
                    TableRow(
                      children: [
                        TableCell(child:
                          Column(children: [
                            Text(("${(item['date']).substring(0, 5)}"),
                                style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: secondaryColor)
                            ),
                            Divider(color: textColorOverwrite
                                ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                : secondaryAccentColor)
                          ])
                        ),
                        TableCell(child:
                          Column(children: [
                            Text(item['weight'].toString(),
                              style: TextStyle(fontFamily: 'AstroSpace',
                              fontSize: 15, color: secondaryColor)),
                            Divider(color: textColorOverwrite
                                ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                : secondaryAccentColor)
                          ])
                        ),
                        TableCell(child:
                          Column(children:[
                            Text(item['reps'].toString(),
                              style: TextStyle(fontFamily: 'AstroSpace',
                              fontSize: 15, color: secondaryColor)),
                            Divider(color: textColorOverwrite
                                ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                : secondaryAccentColor)
                          ])
                        ),
                        TableCell(child:
                          Column(children: [
                            Text(item['sets'].toString(),
                              style: TextStyle(fontFamily: 'AstroSpace',
                              fontSize: 15, color: secondaryColor)),
                            Divider(color: textColorOverwrite
                                ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                : secondaryAccentColor)
                          ])
                          ),
                        TableCell(
                            child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();

                                  // Launch Edit Workout Menu
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
                                      // return EditWorkoutDialog(item['id']);
                                      return Center(
                                          child: SizedBox(
                                              width: 300,
                                              height: 400,
                                              child: NewLogEditLogWidget(closeNewLogsMenu: closeNewLogsMenuAfterSubmission, header: 'Edit Mode', id: item['id'])
                                          ));

                                    },
                                  ).then((restartRequired) {
                                    if (restartRequired == true) {
                                      // TODO Determine if updates needs to be refreshed
                                    }
                                  });

                                },
                                child: Column(children: [
                                  Icon(Icons.edit, size: 16, color: secondaryColor),
                                  Divider(color: textColorOverwrite
                                      ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                      : secondaryAccentColor)
                                ]))
                        ),
                      ],
                    )
                ],
          )
          );
      }
    }
    return Container();
  }

  void closeNewLogsMenuAfterSubmission() {
    setState(() {
      for (int i = 0; i < exerciseMap.length; i++) {
          exerciseMap[i]['selected'] = false;
      }
    });
  }

  Future<void> getExercises() async {
    final items = await DatabaseHelper.instance.getMapOfUniqueExerciseNames();

    setState(() {
      exerciseMap = items;
    });
  }

  Future<void> getWorkouts() async {
    final items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise);

    setState(() {
      workoutMap = items;
    });
  }

  @override
  void initState() {
    super.initState();
    getExercises();
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
                itemCount: exerciseMap.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Edit Exercise Button
                            exerciseMap[index]['selected']
                              ? IconButton(
                                splashRadius: 20,
                                onPressed: () => setState(() {
                                  for (int i = 0; i < exerciseMap.length; i++) {
                                    if (i == index) {
                                      HapticFeedback.mediumImpact();

                                      // Launch Edit Exercise Menu
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
                                          return EditExerciseDialog(exerciseMap[i]['name']);
                                        },
                                      ).then((restartRequired) {
                                        if (restartRequired == true) {
                                          // TODO Determine if updates needs to be refreshed
                                        }
                                      });
                                    }
                                  }
                                }),
                                icon: Icon(Icons.edit, color: primaryColor),
                              )
                              : Container(),

                            Container(
                            width: 225,
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: exerciseMap[index]['selected'] ? primaryColor : Colors.transparent,
                                  width: 4,
                                )),
                            child: ElevatedButton(
                              onPressed: () => setState(() {
                                // Only allow one Exercise Submenu active at a time:
                                for (int i = 0; i < exerciseMap.length; i++) {
                                  if (i == index) {
                                    selectedExercise = exerciseMap[i]['name'];
                                    getWorkouts();
                                    exerciseMap[i]['selected'] = !exerciseMap[i]['selected'];
                                  } else {
                                    exerciseMap[i]['selected'] = false;
                                  }
                                }
                              }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: exerciseMap[index]['selected'] ? Colors.blue : secondaryAccentColor,
                                padding: const EdgeInsets.all(4),
                              ),
                              child: Text(exerciseMap[index]['name'],
                                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                    color: textColorOverwrite ? Colors.black : primaryColor
                                ),),
                            ),
                          ),
                  ]),

                        // If current index is selected, render it's widget
                        exerciseMap[index]['selected']
                            ? Column(children: [SizedBox(height: 5), buildTableForSelectedExercise(), SizedBox(height: 5),])
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
      // SizedBox(height: 50),
      // ElevatedButton(
      //   child: Text('Insert Exercise Solo'),
      //   onPressed: () async {
      //     await DatabaseHelper.instance.insertUnique('exercises', {'name': 'Pushups', 'bodyPartId': 0, 'isCardio': 0});
      //   },
      // ),
      // SizedBox(height: 50),
      // ElevatedButton(
      //   child: Text('INSERT Exercise With body part'),
      //   onPressed: () async {
      //     await DatabaseHelper.instance.insertExerciseWithBodyPartName('Pushups', 'Chest', false);
      //   },
      // ),
      // SizedBox(height: 50),
      // ElevatedButton(
      //   child: Text('Read Exercises'),
      //   onPressed: () async {
      //     final data2 = await DatabaseHelper.instance.query('exercises');
      //     print(data2);
      //   },
      // ),
      // SizedBox(height: 50),
      // ElevatedButton(
      //   child: Text('Read Workouts'),
      //   onPressed: () async {
      //     final data2 = await DatabaseHelper.instance.query('weighted_workouts');
      //     print(data2);
      //   },
      // ),
      // SizedBox(height: 50),
      // ElevatedButton(
      //   child: Text('Read Data'),
      //   onPressed: () async {
      //     final data1 = await DatabaseHelper.instance.query('body_parts');
      //     print('Body Parts: ');
      //     print(data1);
      //     final data2 = await DatabaseHelper.instance.query('exercises');
      //     print('Exercises: ');
      //     print(data2);
      //     final data3 = await DatabaseHelper.instance.query('weighted_workouts');
      //     print('weighted_workouts: ');
      //     print(data3);
      //   },
      // ),
      // SizedBox(height: 50),
      // ElevatedButton(
      //   child: Text('Delete Data'),
      //   onPressed: () async {
      //     final data = await DatabaseHelper.instance.delete('exercises', 1);
      //   },
      // ),
    ]);
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
