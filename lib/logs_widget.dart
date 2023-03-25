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

class LogsWidgetState extends State<LogsWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO Display Pages based on options:
    // Workout, Day, Muscle Group
    return Text("User can track PRs here", style: TextStyle(fontSize: 30, color: primaryColor));
  }
}
