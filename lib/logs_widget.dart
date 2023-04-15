import 'Config/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Database/database_helper.dart';
import 'package:hiit_time/plate_calculator.dart';

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

// TODO 3 images to select the main filter: Cardio, Date, Weighted
// Within that body:
// 	1) Group By: Radio buttons (remaining 2 menus)
// 	2) Sort By: Drop down Menu (Name, Date)

class LogsWidgetState extends State<LogsWidget> {
  bool _mainFilterWeights = false;
  bool _mainFilterCardio = false;
  bool _mainFilterDate = false;
  bool _displayNewLogsWidget = false;

  final GlobalKey<WeightsWidgetState> _key = GlobalKey<WeightsWidgetState>();

  // In order to get the inner tables to update dynamically from various places,
  //    we need this method accessible on the parent
  void updateTablesAfterSubmission() {
    // TODO Display popup message of submission

    setState(() {
      _displayNewLogsWidget = false;
      // _mainFilterWeights = false;
      // _mainFilterCardio = false;
      // _mainFilterDate = false;

      _key.currentState?.getExercises();
    });
  }

  // Exercises didnt seem to update the same as workouts in the tables
  //    Closing menus when those are updated... for now
  void closeMenusAfterExerciseSubmission() {
    setState(() {
      _displayNewLogsWidget = false;
      _mainFilterWeights = false;
      _mainFilterCardio = false;
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
                        color: _displayNewLogsWidget ? secondaryAccentColor : secondaryColor,
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
                                Icon(Icons.add_circle_outline, color: textColorOverwrite ? Colors.black : primaryColor),
                                Text(' New Log',
                                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20,
                                        color: textColorOverwrite ? Colors.black : primaryColor
                                    )
                                )
                              ])
                          )
                      ),
                    )
                  ]
                ),

                _displayNewLogsWidget
                    ? NewLogEditLogWidget(updateTable: updateTablesAfterSubmission, closeNewLogsMenu: closeMenusAfterExerciseSubmission, header: 'New Log', id: null)
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

                      /// ////////////////////
                      /// Filter by Cardio
                      /// ////////////////////
                      Column(children: [
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: _mainFilterCardio ? primaryColor : Colors.transparent,
                                width: 4,
                              )),
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              _mainFilterCardio = !_mainFilterCardio;
                              _mainFilterWeights = false;
                              _mainFilterDate = false;
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _mainFilterCardio ? Colors.blue : secondaryColor,
                              padding: const EdgeInsets.all(4),
                            ),
                            child: Icon(Icons.directions_run, color: primaryColor, size: 30),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('Cardio',
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 18, height: 1.1,
                              color: _mainFilterCardio ? Colors.blue
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
                              _mainFilterWeights = false;
                              _mainFilterCardio = false;
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

                      /// ///////////////////
                      /// Filter by Exercise
                      /// ///////////////////
                      Column(children: [
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: _mainFilterWeights ? primaryColor : Colors.transparent,
                                width: 4,
                              )),
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              _mainFilterWeights = !_mainFilterWeights;
                              _mainFilterCardio = false;
                              _mainFilterDate = false;
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _mainFilterWeights ? Colors.blue : secondaryColor,
                              padding: const EdgeInsets.all(4),
                            ),
                            child: Icon(Icons.fitness_center, color: primaryColor, size: 30),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('Weights',
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 18, height: 1.1,
                              color: _mainFilterWeights ? Colors.blue
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

                // Determine if Cardio Widget should show:
                _mainFilterCardio
                    ? CardioWidget()
                    : Container(),

                // Determine if Date Widget should show:
                _mainFilterDate
                    ? DatesWidget()
                    : Container(),

                // Determine if Weights Widget should show:
                _mainFilterWeights
                    ? WeightsWidget(key: _key, updateTables: updateTablesAfterSubmission, closeMenus: closeMenusAfterExerciseSubmission)
                    : Container(),

                /// Prompt user to select a Category
                (!_mainFilterWeights && !_mainFilterDate)
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
  final Function() updateTable;
  final Function() closeNewLogsMenu;
  String header; // Either New Log or Edit Log
  final id; // Id of Workout Record

  NewLogEditLogWidget({
    super.key,
    required this.updateTable,
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
  int _currentRepsSet1 = 0;
  int _currentRepsSet2 = 0;
  int _currentRepsSet3 = 0;
  int _currentRepsSet4 = 0;

  // These are the variables used to store users provided values
  String? _providedExercise;
  String? _providedDate;
  String? _providedWeight;
  int _providedRepsSet1 = 0;
  int _providedRepsSet2 = 0;
  int _providedRepsSet3 = 0;
  int _providedRepsSet4 = 0;

  // Initialize dropdown menu to avoid errors
  List<String> dropdownItems = <String>[''];

  // counts how many fields the user has supplied to determine if save button should show
  bool _exerciseProvided = false;
  bool _dateProvided = false;
  bool _weightProvided = false;
  bool _firstRepsProvided = false;
  bool _secondRepsProvided = false;
  bool _thirdRepsProvided = false;
  bool _fourthRepsProvided = false;

  // Shows and Hides the Hint text for fields you type into
  bool _weightHintTextShowing = true;
  bool _firstRepsHintTextShowing = true;
  bool _secondRepsHintTextShowing = true;
  bool _thirdRepsHintTextShowing = true;
  bool _fourthRepsHintTextShowing = true;

  FocusNode _weightFocusNode = FocusNode();
  FocusNode _firstRepsFocusNode = FocusNode();
  FocusNode _secondRepsFocusNode = FocusNode();
  FocusNode _thirdRepsFocusNode = FocusNode();
  FocusNode _fourthRepsFocusNode = FocusNode();

  _handleFocusChange(FocusNode focusNode, String textField) {
    if (!focusNode.hasFocus) {
      setState(() {
        textField == 'weight' ? _weightHintTextShowing = true : null;
        textField == 'first' ? _firstRepsHintTextShowing = true : null;
        textField == 'second' ? _secondRepsHintTextShowing = true : null;
        textField == 'third' ? _thirdRepsHintTextShowing = true : null;
        textField == 'fourth' ? _fourthRepsHintTextShowing = true : null;
      });
    }
  }


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
          _dateProvided = true;
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

      // Initialize Vars
      getCurrentWorkoutFields();

      // Init Listeners:
      _weightFocusNode.addListener(() => _handleFocusChange(_weightFocusNode, 'weight'));
      _firstRepsFocusNode.addListener(() => _handleFocusChange(_firstRepsFocusNode, 'first'));
      _secondRepsFocusNode.addListener(() => _handleFocusChange(_secondRepsFocusNode, 'second'));
      _thirdRepsFocusNode.addListener(() => _handleFocusChange(_thirdRepsFocusNode, 'third'));
      _fourthRepsFocusNode.addListener(() => _handleFocusChange(_fourthRepsFocusNode, 'fourth'));
    }
  }

  @override
  void dispose() {
    _weightFocusNode.dispose();
    _firstRepsFocusNode.dispose();
    _secondRepsFocusNode.dispose();
    _thirdRepsFocusNode.dispose();
    _fourthRepsFocusNode.dispose();
    super.dispose();
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
      _currentRepsSet1 = workoutFields['rep1'];
      _currentRepsSet2 = workoutFields['rep2'];
      _currentRepsSet3 = workoutFields['rep3'];
      _currentRepsSet4 = workoutFields['rep4'];
    });
  }

  // Insert new workout record
  Future<int> insertWeightedWorkout() async {

    // Prevent later sets from being stored if previous ones were cancelled:
    if (_providedRepsSet2 == 0) {
      _providedRepsSet3 = 0;
      _providedRepsSet4 = 0;
    }
    if (_providedRepsSet3 == 0) {
      _providedRepsSet4 = 0;
    }

    Map<String, dynamic> data = {
      'exerciseId' : '', // will be updated in database_helper
      'date': _providedDate,
      'weight': _providedWeight,
      'rep1': _providedRepsSet1,
      'rep2': _providedRepsSet2,
      'rep3': _providedRepsSet3,
      'rep4': _providedRepsSet4,
    };

    return await DatabaseHelper.instance.insertWeightedWorkout('weighted_workouts', data, _providedExercise!);
  }

  // Insert new workout record
  Future<int> updateWeightedWorkout() async {

    // Prevent later sets from being stored if previous ones were cancelled:
    if (_secondRepsProvided && _providedRepsSet2 == 0) {
      _providedRepsSet3 = 0;
      _currentRepsSet3 = 0;
      _providedRepsSet4 = 0;
      _currentRepsSet4 = 0;
    }
    if (_thirdRepsProvided && _providedRepsSet3 == 0) {
      _providedRepsSet4 = 0;
      _currentRepsSet4 = 0;
    }

    Map<String, dynamic> data = {
      'exerciseId' : '', // will be updated in database_helper
      'date': _providedDate ?? _currentDate,
      'weight': _providedWeight ?? _currentWeight,
      'rep1': _firstRepsProvided ? _providedRepsSet1 : _currentRepsSet1,
      'rep2': _secondRepsProvided ? _providedRepsSet2 : _currentRepsSet2,
      'rep3': _thirdRepsProvided ? _providedRepsSet3 : _currentRepsSet3,
      'rep4': _fourthRepsProvided ? _providedRepsSet4 : _currentRepsSet4,
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
      width: _editMode ? null : 275,
        color: secondaryAccentColor,
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              // Header
              _editMode
                ? SizedBox(height: 25)
                : Column(children: [
                  Text(widget.header,
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 25, height: 1.1,
                        color: textColorOverwrite ? Colors.black : primaryColor, decoration: TextDecoration.none)
                  ),
                  SizedBox(height: 1, child: Container(color: Colors.grey)),
                  SizedBox(height: 15),
              ]),

              // SizedBox(height: 10),


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
                                  _exerciseProvided = true;
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
                                      closeNewLogsMenu: widget.closeNewLogsMenu, // TODO Update this
                                        header: 'Add Exercise',
                                        initialExerciseName: '',
                                    );
                                  },
                                ).then((restartRequired) {
                                  if (restartRequired == true) {
                                    // Refresh exercise dropdown menu
                                    widget.closeNewLogsMenu(); // TODO Update this
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
                            height: 45,
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
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                                color: textColorOverwrite ? Colors.black : primaryColor
                            )),
                      ]),

                    Spacer(),

                    /////////////////////////
                    /// Weight Input Field
                    /// /////////////////////
                    Column(children: [
                        SizedBox(
                          height: 45,
                          width: 100,
                          child: Material(
                            color: primaryColor,
                            child: Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  focusNode: _weightFocusNode,
                                  style: TextStyle(
                                      color: (_providedWeight != _currentWeight)
                                          ? primaryAccentColor
                                            : appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                      fontSize: 25),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  onTap: () {
                                      setState(() {
                                        _weightHintTextShowing = false;
                                      });
                                  },
                                  onChanged: (value) {
                                    if (value != '') {
                                      setState(() {
                                        if (_providedWeight == null) {
                                          _weightProvided = true;
                                        }
                                        _providedWeight = value;
                                      });
                                    }
                                    if (value == '') {
                                      // Useful if the text field was added to and deleted
                                      setState(() {
                                        _providedWeight = null;
                                        _weightProvided = false;
                                      });
                                    }
                                  },
                                  onFieldSubmitted: (value) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  decoration: InputDecoration(
                                    hintText: _weightHintTextShowing
                                        ? _editMode ? _currentWeight : '000'
                                        : '',
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
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                                color: textColorOverwrite ? Colors.black : primaryColor
                            )),
                      ]),

                    Spacer(),
                  ]),

                SizedBox(height: 15),

                /// Reps 1st and 2nd
                Row(children: [
                  Spacer(),

                  /// //////////////////
                  /// Reps Input Fields (1st set)
                  /// //////////////////
                  Column(children: [
                    Material(
                        color: primaryColor,
                        child: Center(
                            child: SizedBox(
                              height: 45,
                              width: 100,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: TextFormField(
                                    focusNode: _firstRepsFocusNode,
                                    style: TextStyle(
                                        color: (_providedRepsSet1 != _currentRepsSet1)
                                            ? primaryAccentColor
                                            : appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      setState(() {
                                        _firstRepsHintTextShowing = false;
                                      });
                                    },
                                    onChanged: (value) {
                                      if (value != '') {
                                        setState(() {
                                          if (!_firstRepsProvided) {
                                            _firstRepsProvided = true;
                                          }
                                          _providedRepsSet1 = int.parse(value);
                                        });
                                      }
                                      if (value == '') {
                                        // Useful if the text field was added to and deleted
                                        setState(() {
                                          _providedRepsSet1 = 0;
                                          _firstRepsProvided = false;
                                        });
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    decoration: InputDecoration(
                                      hintText: _firstRepsHintTextShowing
                                          ? _editMode ? _currentRepsSet1.toString() : '00'
                                          : '',
                                      hintStyle: TextStyle(
                                        fontSize: 25,
                                        color: appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                      ),
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                      FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                      LengthLimitingTextInputFormatter(2), // 4 digits at most
                                    ],
                                  )),
                            ))
                    ),
                    SizedBox(height: 5),
                    Text("Reps (1st)",
                        style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                            color: textColorOverwrite ? Colors.black : primaryColor
                        )),
                  ]),

                  Spacer(),

                  /// //////////////////
                  /// Reps Input Fields (2nd set)
                  /// //////////////////
                  (_providedRepsSet1 > 0 || _currentRepsSet1 > 0)
                    ? Column(children: [
                    Material(
                        color: primaryColor,
                        child: Center(
                            child: SizedBox(
                              height: 45,
                              width: 100,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: TextFormField(
                                    focusNode: _secondRepsFocusNode,
                                    style: TextStyle(
                                        color: (_providedRepsSet2 != _currentRepsSet2)
                                            ? primaryAccentColor
                                            : appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      setState(() {
                                        _secondRepsHintTextShowing = false;
                                      });
                                    },
                                    onChanged: (value) {
                                      if (value != '') {
                                        setState(() {
                                          _providedRepsSet2 = int.parse(value);
                                          _secondRepsProvided = true;
                                        });
                                      }
                                      if (value == '') {
                                        // Useful if the text field was added to and deleted
                                        setState(() {
                                          _providedRepsSet2 = 0;
                                          _secondRepsProvided = false;
                                        });
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    decoration: InputDecoration(
                                      hintText: _secondRepsHintTextShowing
                                          ? _editMode ? _currentRepsSet2.toString() : '00'
                                          : '',
                                      hintStyle: TextStyle(
                                        fontSize: 25,
                                        color: appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                      ),
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                      LengthLimitingTextInputFormatter(2), // 4 digits at most
                                    ],
                                  )),
                            ))
                    ),
                    SizedBox(height: 5),
                    Text("Reps (2nd)",
                        style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                            color: textColorOverwrite ? Colors.black : primaryColor
                        )),
                  ])
                    : SizedBox(width: 100),


                  Spacer(),
              ]),

                SizedBox(height: 15),

                /// Reps 3rd and 4th
                Row(children: [
                  Spacer(),

                  /// //////////////////
                  /// Reps Input Fields (3rd set)
                  /// //////////////////
                  (_providedRepsSet2 > 0 || _currentRepsSet2 > 0)
                      ? Column(children: [
                    Material(
                        color: primaryColor,
                        child: Center(
                            child: SizedBox(
                              height: 45,
                              width: 100,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: TextFormField(
                                    focusNode: _thirdRepsFocusNode,
                                    style: TextStyle(
                                        color: (_providedRepsSet3 != _currentRepsSet3)
                                            ? primaryAccentColor
                                            : appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      setState(() {
                                        _thirdRepsHintTextShowing = false;
                                      });
                                    },
                                    onChanged: (value) {
                                      if (value != '') {
                                        setState(() {
                                          _providedRepsSet3 = int.parse(value);
                                          _thirdRepsProvided = true;
                                        });
                                      }
                                      if (value == '') {
                                        // Useful if the text field was added to and deleted
                                        setState(() {
                                          _providedRepsSet3 = 0;
                                          _thirdRepsProvided = false;
                                        });
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    decoration: InputDecoration(
                                      hintText: _thirdRepsHintTextShowing
                                          ? _editMode ? _currentRepsSet3.toString() : '00'
                                          : '',
                                      hintStyle: TextStyle(
                                        fontSize: 25,
                                        color: appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                      ),
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                      LengthLimitingTextInputFormatter(2), // 4 digits at most
                                    ],
                                  )),
                            ))
                    ),
                    SizedBox(height: 5),
                    Text("Reps (3rd)",
                        style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                            color: textColorOverwrite ? Colors.black : primaryColor
                        )),
                  ])
                      : SizedBox(width: 100),


                  Spacer(),

                  /// //////////////////
                  /// Reps Input Fields (4th set)
                  /// //////////////////
                  (_providedRepsSet3 > 0 || _currentRepsSet3 > 0)
                      ? Column(children: [
                    Material(
                        color: primaryColor,
                        child: Center(
                            child: SizedBox(
                              height: 45,
                              width: 100,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: TextFormField(
                                    focusNode: _fourthRepsFocusNode,
                                    style: TextStyle(
                                        color: (_providedRepsSet4 != _currentRepsSet4)
                                            ? primaryAccentColor
                                            : appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    onTap: () {
                                      setState(() {
                                        _fourthRepsHintTextShowing = false;
                                      });
                                    },
                                    onChanged: (value) {
                                      if (value != '') {
                                        setState(() {
                                          _providedRepsSet4 = int.parse(value);
                                          _fourthRepsProvided = true;
                                        });
                                      }
                                      if (value == '') {
                                        // Useful if the text field was added to and deleted
                                        setState(() {
                                          _providedRepsSet4 = 0;
                                          _fourthRepsProvided = false;
                                        });
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    decoration: InputDecoration(
                                      hintText: _fourthRepsHintTextShowing
                                          ? _editMode ? _currentRepsSet4.toString() : '00'
                                          : '',
                                      hintStyle: TextStyle(
                                        fontSize: 25,
                                        color: appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                      ),
                                    ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                      LengthLimitingTextInputFormatter(2), // 4 digits at most
                                    ],
                                  )),
                            ))
                    ),
                    SizedBox(height: 5),
                    Text("Reps (4th)",
                        style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                            color: textColorOverwrite ? Colors.black : primaryColor
                        )),
                  ])
                      : SizedBox(width: 100),

                  Spacer(),
                ]),
              ]),

              _editMode
                  ? SizedBox(height: 15)
                  : SizedBox(height: 5),

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
                          SizedBox(height: 5),
                          //////////////////
                          /// Delete Button
                          //////////////////
                          GestureDetector(
                              onLongPress: () {
                                HapticFeedback.mediumImpact();

                                deleteWeightedWorkout();
                                widget.updateTable();
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
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(
                                fontFamily: 'AstroSpace',
                                color: Colors.red.shade600,
                                fontSize: 18,
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
                            ? (_exerciseProvided || _dateProvided || _weightProvided ||
                            _firstRepsProvided || _secondRepsProvided || _thirdRepsProvided || _fourthRepsProvided) ? () {
                          /// Edit Mode
                          // widget.audio.setVolume(_appVolume);
                          // widget.audio.setReleaseMode(ReleaseMode.stop);
                          // if (!appCurrentlyMuted && saveButtonAudioCurrentlyEnabled) {
                          //   widget.audio.play(AssetSource(audioForSaveButton));
                          //   widget.audio.setReleaseMode(ReleaseMode.stop);
                          // }

                          // Update Weight Record
                          updateWeightedWorkout();
                          HapticFeedback.mediumImpact();
                          widget.updateTable();
                          Navigator.of(context).pop(true);
                        }
                                : null
                            : (_exerciseProvided && _dateProvided && _weightProvided && _firstRepsProvided) ? () {
                          /// New Log Mode
                          // widget.audio.setVolume(_appVolume);
                          // widget.audio.setReleaseMode(ReleaseMode.stop);
                          // if (!appCurrentlyMuted && saveButtonAudioCurrentlyEnabled) {
                          //   widget.audio.play(AssetSource(audioForSaveButton));
                          //   widget.audio.setReleaseMode(ReleaseMode.stop);
                          // }


                          insertWeightedWorkout();
                          HapticFeedback.mediumImpact();
                          widget.updateTable();
                        }
                                : null,
                         // If all settings haven't updated, Disable Save Button
                      ),

                      /// Save Text Description
                      Text(
                        'Save',
                        style: TextStyle(
                          fontFamily: 'AstroSpace',
                          color: _editMode
                          ? (_exerciseProvided || _dateProvided || _weightProvided ||
                              _firstRepsProvided || _secondRepsProvided || _thirdRepsProvided || _fourthRepsProvided)
                              ? primaryAccentColor
                              : Colors.grey
                          : (_exerciseProvided && _dateProvided && _weightProvided && _firstRepsProvided)
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
    )
    );
  }
}

////////////////////////////////////////////
// Widget for Add & Edit Exercise Dialog
////////////////////////////////////////////
class AddExerciseEditExerciseDialog extends StatefulWidget {
  final Function() closeNewLogsMenu;
  String header;
  final String initialExerciseName;

  AddExerciseEditExerciseDialog({
      required this.closeNewLogsMenu,
      required this.header,
      required this.initialExerciseName,
      super.key,
  });

  @override
  AddExerciseEditExerciseDialogState createState() => AddExerciseEditExerciseDialogState();
}

class AddExerciseEditExerciseDialogState extends State<AddExerciseEditExerciseDialog> {
  // Determine if Cardio or Weighted Workout
  bool cardioExercise = false;

  bool enableConfirmButton = false;

  int maxExerciseStringLength = 15;
  late String initialExerciseName;
  String newExerciseName = '';

  // Provided Variables are displayed in edit mode and represent current settings
  late bool editMode;
  String currentExerciseName = '';
  bool _hintTextShowing = true;
  FocusNode _hintTextFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    _hintTextFocusNode.addListener(() => _handleFocusChange(_hintTextFocusNode, 'weight'));

    if (widget.header == 'Add Exercise') {
      editMode = false;
    } else {
      editMode = true;
      currentExerciseName = widget.initialExerciseName;
    }
  }

  @override
  void dispose() {
    _hintTextFocusNode.dispose();
    super.dispose();
  }

  _handleFocusChange(FocusNode focusNode, String textField) {
    if (!focusNode.hasFocus) {
      setState(() {
        _hintTextShowing = true;
      });
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

  Future<void> insertNewExerciseRecord(String exercise, bool isCardio) async {
    await DatabaseHelper.instance.insertExercise(exercise, isCardio);
  }

  Future<void> updateExerciseRecord(String exercise) async {
    await DatabaseHelper.instance.updateExercise(exercise, widget.initialExerciseName);
  }

  checkConfirmButtonState() {
    enableConfirmButton = false;

    setState(() {
      if (editMode) {
        /// editMode
        if (newExerciseName.isNotEmpty && (newExerciseName.toLowerCase() != currentExerciseName)) {
          enableConfirmButton = true;
        }
      } else {
        /// New Log Mode
        if (newExerciseName.isNotEmpty) {
          enableConfirmButton = true;
        }
      }
    });
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
                    ),
                    child:SizedBox(
                        height: editMode ? 230 : 250,
                        width: 210,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: primaryColor,
                                  width: 1,
                                )
                            ),
                            child:Column(
                              children: [
                                /// Header
                                // Divider(color: primaryColor),
                                SizedBox(height: 10),
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
                                editMode
                                    ? Container()
                                    : Row(children: [
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

                                SizedBox(height: 15),

                                /// Exercise Name Field
                                TextFormField(
                                  focusNode: _hintTextFocusNode,
                                  onTap: () {
                                    _hintTextShowing = false;
                                  },
                                  style: TextStyle(
                                      color: primaryAccentColor,
                                      fontSize: 22),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    newExerciseName = value.toLowerCase();
                                    checkConfirmButtonState();

                                    if (value != '') {
                                      setState(() {
                                        // currentExerciseStringLength = maxExerciseStringLength - value.length;
                                      });
                                    }
                                    if (value == '') {
                                      // Useful if the text field was added to and deleted
                                      setState(() {
                                        // currentExerciseStringLength = maxExerciseStringLength;
                                      });
                                    }
                                  },
                                  onFieldSubmitted: (value) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: _hintTextShowing ?
                                      editMode ? currentExerciseName : 'ex: squat'
                                      : '',
                                    hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: editMode ? Colors.black : Colors.grey,
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

                                editMode ? SizedBox(height: 30)
                                    : SizedBox(height: 10),

                                /// Cancel and Confirm Buttons
                                Row(children: [
                                  const Spacer(),

                                  /// Cancel Button
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

                                  /// Confirm Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: enableConfirmButton ? primaryAccentColor : secondaryColor,
                                      padding: const EdgeInsets.all(4),
                                    ),
                                    onPressed: enableConfirmButton
                                        ? () {
                                      if (editMode) {
                                        /// Edit Mode
                                        String exerciseName = newExerciseName.isNotEmpty ? newExerciseName : currentExerciseName;
                                        updateExerciseRecord(exerciseName);
                                        Navigator.of(context).pop(true);
                                        widget.closeNewLogsMenu(); // TODO Activate
                                      } else {
                                        /// New Log Mode
                                        insertNewExerciseRecord(newExerciseName, cardioExercise);
                                        Navigator.of(context).pop(true);
                                      }
                                    } : null,
                                    child: const Text("Confirm",
                                      style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
                                    )
                                  ),
                                  const Spacer(),
                                ]),
                              ])
                        )
                    ))
            )
        )
    );
  }
}

//////////////////////////////////////
// Widget for all Weighted Exercises
/////////////////////////////////////
class WeightsWidget extends StatefulWidget {
  final Key? key;
  final Function() updateTables;
  final Function() closeMenus;

  WeightsWidget({
    this.key,
    required this.updateTables,
    required this.closeMenus,
  }) : super(key:key);

  @override
  WeightsWidgetState createState() => WeightsWidgetState();
}

class WeightsWidgetState extends State<WeightsWidget> {
    // List<Map> exampleMap = [
  //   {'id': 1, 'name': 'Bench Press',  'cardio': false, 'selected': false},
  //   {'id': 2, 'name': 'Deadlift',  'cardio': false, 'selected': false},
  //   {'id': 3, 'name': 'Jump Rope', 'cardio': true, 'selected': false},
  //   {'id': 4, 'name': 'Squat', 'cardio': false, 'selected': false},
  // ];

  List<Map> exerciseMap = [];
  List<Map> workoutMap = [];
  late String selectedExercise;
  bool subMenuOpen = false;

  // This Widget is shown whenever an individual exercise is selected
  Widget buildTableForSelectedExercise() {
    for (var item in exerciseMap) {
      if (item['selected'] == true) {
        // Check if selected item has Items to build a table from
        if (workoutMap.isEmpty) {
          /// No Logs Found
          return Column(children: [
              Text('No logs found.',
                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 16, color: primaryColor, height: 1.1),
              ),
              SizedBox(height: 5),
              Container(
                width: 175,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      padding: const EdgeInsets.all(4),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text("Hold to Delete",
                        style: TextStyle(fontFamily: 'AstroSpace', color: primaryColor, fontSize: 14, height: 1.1),
                      ),
                      Text(selectedExercise,
                        style: TextStyle(fontFamily: 'AstroSpace', color: primaryColor, fontSize: 14, height: 1.1),
                      )
                    ]),
                    onPressed: () {},
                    onLongPress: () {
                      // Fire DATABASE Event to delete Exercise
                      deleteExercise();
                      widget.closeMenus();
                    },
                  )
              ),

            SizedBox(height: 15),
          ]);
        } else {
          /// There are Items, build table
          // TODO Run if logic on Cardio = true/false
          return Container(
              width: 290,
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: secondaryColor,
                border: Border.all(
                  color: primaryColor,
                  width: 1,
                ),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.4),  // Date
                  1: FlexColumnWidth(1.6),  // Weight
                  2: FlexColumnWidth(3),  // Reps
                  4: FlexColumnWidth(1),   // Edit
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
                                fontSize: 15, color: textColorOverwrite
                                    ? primaryColor
                                    : secondaryAccentColor
                            )),
                        Divider(color: textColorOverwrite
                            ? primaryColor
                            : secondaryAccentColor),
                      ])
                      ),
                      TableCell(child:
                      Column(children: [
                        SizedBox(height: 5),
                        Text('Weight',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: textColorOverwrite
                                    ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                                    : secondaryAccentColor)),
                        Divider(color: textColorOverwrite
                            ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                            : secondaryAccentColor),
                      ])
                      ),
                      TableCell(child:
                      Column(children: [
                        SizedBox(height: 5),
                        Text('Reps',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: textColorOverwrite
                                    ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                                    : secondaryAccentColor)),
                        Divider(color: textColorOverwrite
                            ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                            : secondaryAccentColor),
                      ])
                      ),
                      TableCell(child:
                      Column(children: [
                        SizedBox(height: 5),
                        Text('Edit',
                            style: TextStyle(fontFamily: 'AstroSpace',
                                fontSize: 15, color: textColorOverwrite
                                    ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                                    : secondaryAccentColor)),
                        Divider(color: textColorOverwrite
                            ? appCurrentlyInDarkMode ? Colors.white : Colors.black
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
                                  fontSize: 16, color: primaryColor)
                          ),
                          SizedBox(height: 2),
                          Divider(color: textColorOverwrite
                              ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                              : secondaryAccentColor)
                        ])
                        ),
                        TableCell(child:
                        Column(children: [
                          Text(item['weight'].toString(),
                              style: TextStyle(fontFamily: 'AstroSpace',
                                  fontSize: 17, color: primaryColor)),
                          Divider(color: textColorOverwrite
                              ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                              : secondaryAccentColor)
                        ])
                        ),
                        TableCell(child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              // Dynamically show reps
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Text(item['rep1'].toString(),
                                  style: TextStyle(fontFamily: 'AstroSpace',
                                      fontSize: 17, color: primaryColor)
                                ),

                                // Check if there is a 2nd rep for this log
                                item['rep2'] > 0
                                  ? Row(children: [
                                      Text('|',
                                          style: TextStyle(fontFamily: 'AstroSpace',
                                              fontSize: 19, color: textColorOverwrite
                                                  ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                                                  : secondaryAccentColor)
                                      ),

                                      Text(item['rep2'].toString(),
                                        style: TextStyle(fontFamily: 'AstroSpace',
                                            fontSize: 17, color: primaryColor)
                                        )
                                  ])
                                    : Container(),

                                // Check if there is a 3rd rep for this log
                                item['rep3'] > 0
                                    ? Row(children: [
                                  Text('|',
                                      style: TextStyle(fontFamily: 'AstroSpace',
                                          fontSize: 19, color: textColorOverwrite
                                              ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                                              : secondaryAccentColor)
                                  ),
                                  Text(item['rep3'].toString(),
                                      style: TextStyle(fontFamily: 'AstroSpace',
                                          fontSize: 17, color: primaryColor)
                                  )
                                ])
                                    : Container(),

                                // Check if there is a 4th rep for this log
                                item['rep4'] > 0
                                    ? Row(children: [
                                  Text('|',
                                      style: TextStyle(fontFamily: 'AstroSpace',
                                          fontSize: 19, color: textColorOverwrite
                                              ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                                              : secondaryAccentColor)
                                  ),
                                  Text(item['rep4'].toString(),
                                      style: TextStyle(fontFamily: 'AstroSpace',
                                          fontSize: 17, color: primaryColor)
                                  )
                                ])
                                    : Container(),
                              ]),


                              // Bottom Divider
                              Divider(color: textColorOverwrite
                                  ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                                  : secondaryAccentColor),

                              item['rep2'] > 0
                                ? SizedBox(height: 2)
                                : Container(),
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

                                      return Scaffold(
                                          backgroundColor: secondaryColor,
                                          resizeToAvoidBottomInset: true,
                                          appBar: AppBar(
                                            backgroundColor: primaryAccentColor,
                                            centerTitle: true,
                                            title: Text('Edit Log', style: TextStyle(
                                                color: textColorOverwrite
                                                    ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                                    : alternateColorOverwrite ? Colors.black
                                                    : Colors.white
                                            ),
                                            ),
                                            leading: IconButton(
                                              icon: Icon(Icons.arrow_back, color: textColorOverwrite
                                                  ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                                  : alternateColorOverwrite ? Colors.black
                                                  : Colors.white),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            actions: [
                                              IconButton(
                                                icon: Icon(Icons.calculate_outlined, color: textColorOverwrite
                                                    ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                                                    : alternateColorOverwrite ? Colors.black
                                                    : Colors.white
                                                ),
                                                onPressed: () {
                                                  // Launch Plate Calculator
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
                                                        child: PlateCalculator(key: UniqueKey()),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          body: Center(child:
                                            NewLogEditLogWidget(updateTable: getExercises, closeNewLogsMenu: widget.closeMenus, header: 'Edit Log', id: item['id'])
                                          )
                                          );

                                    },
                                  ).then((restartRequired) {
                                    if (restartRequired == true) {
                                      // TODO Determine if updates needs to be refreshed
                                    }
                                  });

                                },
                                child: Column(children: [
                                  Icon(Icons.edit, size: 20, color: primaryColor),
                                  Divider(color: textColorOverwrite
                                      ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                                      : secondaryAccentColor),
                                  SizedBox(height: 1),
                                ]))
                        ),
                      ],
                    )
                ],
              )
          );
        }
      }
    }
    return Container();
  }

  Future<void> getExercises() async {
    final items = await DatabaseHelper.instance.getMapOfUniqueExerciseNames();

    setState(() {
      exerciseMap = items;

      if (subMenuOpen) {
        getWorkouts();
        int index = exerciseMap.indexWhere((exercise) => exercise['name'] == selectedExercise);

        if (index != -1) {
          exerciseMap[index]['selected'] = true;
        }
      }
    });
  }

  Future<void> getWorkouts() async {
    final items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise);

    setState(() {
      workoutMap = items;
    });
  }

  Future<void> deleteExercise() async {
    await DatabaseHelper.instance.deleteExercise(selectedExercise);
  }

  @override
  void initState() {
    super.initState();
    getExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: subMenuOpen ? 500 : 300,
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
                                          return AddExerciseEditExerciseDialog(
                                            closeNewLogsMenu: widget.closeMenus,
                                              header: 'Edit Exercise',
                                              initialExerciseName: exerciseMap[i]['name'],
                                          );
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

                            /// Each Exercise Row
                            Container(
                            width: 250,
                            height: 50,
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
                                    exerciseMap[i]['selected'] = !exerciseMap[i]['selected'];
                                    selectedExercise = exerciseMap[i]['name'];
                                    subMenuOpen = exerciseMap[i]['selected'];

                                    getWorkouts();
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
                            : SizedBox(height: 4),
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

////////////////////////////////////
// Widget for all Cardio Exercises
////////////////////////////////////
class CardioWidget extends StatefulWidget {
  const CardioWidget({
    super.key,
  });

  @override
  CardioWidgetState createState() => CardioWidgetState();
}

class CardioWidgetState extends State<CardioWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 50),
      Text("Hello from Cardio Widget"),
      SizedBox(height: 50),
    ],);
  }
}
