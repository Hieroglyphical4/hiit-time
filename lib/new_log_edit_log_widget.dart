import 'dart:async';
import 'logs_widget.dart';
import 'Config/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Database/database_helper.dart';
import 'package:flutter/cupertino.dart';

///////////////////////////////////
// Widget for New & Edit Log
///////////////////////////////////
class NewLogEditLogWidget extends StatefulWidget {
  final Function() updateTable;
  final Function() closeNewLogsMenu;
  String header; // Either New Log or Edit Log
  final id; // Id of Workout Record
  var exerciseType; // Cardio | Weighted | null

  NewLogEditLogWidget({
    super.key,
    required this.updateTable,
    required this.closeNewLogsMenu,
    required this.header,
    required this.id,
    required this.exerciseType
  });

  @override
  NewLogEditLogWidgetState createState() => NewLogEditLogWidgetState();
}

/// This Widget is used for both Weighted and Cardio Workouts
///     PrimaryValue = weight/workTime
///     SecondaryValue = rep1/restTime
///     ThirdFieldValue = rep2/intervals
///     FourthFieldValue = rep3/intensity
///     FifthFieldValue = rep4
class NewLogEditLogWidgetState extends State<NewLogEditLogWidget> {
  // Text Displayed on Dropdown Menu
  String? _selectedExercise;

  // These are Edit Mode Variables and are the log field Initial Values
  late bool _editMode;
  String? _currentExercise;
  String _currentExerciseText = ' Exercise'; // Added to avoid error on null check during initial render
  String? _currentDate;
  int _currentPrimaryValue = 0;
  int _currentSecondaryValue = 0;
  int _currentThirdFieldValue = 0;
  int _currentFourthFieldValue = 0;
  int _currentFifthFieldValue = 0;

  // These are the variables for user provided values
  String? _providedExercise;
  String? _providedDate;
  String? _providedPrimaryValue;
  int _providedSecondaryValue = 0;
  int _providedThirdFieldValue = 0;
  int _providedFourthFieldValue = 0;
  int _providedFifthFieldValue = 0;

  // Initialize dropdown menu to avoid errors
  List<String> dropdownItems = <String>[''];

  // counts how many fields the user has supplied to determine if save button should show
  bool _exerciseProvided = false;
  bool _dateProvided = false;
  bool _primaryValueProvided = false;
  bool _secondaryValueProvided = false;
  bool _thirdFieldValueProvided = false;
  bool _fourthFieldValueProvided = false;
  bool _fifthFieldValueProvided = false;

  // Shows and Hides the Hint text for fields you type into
  bool _primaryValueHintTextShowing = true;
  bool _secondaryValueHintTextShowing = true;
  bool _thirdFieldValueHintTextShowing = true;
  bool _fourthFieldValueHintTextShowing = true;
  bool _fifthFieldValueHintTextShowing = true;

  FocusNode _primaryFocusNode = FocusNode();
  FocusNode _secondaryFocusNode = FocusNode();
  FocusNode _thirdFieldFocusNode = FocusNode();
  FocusNode _fourthFieldFocusNode = FocusNode();
  FocusNode _fifthFieldFocusNode = FocusNode();

  _handleFocusChange(FocusNode focusNode, String textField) {
    if (!focusNode.hasFocus) {
      setState(() {
        textField == 'primary' ? _primaryValueHintTextShowing = true : null;
        textField == 'secondary' ? _secondaryValueHintTextShowing = true : null;
        textField == 'thirdField' ? _thirdFieldValueHintTextShowing = true : null;
        textField == 'fourthField' ? _fourthFieldValueHintTextShowing = true : null;
        textField == 'fifthField' ? _fifthFieldValueHintTextShowing = true : null;
      });
    }
  }

  // Create a function that shows the date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _currentDate != null ?
        DateTime(
            int.parse((_currentDate!).substring(6, 11)), // year
            int.parse((_currentDate!).substring(0, 2)),  // month
            int.parse((_currentDate!).substring(3, 5))   // day
        )
            : DateTime.now(),
        firstDate: DateTime(2022, 1),
        lastDate: DateTime.now());

    if (picked != null && picked != _providedDate) {
      // We are grabbing the current time so that if workouts are on the same day,
      //    they will be shown on the table in the order they were entered
      final DateTime currentTime = DateTime.now();
      final String timestamp =
          "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}:${currentTime.second.toString().padLeft(2, '0')}";

      setState(() {
        if (_providedDate == null) {
          _dateProvided = true;
        }

        _providedDate = "${picked.month.toString().padLeft(2,'0')}/${picked.day.toString().padLeft(2,'0')}/${picked.year.toString()} $timestamp";
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
      _primaryFocusNode.addListener(() => _handleFocusChange(_primaryFocusNode, 'primary'));
      _secondaryFocusNode.addListener(() => _handleFocusChange(_secondaryFocusNode, 'secondary'));
      _thirdFieldFocusNode.addListener(() => _handleFocusChange(_thirdFieldFocusNode, 'thirdField'));
      _fourthFieldFocusNode.addListener(() => _handleFocusChange(_fourthFieldFocusNode, 'fourthField'));
      _fifthFieldFocusNode.addListener(() => _handleFocusChange(_fifthFieldFocusNode, 'fifthField'));
    }
  }

  @override
  void dispose() {
    _primaryFocusNode.dispose();
    _secondaryFocusNode.dispose();
    _thirdFieldFocusNode.dispose();
    _fourthFieldFocusNode.dispose();
    _fifthFieldFocusNode.dispose();
    primaryValueTextEditController.dispose();
    secondaryValueTextEditController.dispose();
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
    var workout;

    // Check for Cardio or Weighted
    if (widget.exerciseType == 'Cardio') {
      workout = await DatabaseHelper.instance.getCardioWorkout(widget.id);
    } else {
      workout = await DatabaseHelper.instance.getWeightedWorkout(widget.id);
    }

    final Map<String, dynamic> workoutFields = workout.first;

    setState(() {
      // Set Universal Fields
      _currentExercise = workoutFields['exerciseName'];
      _currentExerciseText = _currentExercise!;
      _currentDate = workoutFields['date'];

      if (widget.exerciseType == 'Cardio') {
        _currentPrimaryValue = workoutFields['workTime'];
        _currentSecondaryValue = workoutFields['restTime'];
        _currentThirdFieldValue = workoutFields['intervals'];

        // Cardio doesn't have a 5th input field
        // _currentFifthFieldValue = workoutFields['null']; // TODO Test what needs to be set here
      } else {
        _currentPrimaryValue = workoutFields['weight'];
        _currentSecondaryValue = workoutFields['rep1'];
        _currentThirdFieldValue = workoutFields['rep2'];
        _currentFourthFieldValue = workoutFields['rep3'];
        _currentFifthFieldValue = workoutFields['rep4'];
      }
    });
  }

  void setExerciseType(String exerciseName) async {
    final currentExerciseType = widget.exerciseType;
    var cardioWorkout = await DatabaseHelper.instance.isExerciseCardio(exerciseName);

    // Determine if Widget should display Cardio or Weighted Fields.
    setState(() {
      if (cardioWorkout == 0) {
        widget.exerciseType = 'Weighted';
      } else {
        widget.exerciseType = 'Cardio';
      }

      // Check if we switched from Cardio to Weighted (or vise-versa)
        // If so, clear inputs
      if (currentExerciseType!=null && currentExerciseType != widget.exerciseType) {
        _primaryValueProvided = false;
        _providedPrimaryValue = null;
        _secondaryValueProvided = false;
        _providedSecondaryValue = 0;
        _thirdFieldValueProvided = false;
        _providedThirdFieldValue = 0;
        _fourthFieldValueProvided = false;
        _providedFourthFieldValue = 0;
        _fifthFieldValueProvided = false;
        _providedFifthFieldValue = 0;

        primaryValueTextEditController.clear();
        secondaryValueTextEditController.clear();
      }
    });
  }

  ///////////////////////////////////////////
  // Database Methods for Weighted Workouts
  ///////////////////////////////////////////
  Future<int> insertWeightedWorkout() async {

    // Prevent later sets from being stored if previous ones were cancelled:
    if (_providedThirdFieldValue == 0) {
      _providedFourthFieldValue = 0;
      _providedFifthFieldValue = 0;
    }
    if (_providedFourthFieldValue == 0) {
      _providedFifthFieldValue = 0;
    }

    Map<String, dynamic> data = {
      'exerciseId' : '', // will be updated in database_helper
      'date': _providedDate,
      'weight': _providedPrimaryValue,
      'rep1': _providedSecondaryValue,
      'rep2': _providedThirdFieldValue,
      'rep3': _providedFourthFieldValue,
      'rep4': _providedFifthFieldValue,
    };

    return await DatabaseHelper.instance.insertWorkout('weighted_workouts', data, _providedExercise!);
  }

  Future<int> updateWeightedWorkout() async {

    // Prevent later sets from being stored if previous ones were cancelled:
    if (_thirdFieldValueProvided && _providedThirdFieldValue == 0) {
      _providedFourthFieldValue = 0;
      _currentFourthFieldValue = 0;
      _providedFifthFieldValue = 0;
      _currentFifthFieldValue = 0;
    }
    if (_fourthFieldValueProvided && _providedFourthFieldValue == 0) {
      _providedFifthFieldValue = 0;
      _currentFifthFieldValue = 0;
    }

    Map<String, dynamic> data = {
      'exerciseId' : '', // will be updated in database_helper
      'date': _providedDate ?? _currentDate,
      'weight': _providedPrimaryValue ?? _currentPrimaryValue,
      'rep1': _secondaryValueProvided ? _providedSecondaryValue : _currentSecondaryValue,
      'rep2': _thirdFieldValueProvided ? _providedThirdFieldValue : _currentThirdFieldValue,
      'rep3': _fourthFieldValueProvided ? _providedFourthFieldValue : _currentFourthFieldValue,
      'rep4': _fifthFieldValueProvided ? _providedFifthFieldValue : _currentFifthFieldValue,
    };

    var exercise = _providedExercise ?? _currentExercise;

    return await DatabaseHelper.instance.updateWorkout(data, exercise!, widget.id, 'weighted_workouts');
  }

  deleteWeightedWorkout() async {
    return await DatabaseHelper.instance.delete('weighted_workouts', widget.id);
  }

  /////////////////////////////////////////
  // Database Methods for Cardio Workouts
  /////////////////////////////////////////
  Future<int> insertCardioWorkout() async {
    Map<String, dynamic> data = {
      'exerciseId' : '', // will be updated in database_helper
      'date': _providedDate,
      'workTime': _providedPrimaryValue,
      'restTime': _providedSecondaryValue,
      'intervals': _providedThirdFieldValue
    };

    return await DatabaseHelper.instance.insertWorkout('cardio_workouts', data, _providedExercise!);
  }

  // Update cardio record
  Future<int> updateCardioWorkout() async {
    Map<String, dynamic> data = {
      'exerciseId' : '', // will be updated in database_helper
      'date': _providedDate ?? _currentDate,
      'workTime': _providedPrimaryValue ?? _currentPrimaryValue,
      'restTime': _secondaryValueProvided ? _providedSecondaryValue : _currentSecondaryValue,
      'intervals': _thirdFieldValueProvided ? _providedThirdFieldValue : _currentThirdFieldValue,
    };

    var exercise = _providedExercise ?? _currentExercise;

    return await DatabaseHelper.instance.updateWorkout(data, exercise!, widget.id, 'cardio_workouts');
  }

  deleteCardioWorkout() async {
    return await DatabaseHelper.instance.delete('cardio_workouts', widget.id);
  }


  evaluateHintText(String defaultValue, bool hintTextShowing, int currentValue) {
    String? hintText = '';

    // The first If will determine if the text field has focus
      // When clicked into, the hint text should disappear
    if (hintTextShowing) {
      if (_editMode) {
        if (widget.exerciseType=='Cardio') {
          hintText = formatTime(currentValue);
        } else {
          hintText = currentValue.toString();
        }
      } else {
        if (widget.exerciseType=='Cardio') {
          hintText = '00:00';
        } else {
          hintText = defaultValue;
        }
      }
    }

    return hintText;
  }

  // If a string is longer than 3 chars, we assume we are in Minutes
  // Convert given string to reflect that
  formatTime(time) {
    var string = time.toString();
    var length = string.length;

    // Check if string is still in seconds
    if (length <= 2) {
      return string;
    }

    final insertIndex = string.length == 3 ? 1 : 2;
    final substring = string.substring(insertIndex);
    final timeFormatted = insertIndex == 1
        ? "${string[0]}:$substring"
        : "${string[0]}${string[1]}:$substring";

    return timeFormatted;
  }

  final primaryValueTextEditController = TextEditingController();
  final secondaryValueTextEditController = TextEditingController();

  // If a string is longer than 3 chars, we assume we are in Minutes
  // Convert given string to reflect that
  String formatDuration(String minutesRaw) {
    var string = minutesRaw;
    var length = string.length;

    // Check if string is still in seconds
    if (length == 2) {
      return string;
    }

    final insertIndex = string.length == 3 ? 1 : 2;
    final substring = string.substring(insertIndex);
    final timeFormatted = insertIndex == 1
        ? "${string[0]}:$substring"
        : "${string[0]}${string[1]}:$substring";

    return timeFormatted;
  }

  // Helper function that will display little notification overlay at the bottom of the screen
  void _showNotification(BuildContext context, String action) {
    final snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Container(
          height: 33,
          child: action == 'Update'
              /// Check if action is Update.
              ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Log Updated",
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                      color: secondaryColor,
                    )
                ),
              ])
              /// Action isn't Update, check if its Create.
              : action == 'Create'
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New Log Created",
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                            color: secondaryColor,
                          )
                      ),
                    ])
                /// Action isnt Update or Create, assume Delete.
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Log Deleted",
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                            color: secondaryColor,
                          )
                      ),
                    ])
      ),
      duration: Duration(seconds: 3), // Set the duration for how long the SnackBar will be displayed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
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
                          child: Material(
                            color: Colors.white,
                            child: Center(
                              child: DropdownButton<String>(
                                menuMaxHeight: 420,
                                hint: Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 9.0, 0.0, 0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      _editMode
                                          ? Text(
                                        _currentExerciseText,
                                        style: TextStyle(
                                          fontFamily: 'AstroSpace',
                                          fontSize: 16,
                                          color: (_providedExercise == _currentExercise)
                                              ? primaryAccentColor
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                          : Text(
                                        " Exercise",
                                        style: TextStyle(
                                          fontFamily: 'AstroSpace',
                                          fontSize: 16,
                                          color: (_providedExercise != _currentExercise)
                                              ? primaryAccentColor
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                value: _selectedExercise,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    if (_selectedExercise == null) {
                                      _exerciseProvided = true;
                                    }
                                    _selectedExercise = newValue!;
                                    _providedExercise = newValue;
                                    setExerciseType(_selectedExercise!);
                                  });
                                },
                                items: [
                                  for (String value in dropdownItems)
                                    if (value == '--CardioExercisesBegin')
                                      // This value was manually added to the list of items to denote where a divider belongs
                                      DropdownMenuItem<String>(
                                        enabled: false,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(top: 6),
                                              child: Text(
                                                'Cardio:',
                                                style: TextStyle(
                                                  fontFamily: 'AstroSpace',
                                                  fontSize: 18,
                                                  color: primaryAccentColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Divider(color: primaryColor),
                                          ],
                                        ),
                                      )
                                    else if (value == '--WeightedExercisesBegin')
                                    // This value was manually added to the list of items to denote where a divider belongs
                                      DropdownMenuItem<String>(
                                        enabled: false,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(top: 6),
                                              child: Text(
                                                'Weights:',
                                                style: TextStyle(
                                                  fontFamily: 'AstroSpace',
                                                  fontSize: 18,
                                                  color: primaryAccentColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Divider(color: primaryColor),
                                          ],
                                        ),
                                      )
                                    else
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontFamily: 'AstroSpace',
                                            fontSize: 16,
                                            color: textColorOverwrite ? Colors.black : primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                ],
                                icon: Container(),
                                underline: Container(),
                                dropdownColor: secondaryAccentColor,
                                selectedItemBuilder: (BuildContext context) {
                                  return dropdownItems.map<Widget>((String item) {
                                    if (item == '--CardioExercisesBegin') {
                                      return Container();
                                    } else if (item == '--WeightedExercisesBegin') {
                                      return Container();
                                    } else {
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontFamily: 'AstroSpace',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: (_providedExercise != _currentExercise)
                                                  ? primaryAccentColor
                                                  : appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ),

                        //////////////////////////////
                        /// Add Exercise Button    ///
                        //////////////////////////////
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Material(
                              color: Colors.white,
                              child: Center(
                                  child: IconButton(
                                    iconSize: 35,
                                    color: Colors.black,
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
                                            updateNewLogsMenu: widget.updateTable,
                                            header: 'Add Exercise',
                                            initialExerciseName: '',
                                          );
                                        },
                                      ).then((restartRequired) async {
                                        getExercises();

                                        if (restartRequired == true) {
                                          // Refresh exercise dropdown menu
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
                        /// Date and Primary Value Inputs
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
                                        color: Colors.white,
                                        child: TextFormField(
                                          readOnly: true, // set readOnly to true to disable editing of the text field
                                          controller: TextEditingController(
                                            text: _providedDate == null ? '' : _providedDate.toString().split(' ')[0],
                                          ),
                                          style: TextStyle(
                                              color: (_providedDate != _currentDate)
                                                  ? primaryAccentColor
                                                  : Colors.black,
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
                                            hintText: _editMode ? _currentDate.toString().split(' ')[0] : 'mm/dd/yyyy',
                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
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
                              /// Primary Value Input Field
                              /// /////////////////////
                              Column(children: [
                                SizedBox(
                                  height: 45,
                                  width: 100,
                                  child: Material(
                                    color: Colors.white,
                                    child: Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: TextFormField(
                                          focusNode: _primaryFocusNode,
                                          controller: primaryValueTextEditController,
                                          style: TextStyle(
                                              color: (_providedPrimaryValue != _currentPrimaryValue)
                                                  ? primaryAccentColor
                                                  : Colors.black,
                                              fontSize: 25),
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          onTap: () {
                                            setState(() {
                                              _primaryValueHintTextShowing = false;
                                            });
                                          },
                                          onChanged: (value) {
                                            if (value != '') {
                                              setState(() {
                                                if (_providedPrimaryValue == null) {
                                                  _primaryValueProvided = true;
                                                }

                                                if (widget.exerciseType=='Cardio') {
                                                  if (value.length > 2) {
                                                    // Prevent user from pushing 0 into minute section
                                                    if (value[0] == '0') {
                                                      value = value.substring(1,3);
                                                    }
                                                    primaryValueTextEditController.text = formatDuration(value);
                                                    primaryValueTextEditController.selection =
                                                        TextSelection.collapsed(
                                                            offset: primaryValueTextEditController.text.length);
                                                  }
                                                }

                                                _providedPrimaryValue = value;
                                              });
                                            }

                                            if (value == '') {
                                              // Useful if the text field was added to and deleted
                                              setState(() {
                                                _providedPrimaryValue = null;
                                                _primaryValueProvided = false;
                                              });
                                            }
                                          },
                                          onFieldSubmitted: (value) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          },
                                          decoration: InputDecoration(
                                            hintText: evaluateHintText('000', _primaryValueHintTextShowing, _currentPrimaryValue!),
                                            hintStyle: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
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
                                Text(widget.exerciseType=='Cardio' ? "Work Time" : "Weight",
                                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                                        color: textColorOverwrite ? Colors.black : primaryColor
                                    )),
                              ]),

                              Spacer(),
                            ]),

                        SizedBox(height: 15),

                        /// Secondary and Third Value Text Fields
                        Row(children: [
                          Spacer(),

                          /// //////////////////
                          /// Secondary Input Field (1st Rep | Rest Time)
                          /// //////////////////
                          Column(children: [
                            Material(
                                color: Colors.white,
                                child: Center(
                                    child: SizedBox(
                                      height: 45,
                                      width: 100,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: TextFormField(
                                            focusNode: _secondaryFocusNode,
                                            controller: secondaryValueTextEditController,
                                            style: TextStyle(
                                                color: (_providedSecondaryValue != _currentSecondaryValue)
                                                    ? primaryAccentColor
                                                    : Colors.black,
                                                fontSize: 25),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            onTap: () {
                                              setState(() {
                                                _secondaryValueHintTextShowing = false;
                                              });
                                            },
                                            onChanged: (value) {
                                              if (value != '') {
                                                setState(() {
                                                  if (!_secondaryValueProvided) {
                                                    _secondaryValueProvided = true;
                                                  }

                                                  if (widget.exerciseType=='Cardio') {

                                                    if (value.length > 2) {
                                                      // Prevent user from pushing 0 into minute section
                                                      if (value[0] == '0') {
                                                        value = value.substring(1,3);
                                                      }
                                                      secondaryValueTextEditController.text = formatDuration(value);
                                                      secondaryValueTextEditController.selection =
                                                          TextSelection.collapsed(
                                                              offset: secondaryValueTextEditController.text.length);
                                                    }
                                                  }

                                                  _providedSecondaryValue = int.parse(value);
                                                });
                                              }
                                              if (value == '') {
                                                // Useful if the text field was added to and deleted
                                                setState(() {
                                                  _providedSecondaryValue = 0;
                                                  _secondaryValueProvided = false;
                                                });
                                              }
                                            },
                                            onFieldSubmitted: (value) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            decoration: InputDecoration(
                                              hintText: evaluateHintText('00', _secondaryValueHintTextShowing, _currentSecondaryValue),
                                              hintStyle: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                              ),
                                            ),
                                            inputFormatters: widget.exerciseType=='Cardio'
                                              ? <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                                FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                                LengthLimitingTextInputFormatter(4), // 4 digits at most
                                                ]
                                              : <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly, // Only numbers can be entered
                                                FilteringTextInputFormatter.deny(RegExp('^0+')), // Filter leading 0s
                                                LengthLimitingTextInputFormatter(2), // 4 digits at most
                                              ],
                                          )),
                                    ))
                            ),
                            SizedBox(height: 5),
                            Text(widget.exerciseType=='Cardio' ? "Rest Time" : "Reps (1st)",
                                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                                    color: textColorOverwrite ? Colors.black : primaryColor
                                )),
                          ]),

                          Spacer(),

                          /// //////////////////
                          /// Third Value Input Fields (2nd set | Intervals)
                          /// //////////////////
                          (_providedSecondaryValue > 0 || _currentSecondaryValue > 0 || widget.exerciseType=='Cardio')
                              ? Column(children: [
                            Material(
                                color: Colors.white,
                                child: Center(
                                    child: SizedBox(
                                      height: 45,
                                      width: 100,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: TextFormField(
                                            focusNode: _thirdFieldFocusNode,
                                            style: TextStyle(
                                                color: (_providedThirdFieldValue != _currentThirdFieldValue)
                                                    ? primaryAccentColor
                                                    : Colors.black,
                                                fontSize: 25),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            onTap: () {
                                              setState(() {
                                                _thirdFieldValueHintTextShowing = false;
                                              });
                                            },
                                            onChanged: (value) {
                                              if (value != '') {
                                                setState(() {
                                                  _providedThirdFieldValue = int.parse(value);
                                                  _thirdFieldValueProvided = true;
                                                });
                                              }
                                              if (value == '') {
                                                // Useful if the text field was added to and deleted
                                                setState(() {
                                                  _providedThirdFieldValue = 0;
                                                  _thirdFieldValueProvided = false;
                                                });
                                              }
                                            },
                                            onFieldSubmitted: (value) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            decoration: InputDecoration(
                                              hintText: _thirdFieldValueHintTextShowing
                                                  ? _editMode ? _currentThirdFieldValue.toString() : '00'
                                                  : '',
                                              hintStyle: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
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
                            Text(widget.exerciseType=='Cardio' ? "Intervals" : "Reps (2nd)",
                                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 12, height: 1.1, decoration: TextDecoration.none,
                                    color: textColorOverwrite ? Colors.black : primaryColor
                                )),
                          ])
                              : SizedBox(width: 100),

                          Spacer(),
                        ]),

                        SizedBox(height: 15),

                        /// Fourth and Fifth Value Input Fields (3rd and 4th Reps)
                        Row(children: [
                          Spacer(),

                          /// //////////////////
                          /// Fourth Value Input (3rd set)
                          /// //////////////////
                          (widget.exerciseType!='Cardio' && (_providedThirdFieldValue > 0 || _currentThirdFieldValue > 0))
                              ? Column(children: [
                            Material(
                                color: Colors.white,
                                child: Center(
                                    child: SizedBox(
                                      height: 45,
                                      width: 100,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: TextFormField(
                                            focusNode: _fourthFieldFocusNode,
                                            style: TextStyle(
                                                color: (_providedFourthFieldValue != _currentFourthFieldValue)
                                                    ? primaryAccentColor
                                                    : Colors.black,
                                                fontSize: 25),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            onTap: () {
                                              setState(() {
                                                _fourthFieldValueHintTextShowing = false;
                                              });
                                            },
                                            onChanged: (value) {
                                              if (value != '') {
                                                setState(() {
                                                  _providedFourthFieldValue = int.parse(value);
                                                  _fourthFieldValueProvided = true;
                                                });
                                              }
                                              if (value == '') {
                                                // Useful if the text field was added to and deleted
                                                setState(() {
                                                  _providedFourthFieldValue = 0;
                                                  _fourthFieldValueProvided = false;
                                                });
                                              }
                                            },
                                            onFieldSubmitted: (value) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            decoration: InputDecoration(
                                              hintText: _fourthFieldValueHintTextShowing
                                                  ? _editMode ? _currentFourthFieldValue.toString() : '00'
                                                  : '',
                                              hintStyle: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
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
                          (widget.exerciseType!='Cardio' && (_providedFourthFieldValue > 0 || _currentFourthFieldValue > 0))
                              ? Column(children: [
                            Material(
                                color: Colors.white,
                                child: Center(
                                    child: SizedBox(
                                      height: 45,
                                      width: 100,
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: TextFormField(
                                            focusNode: _fifthFieldFocusNode,
                                            style: TextStyle(
                                                color: (_providedFifthFieldValue != _currentFifthFieldValue)
                                                    ? primaryAccentColor
                                                    : Colors.black,
                                                fontSize: 25),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            onTap: () {
                                              setState(() {
                                                _fifthFieldValueHintTextShowing = false;
                                              });
                                            },
                                            onChanged: (value) {
                                              if (value != '') {
                                                setState(() {
                                                  _providedFifthFieldValue = int.parse(value);
                                                  _fifthFieldValueProvided = true;
                                                });
                                              }
                                              if (value == '') {
                                                // Useful if the text field was added to and deleted
                                                setState(() {
                                                  _providedFifthFieldValue = 0;
                                                  _fifthFieldValueProvided = false;
                                                });
                                              }
                                            },
                                            onFieldSubmitted: (value) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            decoration: InputDecoration(
                                              hintText: _fifthFieldValueHintTextShowing
                                                  ? _editMode ? _currentFifthFieldValue.toString() : '00'
                                                  : '',
                                              hintStyle: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
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
                              : widget.exerciseType=='Cardio' ? Container() : SizedBox(width: 100),

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
                                      onLongPress: () async {
                                        HapticFeedback.mediumImpact();

                                        if (widget.exerciseType=='Cardio') {
                                          await deleteCardioWorkout();
                                        } else {
                                          await deleteWeightedWorkout();
                                        }

                                        widget.updateTable();
                                        _showNotification(context, 'Delete');
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
                                        ? (_exerciseProvided || _dateProvided || _primaryValueProvided ||
                                        _secondaryValueProvided || _thirdFieldValueProvided || _fourthFieldValueProvided || _fifthFieldValueProvided) ? () {
                                      /// Edit Mode
                                      // widget.audio.setVolume(_appVolume);
                                      // widget.audio.setReleaseMode(ReleaseMode.stop);
                                      // if (!appCurrentlyMuted && saveButtonAudioCurrentlyEnabled) {
                                      //   widget.audio.play(AssetSource(audioForSaveButton));
                                      //   widget.audio.setReleaseMode(ReleaseMode.stop);
                                      // }

                                      HapticFeedback.mediumImpact();

                                      if (widget.exerciseType=='Cardio') {
                                        updateCardioWorkout();
                                      } else {
                                        updateWeightedWorkout();
                                      }

                                      _showNotification(context, 'Update');
                                      HapticFeedback.mediumImpact();
                                      widget.updateTable();
                                      Navigator.of(context).pop(true);
                                    }
                                        : null
                                        : (_exerciseProvided && _dateProvided && _primaryValueProvided && _secondaryValueProvided) ? () {
                                      /// New Log Mode
                                      // widget.audio.setVolume(_appVolume);
                                      // widget.audio.setReleaseMode(ReleaseMode.stop);
                                      // if (!appCurrentlyMuted && saveButtonAudioCurrentlyEnabled) {
                                      //   widget.audio.play(AssetSource(audioForSaveButton));
                                      //   widget.audio.setReleaseMode(ReleaseMode.stop);
                                      // }

                                      HapticFeedback.mediumImpact();

                                      if (widget.exerciseType=='Cardio') {
                                        insertCardioWorkout();
                                      } else {
                                        insertWeightedWorkout();
                                      }

                                      _showNotification(context, 'Create');
                                      HapticFeedback.mediumImpact();
                                      widget.updateTable();
                                      widget.closeNewLogsMenu();
                                    }
                                        : null, // If all settings haven't updated, Disable Save Button
                                  ),

                                  /// Save Text Description
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                      fontFamily: 'AstroSpace',
                                      color: _editMode
                                          ? (_exerciseProvided || _dateProvided || _primaryValueProvided ||
                                          _secondaryValueProvided || _thirdFieldValueProvided || _fourthFieldValueProvided || _fifthFieldValueProvided)
                                          ? primaryAccentColor
                                          : Colors.grey
                                          : (_exerciseProvided && _dateProvided && _primaryValueProvided && _secondaryValueProvided)
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
