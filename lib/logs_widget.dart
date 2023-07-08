import 'Config/settings.dart';
import 'new_log_edit_log_widget.dart';
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

class LogsWidgetState extends State<LogsWidget> {
  bool _mainFilterWeights = false;
  bool _mainFilterCardio = false;
  bool _mainFilterDate = false;
  bool _displayNewLogsWidget = false;

  final GlobalKey<WeightsWidgetState> _keyWeights = GlobalKey<WeightsWidgetState>();
  final GlobalKey<CardioWidgetState> _keyCardio = GlobalKey<CardioWidgetState>();

  // In order to get the inner tables to update dynamically from various places,
  //    we need this method accessible on the parent
  void updateTablesAfterSubmission() {
    // TODO Display popup message of submission

    setState(() {
      _displayNewLogsWidget = false;
      // _mainFilterWeights = false;
      // _mainFilterCardio = false;
      // _mainFilterDate = false;

      _keyWeights.currentState?.getExercises();
      _keyCardio.currentState?.getExercises();
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
                    ? NewLogEditLogWidget(
                        updateTable: updateTablesAfterSubmission,
                        closeNewLogsMenu: closeMenusAfterExerciseSubmission,
                        header: 'New Log',
                        id: null,
                        exerciseType: null,
                )
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
                    ? CardioWidget(key: _keyCardio, updateTables: updateTablesAfterSubmission, closeMenus: closeMenusAfterExerciseSubmission)
                    : Container(),

                // Determine if Date Widget should show:
                _mainFilterDate
                    ? DatesWidget()
                    : Container(),

                // Determine if Weights Widget should show:
                _mainFilterWeights
                    ? WeightsWidget(key: _keyWeights, updateTables: updateTablesAfterSubmission, closeMenus: closeMenusAfterExerciseSubmission)
                    : Container(),

                /// Prompt user to select a Category
                (!_mainFilterWeights && !_mainFilterDate && !_mainFilterCardio)
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
    _hintTextFocusNode.addListener(() => _handleFocusChange(_hintTextFocusNode));

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

  _handleFocusChange(FocusNode focusNode) {
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
  List<Map> weightedWorkoutMap = [];
  late String selectedExercise;
  bool subMenuOpen = false;
  bool newestItemsFirst = sortLogByNewest;

  // This Widget is shown whenever an individual exercise is selected
  Widget buildTableForSelectedExercise() {
    for (var item in exerciseMap) {
      if (item['selected'] == true) {
        // Check if selected item has Items to build a table from
        if (weightedWorkoutMap.isEmpty) {
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
                  for (var item in weightedWorkoutMap)
                    TableRow(
                      children: [
                        TableCell(child:
                        Column(children: [
                          Text(formatDateForTable(item['date']),
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
                                            NewLogEditLogWidget(
                                                updateTable: getExercises,
                                                closeNewLogsMenu: widget.closeMenus,
                                                header: 'Edit Log',
                                                id: item['id'],
                                                exerciseType: 'Weighted',
                                            )
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

  formatDateForTable(date) {
    var dateArray = date.split('/');
    var _month = dateArray[0];
    var _day = dateArray[1];

    if (_month.startsWith('0')) {
      // Remove Leading 0s in the month for proper table formatting/spacing
      _month = _month.substring(1);
    }
    if (_day.startsWith('0')) {
      // Remove Leading 0s in the day for proper table formatting/spacing
      _day = _day.substring(1);
    }

    return "$_month/$_day";
  }

  Future<void> getExercises() async {
    final items = await DatabaseHelper.instance.getMapOfUniqueWeightedExerciseNames();

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
    List<Map<String, dynamic>> items;

    if (newestItemsFirst) {
      items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, false, 'date DESC');
    } else {
      items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, false, 'date ASC');
    }

    setState(() {
      weightedWorkoutMap = items;
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Divider(color: primaryColor),
              Row(children: [
                Text("Sort By: ", style: TextStyle(fontFamily: 'AstroSpace',
                      fontSize: 16, color: primaryColor)
              ),
                SizedBox(width: 30),
                DropdownButton<String>(
                  dropdownColor: secondaryAccentColor,
                  value: newestItemsFirst ? 'Newest First' : 'Oldest First',
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue == 'Newest First') {
                        newestItemsFirst = true;
                        sortLogByNewest = true;
                        setBooleanSetting('sortLogByNewest', true);
                      } else {
                        newestItemsFirst = false;
                        sortLogByNewest = false;
                        setBooleanSetting('sortLogByNewest', false);
                      }

                      if (subMenuOpen) {
                        getWorkouts();
                      }
                    });
                  },
                  items: <String>[
                    'Newest First',
                    'Oldest First',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                          value,
                          style: TextStyle(fontFamily: 'AstroSpace',
                              fontSize: 16, color: primaryColor)
                      ),
                    );
                  }).toList(),
                )
              ]),
              Divider(color: primaryColor),

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

////////////////////////////////////
// Widget for all Cardio Exercises
////////////////////////////////////
class CardioWidget extends StatefulWidget {
  final Key? key;
  final Function() updateTables;
  final Function() closeMenus;

  const CardioWidget({
    this.key,
    required this.updateTables,
    required this.closeMenus,
  }) : super(key:key);

  @override
  CardioWidgetState createState() => CardioWidgetState();
}

class CardioWidgetState extends State<CardioWidget> {
  List<Map> exerciseMap = [];
  List<Map> cardioWorkoutMap = [];
  late String selectedExercise;
  bool subMenuOpen = false;
  bool newestItemsFirst = sortLogByNewest;

  // This Widget is shown whenever an individual exercise is selected
  Widget buildTableForSelectedExercise() {
    for (var item in exerciseMap) {
      if (item['selected'] == true) {
        // Check if selected item has Items to build a table from
        if (cardioWorkoutMap.isEmpty) {
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
                  1: FlexColumnWidth(2),  // Work
                  2: FlexColumnWidth(2),    // Rest
                  3: FlexColumnWidth(2),    // Interval
                  4: FlexColumnWidth(1.2),    // Edit
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  /// Table Header
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
                        Text('Work',
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
                        Text('Rest',
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
                        Text('Sets',
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
                  for (var item in cardioWorkoutMap)
                    TableRow(
                      children: [
                        TableCell(child:
                        Column(children: [
                          Text(formatDateForTable(item['date']),
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
                          Text(formatTimeForTable(item['workTime']),
                              style: TextStyle(fontFamily: 'AstroSpace',
                                  fontSize: 17, color: primaryColor)),
                          Divider(color: textColorOverwrite
                              ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                              : secondaryAccentColor)
                        ])
                        ),
                        TableCell(child:
                        Column(children: [
                          Text(formatTimeForTable(item['restTime']),
                              style: TextStyle(fontFamily: 'AstroSpace',
                                  fontSize: 17, color: primaryColor)),
                          Divider(color: textColorOverwrite
                              ? appCurrentlyInDarkMode ? Colors.white : Colors.black
                              : secondaryAccentColor)
                        ])
                        ),
                        TableCell(child:
                        Column(children: [
                          Text(item['intervals'].toString(),
                              style: TextStyle(fontFamily: 'AstroSpace',
                                  fontSize: 17, color: primaryColor)),
                          Divider(color: textColorOverwrite
                              ? appCurrentlyInDarkMode ? Colors.white : Colors.black
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
                                          NewLogEditLogWidget(
                                            updateTable: getExercises,
                                            closeNewLogsMenu: widget.closeMenus,
                                            header: 'Edit Log',
                                            id: item['id'],
                                            exerciseType: 'Cardio',
                                          )
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

  formatDateForTable(date) {
    var dateArray = date.split('/');
    var _month = dateArray[0];
    var _day = dateArray[1];

    if (_month.startsWith('0')) {
      // Remove Leading 0s in the month for proper table formatting/spacing
      _month = _month.substring(1);
    }
    if (_day.startsWith('0')) {
      // Remove Leading 0s in the day for proper table formatting/spacing
      _day = _day.substring(1);
    }

    return "$_month/$_day";
  }

  // If a string is longer than 3 chars, we assume we are in Minutes
  // Convert given string to reflect that
  formatTimeForTable(time) {
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

  Future<void> getExercises() async {
    final items = await DatabaseHelper.instance.getMapOfUniqueCardioExerciseNames();

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
    List<Map<String, dynamic>> items;
    if (newestItemsFirst) {
      items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, true, 'date DESC');
    } else {
      items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, true, 'date ASC');
    }

    setState(() {
      cardioWorkoutMap = items;
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Divider(color: primaryColor),
              Row(children: [
                Text("Sort By: ", style: TextStyle(fontFamily: 'AstroSpace',
                    fontSize: 16, color: primaryColor)
                ),
                SizedBox(width: 30),
                DropdownButton<String>(
                  dropdownColor: secondaryAccentColor,
                  value: newestItemsFirst ? 'Newest First' : 'Oldest First',
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue == 'Newest First') {
                        newestItemsFirst = true;
                        sortLogByNewest = true;
                        setBooleanSetting('sortLogByNewest', true);
                      } else {
                        newestItemsFirst = false;
                        sortLogByNewest = false;
                        setBooleanSetting('sortLogByNewest', false);
                      }

                      if (subMenuOpen) {
                        getWorkouts();
                      }
                    });
                  },
                  items: <String>[
                    'Newest First',
                    'Oldest First',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                          value,
                          style: TextStyle(fontFamily: 'AstroSpace',
                              fontSize: 16, color: primaryColor)
                      ),
                    );
                  }).toList(),
                )
              ]),
              Divider(color: primaryColor),

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

  List<String> exerciseMap = ['squat', 'treadmill', 'jump rope'];
  String selectedValue = 'test';

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
      //     final data2 = await DatabaseHelper.instance.query('cardio_workouts');
      //     print(data2);
      //   },
      // ),
      // SizedBox(height: 50),
      // ElevatedButton(
      //   child: Text('Read Data'),
      //   onPressed: () async {
      //     var exerciseQuery = await DatabaseHelper.instance.query('exercises');
      //     print('Exercises: ');
      //     print(exerciseQuery);
      //
      //     exerciseMap = List<String>.from(exerciseQuery.map((map) => map['name'] as String));
      //
      //     print('map: ');
      //     print(exerciseMap);
      //
          // final data3 = await DatabaseHelper.instance.query('weighted_workouts');
          // print('weighted_workouts: ');
          // print(data3);
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