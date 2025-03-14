import 'dart:io';
import 'Config/settings.dart';
import 'package:intl/intl.dart';
import 'new_log_edit_log_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Database/database_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hiit_time/plate_calculator.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool _mainConfigMenu = false;
  bool _displayNewLogsWidget = false;

  final GlobalKey<WeightsWidgetState> _keyWeights = GlobalKey<WeightsWidgetState>();
  final GlobalKey<CardioWidgetState> _keyCardio = GlobalKey<CardioWidgetState>();
  final GlobalKey<NewLogEditLogWidgetState> _keynewLog = GlobalKey<NewLogEditLogWidgetState>();

  // In order to get the inner tables to update dynamically from various places,
  //    we need this method accessible on the parent
  void updateTablesAfterSubmission(String origin) {
    setState(() {
      if (origin != 'newLog') {
        // After a submission, the newLog widget should close so we can avoid
          // refreshing its submenu
        _keynewLog.currentState?.getExercises();
      }

      _keyWeights.currentState?.getExercises();
      _keyCardio.currentState?.getExercises();
    });
  }

  // Exercises didnt seem to update the same as workouts in the tables
  //    Closing menus when those are updated... for now
  void closeMenusAfterExerciseSubmission(String origin) {
    setState(() {
      _keyWeights.currentState?.getExercises();
      _keyCardio.currentState?.getExercises();
      _displayNewLogsWidget = false;
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
                      top: 4,
                      left: 14,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _displayNewLogsWidget ? Colors.red.shade400 : primaryAccentColor,
                            padding: const EdgeInsets.all(4),
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();

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
                              height: 35,
                              child:
                              _displayNewLogsWidget
                                  ? Row(children: [
                                Icon(Icons.highlight_off),
                                SizedBox(width: 5),
                                Text(' Close',
                                    style: TextStyle(fontFamily: 'AstroSpace',
                                        fontSize: 18, color: primaryColor)
                                )
                              ])
                                  : Row(children: [
                                Icon(Icons.add_circle_outline, color: getCorrectColorForComplicatedContext()),
                                SizedBox(width: 5),
                                Text(' New Log',
                                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 18,
                                        color: getCorrectColorForComplicatedContext()
                                    )
                                )
                              ])
                          )
                      ),
                    )
                  ]
                ),

                _displayNewLogsWidget
                    ? NewLogEditLogWidget(key: _keynewLog,
                        updateTable: () => updateTablesAfterSubmission('newLog'),
                        closeNewLogsMenu: () => closeMenusAfterExerciseSubmission("newLog"),
                        header: 'New Log',
                        id: null,
                        exerciseType: null,
                )
                    : Container(),

                // Grey Line
                SizedBox(height: 10),
                SizedBox(height: 1, width: 300, child: Container(color: Colors.grey)),
                SizedBox(height: 10),

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
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: _mainFilterCardio ? primaryColor : Colors.transparent,
                                width: 4,
                              )),
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              HapticFeedback.lightImpact();

                              _mainFilterCardio = !_mainFilterCardio;
                              _mainFilterWeights = false;
                              _mainConfigMenu = false;
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _mainFilterCardio ? Colors.blue : secondaryColor,
                              padding: const EdgeInsets.all(4),
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions_run, color: primaryColor, size: 30),
                                  SizedBox(height: 10),
                                  Text('Cardio',
                                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13, height: 1.1,
                                        color: primaryColor
                                    ),),
                                ]),
                          ),
                        ),
                      ]),

                      Spacer(flex: 1),

                      /// ////////////////
                      /// Config Menu
                      /// ////////////////
                      Column(children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: _mainConfigMenu ? primaryColor : Colors.transparent,
                                width: 4,
                              )),
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              HapticFeedback.lightImpact();

                              _mainConfigMenu = !_mainConfigMenu;
                              _mainFilterWeights = false;
                              _mainFilterCardio = false;
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _mainConfigMenu ? Colors.blue : secondaryColor,
                              padding: const EdgeInsets.all(4),
                            ),
                            child: Icon(Icons.settings, color: primaryColor, size: 30),
                          ),
                        ),
                        SizedBox(height: 5),
                      ]),

                      Spacer(flex: 1),

                      /// ///////////////////
                      /// Filter by Exercise
                      /// ///////////////////
                      Column(children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: _mainFilterWeights ? primaryColor : Colors.transparent,
                                width: 4,
                              )),
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              HapticFeedback.lightImpact();

                              _mainFilterWeights = !_mainFilterWeights;
                              _mainFilterCardio = false;
                              _mainConfigMenu = false;
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _mainFilterWeights ? Colors.blue : secondaryColor,
                              padding: const EdgeInsets.all(4),
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Icon(Icons.fitness_center, color: primaryColor, size: 30),
                              SizedBox(height: 10),
                              Text('Weights',
                                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13, height: 1.1,
                                    color: primaryColor
                                ),),
                            ]),
                          ),
                        ),

                      ]),

                      Spacer(flex: 1),
                    ]),
                ),

                SizedBox(height: 10),
                SizedBox(height: 1, width: 300, child: Container(color: Colors.grey)),
                SizedBox(height: 15),

                // Determine if Cardio Widget should show:
                _mainFilterCardio
                    ? CardioWidget(key: _keyCardio,
                        updateTables: () => updateTablesAfterSubmission('cardio'),
                        closeMenus: () => closeMenusAfterExerciseSubmission('cardio'),
                )
                    : Container(),

                // Determine if Date Widget should show:
                _mainConfigMenu
                    ? LogsConfigWidget()
                    : Container(),

                // Determine if Weights Widget should show:
                _mainFilterWeights
                    ? WeightsWidget(key: _keyWeights,
                        updateTables: () => updateTablesAfterSubmission('weights'),
                        closeMenus: () => closeMenusAfterExerciseSubmission('weights'),
                    )
                    : Container(),

                /// Prompt user to select a Category
                (!_mainFilterWeights && !_mainConfigMenu && !_mainFilterCardio)
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
  final Function() updateNewLogsMenu;
  String header;
  final String initialExerciseName;

  AddExerciseEditExerciseDialog({
      required this.updateNewLogsMenu,
      required this.header,
      required this.initialExerciseName,
      super.key,
  });

  @override
  AddExerciseEditExerciseDialogState createState() => AddExerciseEditExerciseDialogState();
}

class AddExerciseEditExerciseDialogState extends State<AddExerciseEditExerciseDialog> {
  // Allow widget to display without a selected type
  bool exerciseTypeSelected = false;

  // Determine if Exercise is Cardio or Weight Workout
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
      exerciseTypeSelected = true;
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

  void _setExerciseType(String value) {
    setState(() {
      exerciseTypeSelected = true;
      if (value == 'Cardio') {
        cardioExercise = true;
      } else {
        cardioExercise = false;
      }
    });
  }

  Future<void> insertNewExerciseRecord(String exercise, bool isCardio) async {
    await DatabaseHelper.instance.insertExercise(exercise, isCardio);
    _showNotification(context, 'Create');
  }

  Future<void> updateExerciseRecord(String exercise) async {
    await DatabaseHelper.instance.updateExercise(exercise, widget.initialExerciseName);
    _showNotification(context, 'Update');
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
                Text("Exercise Updated",
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                      color: secondaryColor,
                    )
                ),
              ])
              /// Action isn't Update, assume its Create.
              : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New Exercise Created",
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

                                /// Exercise Category Buttons: Cardio and Weight
                                editMode
                                    ? Container()
                                    : Row(children: [
                                        Spacer(),
                                        Container(
                                            height: 40,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: primaryColor,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: ElevatedButton(
                                                onPressed: () => setState(() {
                                                  HapticFeedback.lightImpact();

                                                  _setExerciseType('Cardio');
                                                }),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: exerciseTypeSelected ?
                                                    cardioExercise ? primaryAccentColor : secondaryColor
                                                    : secondaryColor,
                                                  padding: const EdgeInsets.all(4),
                                                ),
                                                child: Text('Cardio',
                                                    style: TextStyle(color: exerciseTypeSelected ?
                                                        cardioExercise ?
                                                          textColorOverwrite ? Colors.black : primaryColor
                                                          : Colors.grey
                                                        : Colors.grey,
                                                        fontSize: 16
                                                    )
                                                ),
                                            )
                                        ),

                                        Spacer(),

                                        Container(
                                            height: 40,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: primaryColor,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: ElevatedButton(
                                              onPressed: () => setState(() {
                                                HapticFeedback.lightImpact();

                                                _setExerciseType('Weight');
                                              }),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: exerciseTypeSelected ?
                                                  cardioExercise ? secondaryColor : primaryAccentColor
                                                  : secondaryColor,
                                                padding: const EdgeInsets.all(4),
                                              ),
                                              child: Text('Weight',
                                                  style: TextStyle(color: exerciseTypeSelected ?
                                                    cardioExercise ?
                                                        Colors.grey
                                                        : textColorOverwrite ? Colors.black : primaryColor
                                                    : Colors.grey,
                                                      fontSize: 16
                                                  )
                                              ),
                                            )
                                        ),
                                        Spacer(),
                                ]),

                                /////////////////////

                                SizedBox(height: 15),

                                /// Exercise Name Field
                                exerciseTypeSelected
                                    ? Column(children: [
                                        TextFormField(
                                          focusNode: _hintTextFocusNode,
                                          onTap: () {
                                            _hintTextShowing = false;
                                          },
                                          style: TextStyle(
                                              color: Colors.blue.shade400,
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
                                        SizedBox(height: 2),
                                      ])
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 5),
                                          Divider(color: primaryColor),
                                          Text('Select an Exercise Category.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'AstroSpace',
                                                color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                                fontSize: 12)
                                          ),
                                          Divider(color: primaryColor),
                                          SizedBox(height: 5),
                                  ]),

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
                                      HapticFeedback.lightImpact();

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
                                        ? () async {
                                      HapticFeedback.lightImpact();

                                      if (editMode) {
                                        /// Edit Mode
                                        String exerciseName = newExerciseName.isNotEmpty ? newExerciseName : currentExerciseName;
                                        await updateExerciseRecord(exerciseName);
                                        Navigator.of(context).pop(true);
                                        widget.updateNewLogsMenu();
                                      } else {
                                        /// New Log Mode
                                        await insertNewExerciseRecord(newExerciseName, cardioExercise);
                                        Navigator.of(context).pop(true);
                                        widget.updateNewLogsMenu();
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
  int currentTimeline = logTimeline; // Controls how many months back we will query

  // This Widget is shown whenever an individual exercise is selected
  Widget buildTableForSelectedExercise() {
    for (var item in exerciseMap) {
      if (item['selected'] == true) {
        // Check if selected item has Items to build a table from
        if (weightedWorkoutMap.isEmpty) {
          /// No Logs Found
          return Column(children: [
            SizedBox(height: 10),
              Text('No logs found.',
                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, color: primaryColor, height: 1.1),
              ),
              SizedBox(height: 10),

              currentTimeline == 0
                  ? Container(
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
                          onLongPress: () async {
                            HapticFeedback.lightImpact();

                            // Fire DATABASE Event to delete Exercise
                            await deleteExercise();
                            widget.updateTables();
                            setState(() {
                              subMenuOpen = false;
                            });
                          },
                        )
                  )
                  : Container(),

            SizedBox(height: 15),
          ]);
        } else {
          /// There are Items, build table
          return Container(
              width: 295,
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
                  0: FlexColumnWidth(1.6),  // Date
                  1: FlexColumnWidth(1.7),  // Weight
                  2: FlexColumnWidth(3),  // Reps
                  4: FlexColumnWidth(1),   // Edit
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      TableCell(child:
                      Column(children: [
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              // Flip the sort order and refresh the workout list.
                              newestItemsFirst = !newestItemsFirst;
                              sortLogByNewest = newestItemsFirst;
                              setBooleanSetting('sortLogByNewest', newestItemsFirst);
                              getWorkouts();
                            });
                          },
                          child: Row(children:[
                              Icon(newestItemsFirst ? Icons.arrow_drop_down : Icons.arrow_drop_up, size: 15,
                                  color: textColorOverwrite
                                    ? primaryColor
                                    : secondaryAccentColor),
                              Text('Date',
                                style: TextStyle(fontFamily: 'AstroSpace',
                                    fontSize: 15, color: textColorOverwrite
                                        ? primaryColor
                                        : secondaryAccentColor
                                ))
                        ])),
                        Divider(color: textColorOverwrite
                            ? primaryColor
                            : secondaryAccentColor),
                      ])
                      ),
                      TableCell(child:
                      Column(children: [
                        SizedBox(height: 10),
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
                        SizedBox(height: 10),
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
                        SizedBox(height: 10),
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
                                  HapticFeedback.lightImpact();

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
                                                HapticFeedback.lightImpact();

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
                                                  HapticFeedback.lightImpact();

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
                                    widget.updateTables();
                                    getExercises();

                                    if (restartRequired == true) {
                                      //
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

  setTimeline(months) {
    setState(() {
      if (currentTimeline == months) {
        currentTimeline = 0;
        logTimeline = 0;
        setIntSetting('logTimeline', 0);
      } else {
        currentTimeline = months;
        logTimeline = months;
        setIntSetting('logTimeline', months);
      }
    });

    getWorkouts();
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

    if (currentTimeline == 0) {
      // This logic block indicates we should grab all records as there is no restraint on how far back we should search
        if (newestItemsFirst) {
          items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, false, 'date DESC');
        } else {
          items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, false, 'date ASC');
        }
    } else {
      // With a timeline set, we will set a date that will filter older records
      var latestDate = DateTime.now();

      if (currentTimeline == 12) {
        latestDate = DateTime(latestDate.year - 1);
      } else {
        latestDate = latestDate.subtract(Duration(days: (30 * currentTimeline)));
      }

      // Format the date so it can be queried against Database records
      String formattedDate = '${_padZero(latestDate.month)}/${_padZero(latestDate.day)}/${latestDate.year} 00:00:00';

      if (newestItemsFirst) {
        items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, false, 'date DESC', formattedDate);
      } else {
        items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, false, 'date ASC', formattedDate);
      }
    }

    setState(() {
      weightedWorkoutMap = items;
    });
  }

  static String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  Future<void> deleteExercise() async {
    await DatabaseHelper.instance.deleteExercise(selectedExercise);
    _showNotification(context);
  }

  // Helper function that will display little notification overlay at the bottom of the screen
  void _showNotification(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Container(
          height: 33,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Exercise Deleted",
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
  void initState() {
    super.initState();
    getExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: subMenuOpen ? 550 : 300,
        width: 300,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                            /// Each Exercise Row
                            Container(
                            width: exerciseMap[index]['selected'] ? 195 : 250,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: exerciseMap[index]['selected'] ? primaryColor : Colors.transparent,
                                  width: 4,
                                )),
                            child: ElevatedButton(
                              onPressed: () => setState(() {
                                HapticFeedback.lightImpact();

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
                                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 16, height: 1.1,
                                    color: textColorOverwrite ? Colors.black : primaryColor
                                ),),
                            ),
                          ),

                            /// Edit Exercise Button
                            exerciseMap[index]['selected']
                                ? IconButton(
                              splashRadius: 20,
                              onPressed: () => setState(() {
                                HapticFeedback.lightImpact();

                                for (int i = 0; i < exerciseMap.length; i++) {
                                  if (i == index) {
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
                                          updateNewLogsMenu: widget.updateTables,
                                          header: 'Edit Exercise',
                                          initialExerciseName: exerciseMap[i]['name'],
                                        );
                                      },
                                    ).then((restartRequired) {
                                      getExercises();

                                      if (restartRequired == true) {
                                        //
                                      }
                                    });
                                  }
                                }
                              }),
                              icon: Icon(Icons.edit, color: primaryColor),
                            )
                                : Container(),
                  ]),

                        // If current index is selected, render it's widget
                        exerciseMap[index]['selected']
                            ? Column(children: [

                                Divider(color: primaryColor),
                                Column(children: [
                                  Row(children: [
                                    Text("Months: ", style: TextStyle(fontFamily: 'AstroSpace',
                                        fontSize: 14, color: primaryColor)
                                    ),

                                    // 1 Month Button
                                    Container(
                                        width: 45,
                                        height: 45,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: currentTimeline == 1 ? primaryAccentColor : secondaryColor,
                                            padding: const EdgeInsets.all(4),
                                          ),
                                          onPressed: () => setTimeline(1),
                                          child: Text('1',
                                              style: TextStyle(
                                                color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                                fontSize: 20.0,
                                              )),
                                        )
                                    ),

                                    // 3 Month Button
                                    Container(
                                        width: 45,
                                        height: 45,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: currentTimeline == 3 ? primaryAccentColor : secondaryColor,
                                            padding: const EdgeInsets.all(4),
                                          ),
                                          onPressed: () => setTimeline(3),
                                          child: Text('3',
                                              style: TextStyle(
                                                color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                                fontSize: 20.0,
                                              )),
                                        )
                                    ),

                                    // 6 Month Button
                                    Container(
                                        width: 45,
                                        height: 45,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: currentTimeline == 6 ? primaryAccentColor : secondaryColor,
                                            padding: const EdgeInsets.all(4),
                                          ),
                                          onPressed: () => setTimeline(6),
                                          child: Text('6',
                                              style: TextStyle(
                                                color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                                fontSize: 20.0,
                                              )),
                                        )
                                    ),

                                    // 12 Month Button
                                    Container(
                                        width: 45,
                                        height: 45,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: currentTimeline == 12 ? primaryAccentColor : secondaryColor,
                                            padding: const EdgeInsets.all(4),
                                          ),
                                          onPressed: () => setTimeline(12),
                                          child: Text('12',
                                              style: TextStyle(
                                                color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                                fontSize: 20.0,
                                              )),
                                        )
                                    ),
                                  ]),
                                ]),
                                Divider(color: primaryColor),

                                /// Table Here
                                SizedBox(height: 5),
                                buildTableForSelectedExercise(),
                                SizedBox(height: 5),
                            ])
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
  int currentTimeline = logTimeline; // Controls how many months back we will query

  void _showNotification(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Container(
          height: 33,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Exercise Deleted",
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

  // This Widget is shown whenever an individual exercise is selected
  Widget buildTableForSelectedExercise() {
    for (var item in exerciseMap) {
      if (item['selected'] == true) {
        // Check if selected item has Items to build a table from
        if (cardioWorkoutMap.isEmpty) {
          /// No Logs Found
          return Column(children: [
            SizedBox(height: 10),
            Text('No logs found.',
              style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, color: primaryColor, height: 1.1),
            ),
            SizedBox(height: 10),

            currentTimeline == 0
              ? Container(
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
                      onLongPress: () async {
                        HapticFeedback.lightImpact();

                        // Fire DATABASE Event to delete Exercise
                        await deleteExercise();
                        widget.updateTables();
                        setState(() {
                          subMenuOpen = false;
                        });
                      },
                    )
                )
            : Container(),

            SizedBox(height: 15),
          ]);
        } else {
          /// There are Items, build table
          return Container(
              width: 295,
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
                  0: FlexColumnWidth(1.8),  // Date
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
                        SizedBox(height: 10),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                // Flip the sort order and refresh the workout list.
                                newestItemsFirst = !newestItemsFirst;
                                sortLogByNewest = newestItemsFirst;
                                setBooleanSetting('sortLogByNewest', newestItemsFirst);
                                getWorkouts();
                              });
                            },
                            child: Row(children:[
                              Icon(newestItemsFirst ? Icons.arrow_drop_down : Icons.arrow_drop_up, size: 15,
                                  color: textColorOverwrite
                                      ? primaryColor
                                      : secondaryAccentColor),
                              Text('Date',
                                  style: TextStyle(fontFamily: 'AstroSpace',
                                      fontSize: 15, color: textColorOverwrite
                                          ? primaryColor
                                          : secondaryAccentColor
                                  ))
                            ])),
                        Divider(color: textColorOverwrite
                            ? primaryColor
                            : secondaryAccentColor),
                      ])
                      ),
                      TableCell(child:
                      Column(children: [
                        SizedBox(height: 10),
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
                        SizedBox(height: 10),
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
                        SizedBox(height: 10),
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
                        SizedBox(height: 10),
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
                                  HapticFeedback.lightImpact();

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
                                                HapticFeedback.lightImpact();

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
                                                  HapticFeedback.lightImpact();

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
                                    widget.updateTables();
                                    getExercises();

                                    if (restartRequired == true) {
                                      //
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

  setTimeline(months) {
    setState(() {
      if (currentTimeline == months) {
        currentTimeline = 0;
        logTimeline = 0;
        setIntSetting('logTimeline', 0);
      } else {
        currentTimeline = months;
        logTimeline = months;
        setIntSetting('logTimeline', months);
      }
    });

    getWorkouts();
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

    if (currentTimeline == 0) {
      // This logic block indicates we should grab all records as there is no restraint on how far back we should search
      if (newestItemsFirst) {
        items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, true, 'date DESC');
      } else {
        items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, true, 'date ASC');
      }
    } else {
      // With a timeline set, we will set a date that will filter older records
      var latestDate = DateTime.now();

      if (currentTimeline == 12) {
        latestDate = DateTime(latestDate.year - 1);
      } else {
        latestDate = latestDate.subtract(Duration(days: (30 * currentTimeline)));
      }

      // Format the date so it can be queried against Database records
      String formattedDate = '${_padZero(latestDate.month)}/${_padZero(latestDate.day)}/${latestDate.year} 00:00:00';

      if (newestItemsFirst) {
        items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, true, 'date DESC', formattedDate);
      } else {
        items = await DatabaseHelper.instance.getMapOfWorkoutsUsingExerciseName(selectedExercise, true, 'date ASC', formattedDate);
      }
    }

    setState(() {
      cardioWorkoutMap = items;
    });
  }

  static String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  Future<void> deleteExercise() async {
    await DatabaseHelper.instance.deleteExercise(selectedExercise);
    _showNotification(context);
  }

  @override
  void initState() {
    super.initState();
    getExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: subMenuOpen ? 550 : 300,
        width: 300,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                              /// Each Exercise Row
                              Container(
                                width: exerciseMap[index]['selected'] ? 195 : 250,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: exerciseMap[index]['selected'] ? primaryColor : Colors.transparent,
                                      width: 4,
                                    )),
                                child: ElevatedButton(
                                  onPressed: () => setState(() {
                                    HapticFeedback.lightImpact();

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
                                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 16, height: 1.1,
                                        color: textColorOverwrite ? Colors.black : primaryColor
                                    ),),
                                ),
                              ),


                              /// Edit Exercise Button
                              exerciseMap[index]['selected']
                                  ? IconButton(
                                splashRadius: 20,
                                onPressed: () => setState(() {
                                  HapticFeedback.lightImpact();

                                  for (int i = 0; i < exerciseMap.length; i++) {
                                    if (i == index) {
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
                                            updateNewLogsMenu: widget.updateTables,
                                            header: 'Edit Exercise',
                                            initialExerciseName: exerciseMap[i]['name'],
                                          );
                                        },
                                      ).then((restartRequired) {
                                        getExercises();

                                        if (restartRequired == true) {
                                          //
                                        }
                                      });
                                    }
                                  }
                                }),
                                icon: Icon(Icons.edit, color: primaryColor),
                              )
                                  : Container(),
                            ]),

                        // If current index is selected, render it's widget
                        exerciseMap[index]['selected']
                            ? Column(children: [
                          Divider(color: primaryColor),
                          Column(children: [
                            Row(children: [
                              Text("Months: ", style: TextStyle(fontFamily: 'AstroSpace',
                                  fontSize: 14, color: primaryColor)
                              ),

                              // 1 Month Button
                              Container(
                                  width: 45,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: currentTimeline == 1 ? primaryAccentColor : secondaryColor,
                                      padding: const EdgeInsets.all(4),
                                    ),
                                    onPressed: () => setTimeline(1),
                                    child: Text('1',
                                        style: TextStyle(
                                          color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                          fontSize: 20.0,
                                        )),
                                  )
                              ),

                              // 3 Month Button
                              Container(
                                  width: 45,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: currentTimeline == 3 ? primaryAccentColor : secondaryColor,
                                      padding: const EdgeInsets.all(4),
                                    ),
                                    onPressed: () => setTimeline(3),
                                    child: Text('3',
                                        style: TextStyle(
                                          color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                          fontSize: 20.0,
                                        )),
                                  )
                              ),

                              // 6 Month Button
                              Container(
                                  width: 45,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: currentTimeline == 6 ? primaryAccentColor : secondaryColor,
                                      padding: const EdgeInsets.all(4),
                                    ),
                                    onPressed: () => setTimeline(6),
                                    child: Text('6',
                                        style: TextStyle(
                                          color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                          fontSize: 20.0,
                                        )),
                                  )
                              ),

                              // 12 Month Button
                              Container(
                                  width: 45,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: currentTimeline == 12 ? primaryAccentColor : secondaryColor,
                                      padding: const EdgeInsets.all(4),
                                    ),
                                    onPressed: () => setTimeline(12),
                                    child: Text('12',
                                        style: TextStyle(
                                          color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                          fontSize: 20.0,
                                        )),
                                  )
                              ),
                            ]),
                          ]),
                          Divider(color: primaryColor),


                          /// Table Here
                                  SizedBox(height: 5),
                                  buildTableForSelectedExercise(),
                                  SizedBox(height: 5),
                        ])
                            : SizedBox(height: 4),
                      ]);
                },
              )),
            ])
    );
  }
}


//////////////////////////////
// Widget for Config Stuff
//////////////////////////////
class LogsConfigWidget extends StatefulWidget {
  const LogsConfigWidget({
    super.key,
  });

  @override
  LogsConfigWidgetState createState() => LogsConfigWidgetState();
}

class LogsConfigWidgetState extends State<LogsConfigWidget> {
  late String filename;
  int recordsInsertedCount = 0;

  Future<void> exportRecordsToCsv(String exerciseType, String filename) async {
    List<Map<String, dynamic>> items;
    if (exerciseType == 'Cardio') {
      items = await DatabaseHelper.instance.queryCardioRecords();
    } else {
      items = await DatabaseHelper.instance.queryWeightedRecords();
    }

    String csvString = convertToCSV(items);
    writeRecordsToFile(csvString, filename);
  }

  String convertToCSV(List<Map<String, dynamic>> data) {
    String csvString = '';

    // Add the CSV header (column names)
    List<String> columnNames = data[0].keys.toList();
    csvString += columnNames.join(',') + '\n';

    // Add the data rows
    data.forEach((row) {
      List<dynamic> rowData = row.values.toList();
      csvString += rowData.join(',') + '\n';
    });

    return csvString;
  }

  Future<File> writeRecordsToFile(String bytes,String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name.csv');

    // Write the data in the file you have created
    return file.writeAsString(bytes);
  }

  Future<String> get _localPath async {
    // Get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  Future<String> getExternalDocumentPath() async {
    // Check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not, ask for permission first
      await Permission.storage.request();
    }

    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      // removed plugin path_provider to focus on Android implementation
      // _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

// Helper function that will display little notification overlay at the bottom of the screen
  void _showNotification(BuildContext context, String filename, String action, int count) {
    final snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Container(
          height: 33,
          child: action == 'Export'
              ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Logs Successfully Exported",
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                      color: secondaryColor,
                    )
                ),
                SizedBox(height: 5),
                Text("Downloads/${filename}.csv",
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                      color: secondaryColor,
                    )
                ),
              ])
              : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$count Log(s) Imported",
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                      color: secondaryColor,
                    )
                ),
                SizedBox(height: 5),
                Text("From file: ${filename}",
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                      color: secondaryColor,
                    )
                ),
              ])
      ),
      duration: Duration(seconds: 6), // Set the duration for how long the SnackBar will be displayed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// Helper function to handle DB inserts after the user Imports a csv file
  Future<void> _handleDatabaseInsertsFromImport(String contents, bool keepDuplicates) async {
    late bool cardioExercise;
    var transformedData = [];

    // Rows are separated by new lines
    var contentInRows = contents.split('\n');
    for (int i = 0; i < contentInRows.length - 1; i++) {
      // Columns are separated by commas
      transformedData.add(contentInRows[i].split(','));
    }

    if (transformedData.length == 1) {
      // This data is either missing a header or data. Exit from here
      exit;
    }

    if (transformedData[0][5] == 'workTime') {
      // Import is for Cardio
      cardioExercise = true;

    } else if (transformedData[0][5] == 'weight') {
      cardioExercise = false;

    } else {
      // ERROR
      // TODO Launch error notification
      exit;
    }

    recordsInsertedCount = 0;
    for (int i = 1; i < transformedData.length ; i++) {
      if (transformedData[i].length > 1) {
        await attemptDBInsert(transformedData[i], cardioExercise, keepDuplicates);
      }
    }
  }

  insertExerciseName(String exerciseName, bool isCardio) async {
    await DatabaseHelper.instance.insertExercise(exerciseName, isCardio);
  }

  Future<int?> getExerciseId(String exerciseName) async {
    return await DatabaseHelper.instance.getExerciseIdByName(exerciseName);
  }

  Future<void> attemptDBInsert(var contentArray, bool cardioExercise, bool keepDuplicates) async {
    String exerciseName = contentArray[1];
    String date = contentArray[4];

    // Ensure the provided exercise exists in the DB.
    var exerciseId = await getExerciseId(exerciseName);
    if (exerciseId == null) {
      await insertExerciseName(exerciseName, cardioExercise);
    }

    Map<String, dynamic>  data;
    if (cardioExercise) {
      int workTime = int.parse(contentArray[5]);
      int restTime = int.parse(contentArray[6]);
      int interval = int.parse(contentArray[7]);

      // Data for Cardio Insert
      data = {
        'exerciseId': '', // will be updated in database_helper
        'date': date,
        'workTime': workTime,
        'restTime': restTime,
        'intervals': interval,
      };
    } else {
      // Weight Exercise
      int weight = int.parse(contentArray[5]);
      int rep1 = int.parse(contentArray[6]);
      int rep2 = int.parse(contentArray[7]);
      int rep3 = int.parse(contentArray[8]);
      int rep4 = int.parse(contentArray[9]);

      // Data for Weight Insert
      data = {
        'exerciseId': '', // will be updated in database_helper
        'date': date,
        'weight': weight,
        'rep1': rep1,
        'rep2': rep2,
        'rep3': rep3,
        'rep4': rep4,
      };
    }

    var insertCount = await DatabaseHelper.instance.insertWorkoutForImport(cardioExercise, data, exerciseName, keepDuplicates);

    setState(() {
      recordsInsertedCount += insertCount;
    });
  }

  // Used to determine if any records exist for a given table
      // before moving forward with an export.
  Future<bool> checkForRecord(String table) async {
    return await DatabaseHelper.instance.recordExists(table);
  }

  // Helper function that will display little notification overlay at the bottom of the screen
  void _showMissingRecordsNotification(BuildContext context, String table) {
    final snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Container(
          height: 33,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Unable to Export",
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                      color: Colors.red,
                    )
                ),
                SizedBox(height: 5),
                Text("No $table Logs found",
                    style: const TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                      color: Colors.red,
                    )
                ),
              ])
      ),
      duration: Duration(seconds: 4), // Set the duration for how long the SnackBar will be displayed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5),

          Container(
              width: 225,
              padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2,
                        color: primaryColor
                    )
                ),
                child: Text("This app does not collect user data. Use this menu to create and restore local backups of your logs.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontSize: 17, color: primaryColor))
          ),

          SizedBox(height: 15),

          Text('Export Logs:',
              style: TextStyle(fontFamily: 'AstroSpace',
                  fontSize: 18, color: primaryColor)
          ),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
            /// EXPORT Cardio Logs
            ElevatedButton(
              child: Text('Cardio Logs'),
              onPressed: () async {
                HapticFeedback.lightImpact();

                // Check if logs exist:
                if (await checkForRecord('cardio_workouts')) {
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
                        child: ConfirmExportImportWidget(
                            exerciseType: 'Cardio',
                            exportingFile: true,
                            key: UniqueKey()
                        ),
                      );
                    },
                  ).then((response) {
                    if (response == false) {
                      // Export was canceled, do nothing
                    } else {
                      Map<String, dynamic> responseFormatted = response as Map<String, dynamic>;
                      exportRecordsToCsv('Cardio', responseFormatted!['filename']);
                      _showNotification(context, responseFormatted!['filename'], 'Export', 0);

                      setState(() {
                        filename = responseFormatted!['filename'];
                      });
                    }
                  });
                } else {
                  // We were unable to find any records on this table, show notification
                  _showMissingRecordsNotification(context, 'Cardio');
                }
              },
            ),
            SizedBox(width: 25),
            /// EXPORT Weight Logs
            ElevatedButton(
              child: Text('Weight Logs'),
              onPressed: () async {
                HapticFeedback.lightImpact();

                // Check if logs exist:
                if (await checkForRecord('weighted_workouts')) {
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
                        child: ConfirmExportImportWidget(
                            exerciseType: 'Weight',
                            exportingFile: true,
                            key: UniqueKey()
                        ),
                      );
                    },
                  ).then((response) {
                    if (response == false) {
                      // Export was canceled, do nothing
                    } else {
                      Map<String, dynamic> responseFormatted = response as Map<String, dynamic>;
                      exportRecordsToCsv('Weight', responseFormatted!['filename']);
                      _showNotification(context, responseFormatted!['filename'], 'Export', 0);

                      setState(() {
                        filename = responseFormatted!['filename'];
                      });
                    }
                  });
                } else {
                  // We were unable to find any records on this table, show notification
                  _showMissingRecordsNotification(context, 'Weight');
                }
              },
            ),
          ]),
          Container(
            width: 300,
            child: Divider(color: primaryColor),
          ),
          SizedBox(height: 10),

          Text('Import Logs:',
              style: TextStyle(fontFamily: 'AstroSpace',
                  fontSize: 18, color: primaryColor)
          ),
          SizedBox(height: 10),
          /// IMPORT Logs
          ElevatedButton(
            child: Text('Import'),
            onPressed: () async {
              HapticFeedback.lightImpact();

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
                    child: ConfirmExportImportWidget(
                        exerciseType: 'Import',
                        exportingFile: false,
                        key: UniqueKey()
                    ),
                  );
                },
              ).then((response) async {
                if (response == false) {
                  // Export was canceled, do nothing
                } else {
                  Map<String, dynamic> responseFormatted = response as Map<String, dynamic>;

                  // Handle inserting contents
                  var fileContents = responseFormatted!['fileContents'];
                  bool keepDups = responseFormatted!['keepDuplicates'];
                  await _handleDatabaseInsertsFromImport(fileContents, keepDups);
                  _showNotification(context, responseFormatted!['filename'], 'Import', recordsInsertedCount);

                  setState(() {
                    filename = responseFormatted!['filename'];
                  });
                }
              });
            },
          ),
          SizedBox(height: 5),
          Container(
            width: 225,
            child: Divider(color: primaryColor),
          ),
          SizedBox(height: 20),
            ]);
  }
}

class ConfirmExportImportWidget extends StatefulWidget {
  String exerciseType;
  bool exportingFile;

  ConfirmExportImportWidget({
    required this.exerciseType,
    required this.exportingFile,
    super.key
  });
  @override
  ConfirmExportImportWidgetState createState() => ConfirmExportImportWidgetState();
}

class ConfirmExportImportWidgetState extends State<ConfirmExportImportWidget> {
  bool enableConfirmButton = true;
  late String filename;
  String fileContents = '';
  bool keepDuplicates = false;
  String handleDuplicates = 'Skipping duplicates';

  void _changeDuplicateHandling(bool x) {
    setState(() {
      keepDuplicates = !keepDuplicates;
      if (keepDuplicates) {
        handleDuplicates = 'Inserting duplicates';
      } else {
        handleDuplicates = 'Skipping duplicates';
      }
    });
  }

  Future<void> _openCsvFile() async {
    // We only want the most recent files so clear temp cache
    await FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      // allowedExtensions: ['csv', 'txt', 'text'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var fileArray = file.path.split('/');
      String contents = await file.readAsString();

      setState(() {
        filename = fileArray[fileArray.length - 1];
        fileContents = contents;
        enableConfirmButton = true;
      });
    } else {
      // User canceled the file picker
      setState(() {
        enableConfirmButton = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    DateTime currentDate = DateTime.now();
    String today = DateFormat('MM-dd-yy').format(currentDate);

    filename = "${widget.exerciseType}($today)";
    if (!widget.exportingFile) {
      // Launch File picker for Imports:
      _openCsvFile();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
                        height: widget.exportingFile ? 275 : 365,
                        width: 210,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: primaryColor,
                                  width: 1,
                                )
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              SizedBox(height: 10),

                              widget.exportingFile
                                  ? Text('Confirm Export',
                                      style: TextStyle(
                                          color: textColorOverwrite ? Colors.black : primaryColor,
                                          fontSize: 20),
                                    )
                                  : Text('Confirm Import',
                                      style: TextStyle(
                                          color: textColorOverwrite ? Colors.black : primaryColor,
                                          fontSize: 20),
                                    ),

                              Divider(color: primaryColor),
                              SizedBox(height: 5),

                              /// File Name Field
                              widget.exportingFile
                                  ? Text(filename,
                                        style: TextStyle(
                                              fontSize: 20,
                                              color: primaryColor,
                                            ),
                              )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: enableConfirmButton ? secondaryColor : primaryAccentColor,
                                          // textStyle: TextStyle(
                                          //     color: labelColor ?? Colors.black87
                                          // )
                                      ),
                                      onPressed: () {
                                        HapticFeedback.lightImpact();

                                        _openCsvFile();
                                      },
                                      child: Text(filename,
                                          style: TextStyle(
                                            color: appCurrentlyInDarkMode ? Colors.white : Colors.black,
                                            fontSize: 13,
                                          )),
                                    ),

                              SizedBox(height: 10),
                              Text('Filename',
                                style: TextStyle(
                                // backgroundColor: primaryAccentColor,
                                    fontFamily: 'AstroSpace',
                                  color: textColorOverwrite ? Colors.black : primaryColor,
                                  fontSize: 10)
                              ),

                              SizedBox(height: 10),

                              widget.exportingFile
                                  ? Container()
                                  :  Container(
                                        width: 175,
                                        child: Divider(color: primaryColor),
                                      ),

                                  /// Toggle to handle duplicates
                              widget.exportingFile
                                  ? Container()
                                  : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Off',
                                        style: TextStyle(
                                          // backgroundColor: primaryAccentColor,
                                            color: keepDuplicates ? Colors.grey : primaryAccentColor,
                                            fontSize: 14)
                                    ),

                                    SizedBox(width: 10),
                                    Column(children: [
                                      Switch(
                                        value: keepDuplicates,
                                        onChanged: _changeDuplicateHandling,
                                      ),
                                      Text('Duplicates',
                                          style: TextStyle(
                                            // backgroundColor: primaryAccentColor,
                                              fontFamily: 'AstroSpace',
                                              color: textColorOverwrite ? Colors.black : primaryColor,
                                              fontSize: 10)
                                      )
                                    ]),
                                    SizedBox(width: 10),

                                    Text('On',
                                        style: TextStyle(
                                          // backgroundColor: primaryAccentColor,
                                            color: keepDuplicates ? primaryAccentColor : Colors.grey,
                                            fontSize: 14)
                                    ),
                              ]),


                              Container(
                                width: 175,
                                child: Divider(color: primaryColor),
                              ),

                              SizedBox(height: 5),

                              Padding(padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: widget.exportingFile
                                  ? Text('Click Confirm to download a .csv file of all ${widget.exerciseType} logs',
                                    textAlign: TextAlign.center,
                                      style: TextStyle(
                                        // backgroundColor: primaryAccentColor,
                                          color: textColorOverwrite ? Colors.black : primaryColor,
                                          fontSize: 14)
                                    )
                                  :Text('Click Confirm to Import the above .csv into Logs (${handleDuplicates}).',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // backgroundColor: primaryAccentColor,
                                        color: textColorOverwrite ? Colors.black : primaryColor,
                                        fontSize: 14)
                                )
                              ),

                              SizedBox(height: 5),

                              Container(
                                width: 175,
                                child: Divider(color: primaryColor),
                              ),

                              SizedBox(height: 5),


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
                                    HapticFeedback.lightImpact();

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
                                      HapticFeedback.lightImpact();

                                      // Other logic can also go here
                                      Navigator.of(context).pop({
                                        'filename': filename,
                                        'fileContents': fileContents,
                                        'keepDuplicates': keepDuplicates
                                      });
                                    } : null,
                                    child: const Text("Confirm",
                                      style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
                                    )
                                ),
                                const Spacer(),
                              ]),

                              SizedBox(height: 5),
                                ])
                        )
                    ))
            )
        )
    );
  }
}