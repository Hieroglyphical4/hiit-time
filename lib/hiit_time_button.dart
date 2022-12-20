import 'package:flutter/material.dart';

// void main() {
//   runApp(const MaterialApp(home: Home()));
// }

class HiitTimeButton extends StatefulWidget {
  const HiitTimeButton({
    super.key,
    required this.selected,
    this.style,
    required this.onPressed,
    required this.child,
  });

  final bool selected;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<HiitTimeButton> createState() => _HiitTimeButtonState();
}

class _HiitTimeButtonState extends State<HiitTimeButton> {
  late final MaterialStatesController statesController;

  @override
  void initState() {
    super.initState();
    statesController = MaterialStatesController(
        <MaterialState>{if (widget.selected) MaterialState.selected});
  }

  @override
  void didUpdateWidget(HiitTimeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      statesController.update(MaterialState.selected, widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      statesController: statesController,
      style: widget.style,
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}

// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   bool selected = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: HiitTimeButton(
//           selected: selected,
//           style: ButtonStyle(
//             foregroundColor: MaterialStateProperty.resolveWith<Color?>(
//                   (Set<MaterialState> states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return Colors.white;
//                 }
//                 return null; // defer to the defaults
//               },
//             ),
//             backgroundColor: MaterialStateProperty.resolveWith<Color?>(
//                   (Set<MaterialState> states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return Colors.indigo;
//                 }
//                 return null; // defer to the defaults
//               },
//             ),
//           ),
//           onPressed: () {
//             setState(() {
//               selected = !selected;
//             });
//           },
//           child: const Text('toggle selected'),
//         ),
//       ),
//     );
//   }
// }
