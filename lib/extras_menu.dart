// import 'package:hiit_time/plate_calculator.dart';
// import 'package:flutter/material.dart';
// import 'Config/settings.dart';
// import 'logs_widget.dart';
//
// ////////////////////////////////////////////////
// // Widget for all Button Audio related Settings (sub-submenu)
// ////////////////////////////////////////////////
// class ExtrasMenu extends StatefulWidget {
//   const ExtrasMenu({
//     required Key key,
//   }) : super(key: key);
//
//   @override
//   ExtrasMenuState createState() => ExtrasMenuState();
// }
//
// class ExtrasMenuState extends State<ExtrasMenu> {
//   bool _displayLogs = false;
//   bool _displayAboutThisApp = false;
//   bool _displayFaqs = false;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: secondaryAccentColor,
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//           backgroundColor: primaryAccentColor,
//           centerTitle: true,
//           title: Text('Extras', style: TextStyle(
//               color: textColorOverwrite
//                   ? appCurrentlyInDarkMode ? Colors.black : Colors.white
//                   : alternateColorOverwrite ? Colors.black
//                   : Colors.white
//           ),
//           ),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: textColorOverwrite
//                 ? appCurrentlyInDarkMode ? Colors.black : Colors.white
//                 : alternateColorOverwrite ? Colors.black
//                 : Colors.white
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.calculate_outlined, color: textColorOverwrite
//                   ? appCurrentlyInDarkMode ? Colors.black : Colors.white
//                   : alternateColorOverwrite ? Colors.black
//                   : Colors.white
//               ),
//               onPressed: () {
//                 // Launch Extras Menu
//                 showGeneralDialog(
//                   context: context,
//                   barrierDismissible: true,
//                   barrierLabel: MaterialLocalizations.of(context)
//                       .modalBarrierDismissLabel,
//                   barrierColor: Colors.black45,
//                   transitionDuration: const Duration(milliseconds: 200),
//
//                   // ANY Widget can be passed here
//                   pageBuilder: (BuildContext buildContext,
//                       Animation animation,
//                       Animation secondaryAnimation) {
//                     return Center(
//                       child: PlateCalculator(key: UniqueKey(),),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       body: Center(
//         child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // TODO Put stuff here
//                 // Logs
//                 // About this App
//                 // FAQs
//
//                 SizedBox(height: 50),
//
//                 ///////////////////////////
//                 // Logs Button
//                 ///////////////////////////
//                 SizedBox(
//                     height: 60,
//                     width: 350,
//                     child: ElevatedButton(
//                         onPressed: () => setState(() {
//                           if (_displayLogs) {
//                             _displayLogs = false;
//                           } else {
//                             _displayLogs = true;
//                             _displayAboutThisApp = false;
//                             _displayFaqs = false;
//                           }
//                         }),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: secondaryColor,
//                           padding: const EdgeInsets.all(4),
//                         ),
//                         child: Text(_displayLogs
//                             ? '-             Logs             -'
//                             : 'Logs                             >',
//                             style: TextStyle(fontFamily: 'AstroSpace', fontSize: 25, height: 1.1,
//                                 color: textColorOverwrite
//                                     ? appCurrentlyInDarkMode ? Colors.black : Colors.white
//                                     : alternateColorOverwrite ? Colors.black
//                                     : appCurrentlyInDarkMode ? Colors.white : Colors.black
//                             ),
//                             textAlign: TextAlign.center
//                         )
//                     )
//                 ),
//
//                 // Determine if Logs Widget should show:
//                 _displayLogs
//                     ? LogsWidget(key: UniqueKey(),)
//                     : Container(),
//
//                 SizedBox(height: 20),
//                 ///////////////////////////
//                 // FAQs Button
//                 ///////////////////////////
//                 SizedBox(
//                     height: 60,
//                     width: 350,
//                     child: ElevatedButton(
//                         onPressed: () => setState(() {
//                           if (_displayFaqs) {
//                             _displayFaqs = false;
//                           } else {
//                             _displayFaqs = true;
//                             _displayLogs = false;
//                             _displayAboutThisApp = false;
//                           }
//                         }),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: secondaryColor,
//                           padding: const EdgeInsets.all(4),
//                         ),
//                         child: Text(_displayFaqs
//                             ? '-             FAQs             -'
//                             : 'FAQs                             >',
//                             style: TextStyle(fontFamily: 'AstroSpace', fontSize: 25, height: 1.1,
//                                 color: textColorOverwrite
//                                     ? appCurrentlyInDarkMode ? Colors.black : Colors.white
//                                     : alternateColorOverwrite ? Colors.black
//                                     : appCurrentlyInDarkMode ? Colors.white : Colors.black
//                             ),
//                             textAlign: TextAlign.center
//                         )
//                     )
//                 ),
//
//                 // Determine if FAQ Widget should show:
//                 _displayFaqs
//                     ? FaqsWidget(key: UniqueKey(),)
//                     : Container(),
//
//                 SizedBox(height: 20),
//                 ///////////////////////////
//                 // About This App Button
//                 ///////////////////////////
//                 SizedBox(
//                     height: 60,
//                     width: 350,
//                     child: ElevatedButton(
//                         onPressed: () => setState(() {
//                           if (_displayAboutThisApp) {
//                             _displayAboutThisApp = false;
//                           } else {
//                             _displayAboutThisApp = true;
//                             _displayLogs = false;
//                             _displayFaqs = false;
//                           }
//                         }),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: secondaryColor,
//                           padding: const EdgeInsets.all(4),
//                         ),
//                         child: Text(_displayAboutThisApp
//                             ? '-   About This App   -'
//                             : 'About This App         >',
//                             style: TextStyle(fontFamily: 'AstroSpace', fontSize: 25, height: 1.1,
//                                 color: textColorOverwrite
//                                     ? appCurrentlyInDarkMode ? Colors.black : Colors.white
//                                     : alternateColorOverwrite ? Colors.black
//                                     : appCurrentlyInDarkMode ? Colors.white : Colors.black
//                             ),
//                             textAlign: TextAlign.center
//                         )
//                     )
//                 ),
//
//                 // Determine if About This App Widget should show:
//                 _displayAboutThisApp
//                     ? AboutThisAppWidget(key: UniqueKey(),)
//                     : Container(),
//
//                 SizedBox(height: 400),
//               ],
//             )
//         )
//       )
//     );
//   }
// }
//
// //////////////////////////////////////////
// // Widget for all FAQs (sub-submenu)
// //////////////////////////////////////////
// class FaqsWidget extends StatefulWidget {
//   const FaqsWidget({
//     required Key key,
//   }) : super(key: key);
//
//   @override
//   FaqsWidgetState createState() => FaqsWidgetState();
// }
//
// class FaqsWidgetState extends State<FaqsWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Text("Here are some Tips: ", style: TextStyle(fontSize: 30, color: textColorOverwrite ? Colors.black : Colors.white),);
//   }
// }
//
// /////////////////////////////////////////////////
// // Widget for About This App Info (sub-submenu)
// /////////////////////////////////////////////////
// class AboutThisAppWidget extends StatefulWidget {
//   const AboutThisAppWidget({
//     required Key key,
//   }) : super(key: key);
//
//   @override
//   AboutThisAppWidgetState createState() => AboutThisAppWidgetState();
// }
//
// class AboutThisAppWidgetState extends State<AboutThisAppWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 225,
//         child: Column(
//             children: [
//               Text("Thank you for downloading my first app.", style: TextStyle(fontSize: 30, color: textColorOverwrite ? Colors.black : Colors.white)),
//               SizedBox(height: 20),
//               Text("Email: app@gmail.com", style: TextStyle(fontSize: 30, color: textColorOverwrite ? Colors.black : Colors.white)),
//             ]
//         )
//     );
//   }
// }